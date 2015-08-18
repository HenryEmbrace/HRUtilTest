//
//  HRTools.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/8/18.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRTools.h"

@implementation HRTools


//获取本周第一天
+(NSDate *)getFirstDayOFcurrentWeek{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    
    NSDate *firstDate = [today dateByAddingTimeInterval:60*60*24 * (-weekday+1)];
    
    return firstDate;
}

//获取本周最后一天
+(NSDate *)getLastDayOfCurrentWeek{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    
    NSDate *firstDate = [today dateByAddingTimeInterval:60*60*24 * (7-weekday)];
    
    return firstDate;
}
@end
