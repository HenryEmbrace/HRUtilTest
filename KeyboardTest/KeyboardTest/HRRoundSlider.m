//
//  HRRoundSlider.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/10/12.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

#import "HRRoundSlider.h"

@interface HRRoundSlider()
{
    CAShapeLayer *progressLayer;
    UIView *bgview;
}
@property(nonatomic,strong)UIView *flagView;
@end

@implementation HRRoundSlider


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [progressLayer removeFromSuperlayer];
    progressLayer = nil;
    
    UIBezierPath *ballBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake([self getRadius], [self getRadius]) radius:[self getRadius] - _progressWidth startAngle:-M_PI/2 endAngle:M_PI*2*_progress -M_PI/2 clockwise:YES];
    CAShapeLayer *tmpLayer = [[CAShapeLayer alloc] init];
    [tmpLayer setPath:ballBezierPath.CGPath];
    [tmpLayer setStrokeColor:_progressColor?_progressColor.CGColor:[UIColor blackColor].CGColor];
    [tmpLayer setFillColor:[UIColor clearColor].CGColor];
    [tmpLayer setLineWidth:_progressWidth];
    [self.layer insertSublayer:tmpLayer below:bgview.layer];
    
    progressLayer = tmpLayer;
    
    [_flagView setCenter:ballBezierPath.currentPoint];
}

-(CGFloat)getRadius{
    return self.frame.size.width/2;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        _sliderRadius = 10;
        _progressWidth = 10;
        
        bgview = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:bgview];
        _progress = 1.0;
        
        _flagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _sliderRadius*2, _sliderRadius*2)];
        _flagView.backgroundColor = [UIColor redColor];
        _flagView.layer.cornerRadius = _sliderRadius;
        _flagView.clipsToBounds = YES;
        [self addSubview:_flagView];
    }
    return self;
}

-(void)setSliderRadius:(CGFloat)sliderRadius{
    _sliderRadius = sliderRadius;
    CGPoint centerPt = _flagView.center;
    [_flagView setFrame:CGRectMake(0, 0, _sliderRadius*2, _sliderRadius*2)];
    _flagView.layer.cornerRadius = _sliderRadius;
    _flagView.clipsToBounds = YES;
    [_flagView setCenter:centerPt];
}

-(void)setProgressWidth:(CGFloat)progressWidth{
    _progressWidth = progressWidth;
    [self setNeedsDisplay];
}

-(void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
    _flagView.backgroundColor = _sliderColor;
}

-(void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint endPt = [[[touches allObjects] lastObject] locationInView:self];
    
    [UIView animateWithDuration:0.05 animations:^{
        [_flagView setCenter:[self getOccurPointByTouchPt:endPt]];
    }];
}

-(CGPoint)getOccurPointByTouchPt:(CGPoint)touchPoint{
    CGFloat lengthX = fabs(touchPoint.x - [self getRadius]);
    CGFloat lengthY = fabs(touchPoint.y - [self getRadius]);
    
    CGFloat bigLength = sqrt(pow(lengthX,2)+pow(lengthY, 2));
    CGFloat rate = [self getRadius]/bigLength;
    
    CGFloat addX = (touchPoint.x - [self getRadius])*rate;
    CGFloat addY = (touchPoint.y - [self getRadius])*rate;
    
    if(addX > 0){
        addX -= _progressWidth/2;
    }else{
        addX += _progressWidth/2;
    }
    
    if(addY > 0){
        addY -= _progressWidth/2;
    }else{
        addY += _progressWidth/2;
    }
    
    return CGPointMake([self getRadius] + addX, [self getRadius] + addY);
}

//-(CGFloat)getAngelByPoint:(CGPoint)touchPoint{
//
//}

@end
