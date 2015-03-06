//
//  KLRoundView.m
//  keluapp
//
//  Created by ZhangHeng on 15/1/14.
//  Copyright (c) 2015年 HuiYan. All rights reserved.
//

#import "HRRoundView.h"

@implementation HRRoundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setRoundType:(KLRoundType)roundType{
    _roundType = roundType;
    
    self.layer.mask = nil;
    UIRectCorner   corners;
    switch (roundType) {
        case KLRoundTypeLeft:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case KLRoundTypeRight:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case KLRoundTypeBottom:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case KLRoundTypeTop:
            corners = UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case KLRoundTypeNone:
            corners = UIRectCornerBottomLeft & UIRectCornerBottomRight;
            break;
        case KLRoundTypeAll:
            corners = UIRectCornerAllCorners;
            break;
            
        default:
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}
@end
