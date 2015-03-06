//
//  HRUtil.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/6.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HRUtil : NSObject

//compress image size
+(NSData *)dataFromImageForUpload:(UIImage *)image;

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

//format: #AARRGGBB or  #RRGGBB  #FF00FF00 is green
+(UIColor *)getColorFromString:(NSString *)colorString;
@end
