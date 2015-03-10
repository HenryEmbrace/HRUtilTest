//
//  HRBlockAlertView.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/10.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRBlockAlertView : UIAlertView

typedef void(^OKBlock)();
typedef void(^CancelBlock)();

-(id)initWithTitle:(NSString *)title andCancleBlock:(CancelBlock )cancleBlock andOKBlock:(OKBlock)okBlock;

@end
