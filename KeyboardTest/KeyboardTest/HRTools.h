//
//  HRTools.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/8/18.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRTools : NSObject

//周均按周日第一天开始算，如果有需要自行添加一天到周一至周日
//获取本周第一天
+(NSDate *)getFirstDayOFcurrentWeek;

//获取本周最后一天
+(NSDate *)getLastDayOfCurrentWeek;
@end
