//
//  HRUtil.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/6.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define MEGA_BYTE 100*1024

static OSType pixelFormatType = kCVPixelFormatType_32ARGB;

@implementation HRUtil

+(void)saveImagesToVideoWithImages:(NSArray *)paths completed:(SaveVideoCompleted)completed andFailed:(SaveVideoFailed)failedBlock{
    [self saveImagesToVideoWithImages:paths
                         andAudioPath:nil
                            completed:completed
                            andFailed:failedBlock];
}

+(void)saveImagesToVideoWithImages:(NSArray *)paths
                      andAudioPath:(NSString *)audioPath
                         completed:(SaveVideoCompleted)completed
                         andFailed:(SaveVideoFailed)failedBlock{
    //数据为空就不需要了
    if(!paths && paths.count == 0)
        return;
    
    long long timeString = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"video%llu.mp4",timeString];
    NSString    *videoPath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    unlink([videoPath UTF8String]);
    
    __block    NSError     *error = nil;
    
    NSString *firstImage = [paths firstObject];
    //如果传的是相对的路径
    if(![firstImage hasPrefix:NSHomeDirectory()]){
        //自己处理，依据情况不同
    }
    UIImage *first = [UIImage imageWithContentsOfFile:firstImage];
    CGSize frameSize = first.size;
    
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:videoPath]
                                                         fileType:AVFileTypeQuickTimeMovie
                                                            error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error =%@", [error localizedDescription]);
    
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:frameSize.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:frameSize.height],AVVideoHeightKey,nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    
    AVAssetWriterInputPixelBufferAdaptor __block *adaptor =[AVAssetWriterInputPixelBufferAdaptor
                                                            assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        [videoWriter addInput:writerInput];
    else
        NSLog(@"failed add input");
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //开始合成图片
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData]){
            if(++frame >= [paths count] ){
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
//                    [self add];
                }];
                break;
            }
            
            UIImage *info = [UIImage imageWithContentsOfFile:[paths objectAtIndex:frame]];
            CVPixelBufferRef buffer = (__bridge CVPixelBufferRef)([self pixelBufferFromCGImage:info.CGImage size:frameSize]);
            if (buffer){
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,24)]){
                    if(failedBlock)
                        failedBlock(error);
                    CFRelease(buffer);
                }
                CFRelease(buffer);
            }
            else{
                CFRelease(buffer);
            }
        }
    }];
}

-(CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @YES, kCVPixelBufferCGImageCompatibilityKey,
                             @YES, kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameSize.width,
                                          frameSize.height,
                                          pixelFormatType,
                                          (__bridge CFDictionaryRef)options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipFirst & kCGBitmapAlphaInfoMask;
    
    //NSUInteger bytesPerRow = 4 * frameSize.width;
    NSUInteger bitsPerComponent = 8;
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pxbuffer);
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameSize.width,
                                                 frameSize.height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameSize.width, frameSize.height), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}


//向无声视频文件中加入声音
-(void)addAudioToFileAtPath:(NSString *)vidoPath andAudioPath:(NSString *)audioPath Success:(SaveVideoCompleted)successBlock failed:(SaveVideoFailed)failedBlock{
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSURL* audio_inputFileUrl = [NSURL fileURLWithPath:audioPath];
    NSURL* video_inputFileUrl = [NSURL fileURLWithPath:vidoPath];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *outputFilePath =[[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",@"testPlay"]];
    NSURL* outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    if ([videoAsset tracksWithMediaType:AVMediaTypeVideo].count != 0) {
        [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    audioAsset = nil;
    videoAsset = nil;
    
    AVAssetExportSession __block *  _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ){
        switch (_assetExport.status){
            case AVAssetExportSessionStatusCompleted:{
                if(successBlock)
                    successBlock(outputFilePath);
                break;
            }
            case AVAssetExportSessionStatusFailed:{
                if(failedBlock)
                    failedBlock(_assetExport.error);
                break;
            }
            case AVAssetExportSessionStatusCancelled:{
                
                break;
            }
            case AVAssetExportSessionStatusExporting:{
            }
                break;
            case AVAssetExportSessionStatusUnknown:{
            }
                break;
            case AVAssetExportSessionStatusWaiting:{
            }
                break;
        }
        
        _assetExport=nil;
    }];
    
}

+(void)convertVideoToGifWithVideo:(NSString *)videoPath completed:(SaveVideoCompleted)completed andFailed:(SaveVideoFailed)failedBlock{
    NSString    *dealPath = @"";
    __block    NSError     *error = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && completed) {
                completed(dealPath);
            }
            
            if(error && failedBlock){
                failedBlock(error);
            }
        });
    });
}
+(NSData *)dataFromImageForUpload:(UIImage *)image{
    NSData  *data = UIImageJPEGRepresentation(image, 1);
    double compressQuality = (double)MEGA_BYTE/(CGFloat)data.length;
    if(compressQuality < 0 ){
        data = UIImageJPEGRepresentation(image, compressQuality);
    }
    
    CGFloat screenWidth = 720;
    CGFloat imageWidth = MIN(image.size.width, image.size.height);
    CGFloat ratio = imageWidth / screenWidth;
    
    UIImage *dealImage = [UIImage imageWithData:data];
    if(ratio > 1){
        CGSize newSize = CGSizeMake(image.size.width / ratio, image.size.height / ratio);
        dealImage = [HRUtil imageWithImage:dealImage scaledToSize:newSize];
    }
    
    return UIImageJPEGRepresentation(dealImage, compressQuality>1?1:compressQuality*2);
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIColor *)getColorFromString:(NSString *)colorString{
    long x;
    NSString *_str;
    //如果是八位
    if([colorString length] == 9){
        //取前两位alpha值
        NSString *alpha = [colorString substringToIndex:3];
        
        //取后面的几位颜色值
        NSString *color = [colorString substringFromIndex:3];
        const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
        x = strtol(cStr+1, NULL, 16);
        //_str = [NSString stringWithFormat:@"#%@",color];
        
        return [HRUtil colorWithHex:(UInt32)x withAlpha:alpha];
    }
    //如果是6位的颜色
    else if([colorString length] == 7){
        const char *cStr = [colorString cStringUsingEncoding:NSASCIIStringEncoding];
        x = strtol(cStr+1, NULL, 16);
        _str = @"#FF";
    }
    //如果格式不对就直接返回黑色颜色
    else
        return [UIColor blackColor];
    return [self colorWithHex:(UInt32)x withAlpha:_str];
}

+(UIColor *)colorWithHex:(UInt32)col withAlpha:(NSString*)alphaStr
{
    unsigned int r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    
    const char* aStr = [alphaStr cStringUsingEncoding:NSASCIIStringEncoding];
    long value = strtol(aStr+1, NULL, 16);
    CGFloat _alpha = (float)(value & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:_alpha];
}
@end
