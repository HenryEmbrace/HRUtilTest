//
//  HRUtil.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/6.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRUtil.h"


#define MEGA_BYTE 100*1024

@implementation HRUtil

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

+(UIColor *)getColorWithString:(NSString *)colorString{
    long x;
    NSString *_str;
    //如果是八位
    if([colorString length] == 9)
    {
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
