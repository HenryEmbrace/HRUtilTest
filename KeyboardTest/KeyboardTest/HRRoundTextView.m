//
//  KLRoundTextView.m
//  keluapp
//
//  Created by ZhangHeng on 15/1/14.
//  Copyright (c) 2015年 HuiYan. All rights reserved.
//

#import "HRRoundTextView.h"

@interface HRRoundTextView(){
    CAShapeLayer *maskLayer;
}
@end

@implementation HRRoundTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super init];
    if(self){
        [self configPath];
    }
    
    return self;
}

-(void)setRoundType:(HRTextRoundType)roundType{
    _roundType = roundType;
    
    self.layer.mask = nil;
    
    UIRectCorner   corners;
    switch (roundType) {
        case HRTextRoundTypeLeft:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case HRTextRoundTypeRight:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case HRTextRoundTypeBottom:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case HRTextRoundTypeTop:
            corners = UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case HRTextRoundTypeNone:
            corners = UIRectCornerBottomLeft & UIRectCornerBottomRight;
            break;
        case HRTextRoundTypeAll:
            corners = UIRectCornerAllCorners;
            break;
            
        default:
            corners = UIRectCornerBottomLeft & UIRectCornerTopRight;
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

-(void)configPath{
    maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    self.layer.masksToBounds = YES;
}
@end
