//
//  HRImageUtil.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/8/12.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HRImageUtil : NSObject

//压缩图片到适合上传的尺寸，500k左右
+(UIImage *)getCompressImageByOrigalImage:(UIImage *)origalImage;

//压缩缩略图到指定尺寸
+(UIImage *)getImageForSmallSize:(CGSize)size andOrigalImage:(UIImage *)oriImage;

//按比例压缩图片
+(UIImage *)getImageCompressBy:(float)compress andOrigalImage:(UIImage *)oriImage;

+(UIImage *)drawTextOnImage:(UIImage *)bgImage atRect:(CGRect)rect withString:(NSString *)string;


@end
