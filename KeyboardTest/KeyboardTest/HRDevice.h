//
//  HRDevice.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/16.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    HRDeviceTypeiPhone  =   0,
    HRDeviceTypeiPhone3G,
    HRDeviceTypeiPhone3GS,
    HRDeviceTypeiPhone4,
    HRDeviceTypeiPhone4S,
    HRDeviceTypeiPhone5,
    HRDeviceTypeiPhone5c,
    HRDeviceTypeiPhone5S,
    HRDeviceTypeiPhone6,
    HRDeviceTypeiPhone6Plus,
    HRDeviceTypeiPad1,
    HRDeviceTypeiPad2,
    HRDeviceTypeiPad3,
    HRDeviceTypeiPadMini,
    HRDeviceTypeiPad4,
    HRDeviceTypeiPadAir,
    HRDeviceTypeiPadMini2,
    HRDeviceTypeiPadAir2,
    HRDeviceTypeiPadMini3,
    HRDeviceTypeiPod
}HRDeviceType;

@interface HRDevice : NSObject

+(id)currentDevice;
-(HRDeviceType)getCurrentDeviceType;
-(CGSize)getScreenSize;
-(CGFloat)getSystemFloatVersion;
-(NSString *)getSystemStringVersion;

@end
