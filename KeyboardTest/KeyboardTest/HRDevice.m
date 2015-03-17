//
//  HRDevice.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/16.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRDevice.h"
#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>


static HRDevice     *instance = nil;
@implementation HRDevice

+(id)currentDevice{
    if(!instance){
        instance = [[HRDevice alloc] init];
    }
    return instance;
}

-(HRDeviceType)getCurrentDeviceType{
    NSString *platForm = [self deviceModel];
    if([platForm isEqualToString:@"iPhone1,1"]){
        return HRDeviceTypeiPhone;
    }else if([platForm isEqualToString:@"iPhone1,2"]){
        return HRDeviceTypeiPhone3G;
    }else if([platForm isEqualToString:@"iPhone2,1"]){
        return HRDeviceTypeiPhone3GS;
    }else if([platForm isEqualToString:@"iPhone3,1"] || [platForm isEqualToString:@"iPhone3,3"]){
        //3.3 is Version iPhone that support CDMA
        return HRDeviceTypeiPhone4;
    }else if([platForm isEqualToString:@"iPhone4,1"]){
        return HRDeviceTypeiPhone4S;
    }else if([platForm isEqualToString:@"iPhone5,1"] || [platForm isEqualToString:@"iPhone5,2"]){
        //5,2 is CDMA version
        return HRDeviceTypeiPhone5;
    }else if([platForm isEqualToString:@"iPhone5,3"] || [platForm isEqualToString:@"iPhone5,4"]){
        //5,3 CDMA & WCDMA,  5,4 is TD
        return HRDeviceTypeiPhone5c;
    }else if([platForm isEqualToString:@"iPhone6,1"] || [platForm isEqualToString:@"iPhone6,2"]){
        //6,1 is CDMA and 6,2 is global
        return HRDeviceTypeiPhone5S;
    }else if([platForm isEqualToString:@"iPhone7,1"]){
        return HRDeviceTypeiPhone6;
    }else if([platForm isEqualToString:@"iPhone7,2"]){
        return HRDeviceTypeiPhone6Plus;
    }else if([platForm isEqualToString:@"iPad1,1"]){
        return HRDeviceTypeiPad1;
    }else if([platForm isEqualToString:@"iPad2,1"] || [platForm isEqualToString:@"iPad2,2"] || [platForm isEqualToString:@"iPad2,3"]){
        //2,2 is GSM and 2,1 is CDMA
        return HRDeviceTypeiPad2;
    }else if([platForm isEqualToString:@"iPad3,1"] || [platForm isEqualToString:@"iPad3,2"] || [platForm isEqualToString:@"iPad3,3"]){
        return HRDeviceTypeiPad3;
    }else if([platForm isEqualToString:@"iPad3,4"] || [platForm isEqualToString:@"iPad3,5"] || [platForm isEqualToString:@"iPad3,6"]){
        return HRDeviceTypeiPad4;
    }else if([platForm isEqualToString:@"iPad2,5"] || [platForm isEqualToString:@"iPad2,6"] || [platForm isEqualToString:@"iPad2,7"]){
        return HRDeviceTypeiPadMini;
    }else if([platForm isEqualToString:@"iPad4,4"] || [platForm isEqualToString:@"iPad4,5"] || [platForm isEqualToString:@"iPad4,6"]){
        return HRDeviceTypeiPadMini2;
    }else if([platForm isEqualToString:@"iPad4,7"] || [platForm isEqualToString:@"iPad4,8"] || [platForm isEqualToString:@"iPad4,9"]){
        return HRDeviceTypeiPadMini3;
    }else if([platForm isEqualToString:@"iPad4,1"] || [platForm isEqualToString:@"iPad4,2"] || [platForm isEqualToString:@"iPad4,3"]){
        return HRDeviceTypeiPadAir;
    }else if([platForm isEqualToString:@"iPad5,1"] || [platForm isEqualToString:@"iPad5,2"] || [platForm isEqualToString:@"iPad5,3"]){
        return HRDeviceTypeiPadAir2;
    }else if ([platForm hasPrefix:@"iPod"]){
        return HRDeviceTypeiPod;
    }
    
    return HRDeviceTypeiPhone;
}

-(NSString *)getSystemStringVersion{
    return [[UIDevice currentDevice] systemVersion];
}

-(CGFloat)getSystemFloatVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

-(CGSize)getScreenSize{
    return [UIScreen mainScreen].bounds.size;
}

- (NSString *)deviceModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

@end
