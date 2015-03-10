//
//  KLRoundTextView.h
//  keluapp
//
//  Created by ZhangHeng on 15/1/14.
//  Copyright (c) 2015年 HuiYan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HRTextRoundTypeTop     =   0,
    HRTextRoundTypeLeft,
    HRTextRoundTypeRight,
    HRTextRoundTypeBottom,
    HRTextRoundTypeAll,
    HRTextRoundTypeNone
}HRTextRoundType;

@interface HRRoundTextView : UITextView
@property(nonatomic,assign)HRTextRoundType  roundType;

@end
