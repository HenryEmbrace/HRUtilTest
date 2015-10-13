//
//  HRRoundSlider.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/10/12.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRRoundSlider : UIView

@property(nonatomic,assign,readonly)CGFloat progress;
//圆形滑块的颜色和大小
@property(nonatomic,strong)UIColor *sliderColor;
@property(nonatomic,assign)CGFloat  sliderRadius;
//进度的线宽度和颜色
@property(nonatomic,strong)UIColor  *progressColor;
@property(nonatomic,assign)CGFloat  progressWidth;

@end
