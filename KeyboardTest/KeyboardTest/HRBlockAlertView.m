//
//  HRBlockAlertView.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/10.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRBlockAlertView.h"

@interface HRBlockAlertView()<UIAlertViewDelegate>

@property(nonatomic,weak)OKBlock  okBlock;
@property(nonatomic,weak)CancelBlock    cancelBlock;
@end

@implementation HRBlockAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithTitle:(NSString *)title andCancleBlock:(CancelBlock)cancleBlock andOKBlock:(OKBlock)okBlock{
    self = [super initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if(self){
        _cancelBlock = cancleBlock;
        _okBlock = okBlock;
        self.delegate = self;
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if(_cancelBlock)
                _cancelBlock();
            break;
        case 1:
            if(_okBlock)
                _okBlock();
            break;
        default:
            break;
    }
}

@end
