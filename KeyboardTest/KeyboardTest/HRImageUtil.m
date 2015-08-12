//
//  HRImageUtil.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/8/12.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

#import "HRImageUtil.h"

@implementation HRImageUtil

+(UIImage *)getImageForSmallSize:(CGSize)size andOrigalImage:(UIImage *)oriImage{
    CGSize oriSize = oriImage.size;
    double compressValue = (double)size.width/(double)oriSize.width;
    NSData  *data = UIImageJPEGRepresentation(oriImage, 1);
    if(compressValue < 1 ){
        data = UIImageJPEGRepresentation(oriImage, compressValue);
    }
    
    UIImage *retImage = [UIImage imageWithData:data];
    
    return [self imageWithImage:retImage scaledToSize:size];
}

+(UIImage *)getImageCompressBy:(float)compress andOrigalImage:(UIImage *)oriImage{
    CGSize oriSize = oriImage.size;
    CGSize toSize = CGSizeMake(oriSize.width, oriSize.height);
    NSData  *data = UIImageJPEGRepresentation(oriImage, compress);
    UIImage *retImage = [UIImage imageWithData:data];
    
    return [self imageWithImage:retImage scaledToSize:toSize];
}

+(UIImage *)getCompressImageByOrigalImage:(UIImage *)origalImage{
    return [UIImage imageWithData:[self dataFromImageForUpload:origalImage]];
}

+(NSData *)dataFromImageForUpload:(UIImage *)image{
    NSData  *data = UIImageJPEGRepresentation(image, 1);
    double compressQuality = (double)153600/(CGFloat)data.length;
    if(compressQuality < 1 ){
        data = UIImageJPEGRepresentation(image, compressQuality);
    }
    
    CGFloat screenWidth = 1080;
    CGFloat imageWidth = MIN(image.size.width, image.size.height);
    CGFloat ratio = imageWidth / screenWidth;
    
    UIImage *dealImage = [UIImage imageWithData:data];
    if(ratio > 1){
        CGSize newSize = CGSizeMake(image.size.width / ratio, image.size.height / ratio);
        dealImage = [self imageWithImage:dealImage scaledToSize:newSize];
    }
    
    return UIImageJPEGRepresentation(dealImage, compressQuality>1?1:compressQuality);
}

//缩放图片
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImageJPEGRepresentation(newImage, 1);
    NSLog(@"%lu",(unsigned long)[imgData length]);
    
    return newImage;
}

@end
