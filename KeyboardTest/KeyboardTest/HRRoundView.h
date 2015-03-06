//
//  KLRoundView.h
//  keluapp
//
//  Created by ZhangHeng on 15/1/14.
//  Copyright (c) 2015年 HuiYan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    KLRoundTypeTop     =   0,
    KLRoundTypeLeft,
    KLRoundTypeRight,
    KLRoundTypeBottom,
    KLRoundTypeAll,
    KLRoundTypeNone
}KLRoundType;

@interface HRRoundView : UIView
@property(nonatomic,assign)KLRoundType  roundType;

@end
