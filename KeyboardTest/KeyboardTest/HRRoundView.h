//
//  KLRoundView.h
//  keluapp
//
//  Created by ZhangHeng on 15/1/14.
//  Copyright (c) 2015年 HuiYan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HRRoundTypeTop     =   0,
    HRRoundTypeLeft,
    HRRoundTypeRight,
    HRRoundTypeBottom,
    HRRoundTypeAll,
    HRRoundTypeNone
}HRRoundType;

@interface HRRoundView : UIView
@property(nonatomic,assign)HRRoundType  roundType;

@end
