//
//  MokoPostMenuView.m
//  MokoDreamWork
//
//  Created by Zhang Heng on 7/22/15.
//  Copyright (c) 2014 Moko. All rights reserved.
//

#import "HRPostMenuView.h"
#import <pop/POP.h>
#import <Masonry/Masonry.h>
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

#define BG_ALPHA        (0.99)

#define UIColorFromRGB(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface HRPostMenuView () {
    UIToolbar       *_toolBar;
    
    UIButton        *_btnPostVideo;
    UIButton        *_btnPostSound;
    UIButton        *_btnPostText;
    UIButton        *_btnClose;
    UILabel         *_lblVideo;
    UILabel         *_lblSound;
    UILabel         *_lblText;
    
    UIView *postLive;
    UIView *postDreamShow;
    
    NSLayoutConstraint   *_alConsPostPictureVertical;
    NSLayoutConstraint   *_alConsPostSoundVertical;
    NSLayoutConstraint   *_alConsPostTextVertical;
    NSLayoutConstraint   *_alConsPostLiveVertical;
    NSLayoutConstraint   *_alConsPostDreamVertical;
    NSLayoutConstraint   *_alConsClostWidth;
    NSLayoutConstraint   *_alConsCloseHeight;
    
    POPSpringAnimation  *_animPostPic;
    POPSpringAnimation  *_animPostSound;
    POPSpringAnimation  *_animPostText;
    
    POPSpringAnimation  *_animPostLive;
    POPSpringAnimation  *_animPostDreamShow;
    
    UIImageView *imageBg;
    
    BOOL    isShowing;
}

@end

@implementation HRPostMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showPostDream = YES;
        self.showPostlive = YES;
        [self doInit];
    }
    return self;
}

-(void)doInit {
    _toolBar = [UIToolbar new];
    _toolBar.clipsToBounds = YES;
    _toolBar.barStyle = UIBarStyleDefault;
    //_toolBar.barTintColor = [UIColor whiteColor];
    //_toolBar.alpha = 0.9;
    
    [self addSubview:_toolBar];
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    imageBg = [UIImageView new];
    [imageBg setImage:[UIImage imageNamed:@"postMenuBg"]];
    imageBg.alpha = 0;
    [self addSubview:imageBg];
    [imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@181);
        make.height.equalTo(@100.5);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(100);
    }];
    
    _btnPostVideo = [UIButton new];
    [_btnPostVideo setImage:[UIImage imageNamed:@"publishVideo"] forState:UIControlStateNormal];
    [_btnPostVideo addTarget:self action:@selector(actionPostPic) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnPostVideo];
    
    _btnPostSound = [UIButton new];
    [_btnPostSound setImage:[UIImage imageNamed:@"publishImage"] forState:UIControlStateNormal];
    [_btnPostSound addTarget:self action:@selector(actionPostSound) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnPostSound];
    
    _btnPostText = [UIButton new];
    [_btnPostText setImage:[UIImage imageNamed:@"publishSound"] forState:UIControlStateNormal];
    [_btnPostText addTarget:self action:@selector(actionPostText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnPostText];
    
    postLive = [self getLiveShowView];
    [self addSubview:postLive];
    
    postDreamShow = [self getDreamShowView];
    [self addSubview:postDreamShow];
    
    _lblVideo = [UILabel new];
    [_lblVideo setText:@"发布一"];
    [_lblVideo setFont:[UIFont systemFontOfSize:12]];
    [_lblVideo setTextColor:UIColorFromRGB(0x797979, 1)];
    [self addSubview:_lblVideo];
    [_lblVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnPostVideo.mas_bottom).with.offset(10);
        make.centerX.equalTo(_btnPostVideo.mas_centerX);
    }];
    
    _lblSound = [UILabel new];
    [_lblSound setText:@"发布二"];
    [_lblSound setFont:[UIFont systemFontOfSize:12]];
    [_lblSound setTextColor:UIColorFromRGB(0x797979, 1)];
    [self addSubview:_lblSound];
    [_lblSound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnPostSound.mas_bottom).with.offset(10);
        make.centerX.equalTo(_btnPostSound.mas_centerX);
    }];
    
    _lblText = [UILabel new];
    [_lblText setText:@"发布三"];
    [_lblText setFont:[UIFont systemFontOfSize:12]];
    [_lblText setTextColor:UIColorFromRGB(0x797979, 1)];
    [self addSubview:_lblText];
    [_lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnPostText.mas_bottom).with.offset(10);
        make.centerX.equalTo(_btnPostText.mas_centerX);
    }];
    
    
    _btnClose = [UIButton new];
    [_btnClose setImage:[UIImage imageNamed:@"closeMenu"] forState:UIControlStateNormal];
    [self addSubview:_btnClose];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_btnClose addGestureRecognizer:tap];
    
    ///
    BOOL is6p = ([[UIScreen mainScreen] scale] >= 3);
    
    [_btnPostVideo alignCenterXWithView:_toolBar predicate:is6p ? @"-120" : @"-100"];
    _alConsPostPictureVertical = [_btnPostVideo alignCenterYWithView:_toolBar predicate:@"568"].firstObject;
    
    
    [_btnPostSound alignCenterXWithView:_toolBar predicate:@"0"];
    _alConsPostSoundVertical = [_btnPostSound alignCenterYWithView:_toolBar predicate:@"568"].firstObject;
    
    
    [_btnPostText alignCenterXWithView:_toolBar predicate:is6p ? @"120" : @"100"];
    _alConsPostTextVertical = [_btnPostText alignCenterYWithView:_toolBar predicate:@"568"].firstObject;
    
    NSString *offSetLive;
    NSString *offSetShow;
    if(ScreenWidth == 320){
        offSetLive = @"120";
        offSetShow = @"160";
    }else{
        offSetLive = @"150";
        offSetShow = @"220";
    }
    
    
    [postLive alignCenterYWithView:_toolBar predicate:is6p ?@"160": offSetLive];
    _alConsPostLiveVertical = [postLive alignCenterXWithView:_toolBar predicate:@"-568"].firstObject;
    
    [postDreamShow alignCenterYWithView:_toolBar predicate:is6p ? @"280":offSetShow];
    _alConsPostDreamVertical = [postDreamShow alignCenterXWithView:_toolBar predicate:@"-568"].firstObject;
    
    [_btnClose alignCenterXWithView:_toolBar predicate:nil];
    [_btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_bottom).offset(-40);
    }];
    _alConsClostWidth = [_btnClose constrainWidth:@"45"].firstObject;
    _alConsCloseHeight = [_btnClose constrainHeight:@"45"].firstObject;
    
    UITapGestureRecognizer *tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapDismiss];
}

-(void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    isShowing = YES;
    
    ///
    NSInteger bounceiness = 10;
    NSInteger speed = 10;
    _toolBar.alpha = 0;
    
    POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.beginTime = CACurrentMediaTime() + 0.33;
    rotationAnimation.toValue = @(M_PI/2);
    rotationAnimation.springBounciness = 10.f;
    rotationAnimation.springSpeed = 5;
    [_btnClose.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnim"];
    
    [UIView animateWithDuration:.5f animations:^{
        _toolBar.alpha = BG_ALPHA;
    } completion:^(BOOL finished) {
        int toValue;
        if(ScreenWidth == 320)
            toValue = 30;
        else
            toValue = 50;
        
        _animPostPic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        _animPostPic.springBounciness = bounceiness;
        _animPostPic.springSpeed = speed;
        _animPostPic.toValue = @(toValue);
        [_alConsPostPictureVertical pop_addAnimation:_animPostPic forKey:@"postPic"];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            imageBg.alpha = 1;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _animPostSound = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            _animPostSound.springBounciness = bounceiness;
            _animPostSound.springSpeed = speed;
            _animPostSound.toValue = @(toValue);
            [_alConsPostSoundVertical pop_addAnimation:_animPostSound forKey:@"postSound"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _animPostText = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
                _animPostText.springBounciness = bounceiness;
                _animPostText.springSpeed = speed;
                _animPostText.toValue = @(toValue);
                [_alConsPostTextVertical pop_addAnimation:_animPostText forKey:@"postText"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    anim.duration = 0.15;
                    anim.toValue = @(1.0);
                    [postLive pop_addAnimation:anim forKey:@"liveFade"];
                    
                    if(_showPostlive){
                        //直播动画
                        _animPostLive = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
                        _animPostLive.springBounciness = bounceiness;
                        _animPostLive.springSpeed = speed;
                        _animPostLive.toValue = @(0);
                        [_alConsPostLiveVertical pop_addAnimation:_animPostLive forKey:@"postLive"];
                    }else{
                        if(_showPostDream){
                            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            anim.duration = 0.15;
                            anim.toValue = @(1.0);
                            [postDreamShow pop_addAnimation:anim forKey:@"dreamFade"];
                            //梦想秀动画
                            _animPostDreamShow = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
                            _animPostDreamShow.springBounciness = bounceiness;
                            _animPostDreamShow.springSpeed = speed;
                            _animPostDreamShow.toValue = @(0);
                            [_alConsPostDreamVertical pop_addAnimation:_animPostDreamShow forKey:@"postDream"];
                        }
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            isShowing = NO;
                        });
                        return;
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(_showPostDream){
                            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            anim.duration = 0.15;
                            anim.toValue = @(1.0);
                            [postDreamShow pop_addAnimation:anim forKey:@"dreamFade"];
                            //梦想秀动画
                            _animPostDreamShow = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
                            _animPostDreamShow.springBounciness = bounceiness;
                            _animPostDreamShow.springSpeed = speed;
                            _animPostDreamShow.toValue = @(0);
                            [_alConsPostDreamVertical pop_addAnimation:_animPostDreamShow forKey:@"postDream"];
                        }
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            isShowing = NO;
                        });
                    });
                });
            });
            
        });
    }];
}

-(void)dismiss {
    if(isShowing)
        return;
    [self dismiss:nil];
}

-(void)dismiss:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.5 animations:^{
        imageBg.alpha = 0;
    }];
    
    NSInteger bounceiness = 10;
    NSInteger speed = 10;
    id toValue = @(-568);
    
    _animPostPic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    _animPostPic.springBounciness = bounceiness;
    _animPostPic.springSpeed = speed;
    _animPostPic.toValue = toValue;
    [_alConsPostPictureVertical pop_addAnimation:_animPostPic forKey:@"postPic"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _animPostSound = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        _animPostSound.springBounciness = bounceiness;
        _animPostSound.springSpeed = speed;
        _animPostSound.toValue = toValue;
        [_alConsPostSoundVertical pop_addAnimation:_animPostSound forKey:@"postSound"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _animPostText = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            _animPostText.springBounciness = bounceiness;
            _animPostText.springSpeed = speed;
            _animPostText.toValue = toValue;
            [_alConsPostTextVertical pop_addAnimation:_animPostText forKey:@"postText"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _animPostLive = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
                _animPostLive.springBounciness = bounceiness;
                _animPostLive.springSpeed = speed;
                _animPostLive.toValue = toValue;
                [_alConsPostLiveVertical pop_addAnimation:_animPostLive forKey:@"postLive"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _animPostDreamShow = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
                    _animPostDreamShow.springBounciness = bounceiness;
                    _animPostDreamShow.springSpeed = speed;
                    _animPostDreamShow.toValue = toValue;
                    [_alConsPostDreamVertical pop_addAnimation:_animPostDreamShow forKey:@"postLive"];
                });
            });
        });
        
    });
    
    _toolBar.alpha = BG_ALPHA;
    _btnClose.hidden = YES;
    [UIView animateWithDuration:.5f delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _toolBar.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

-(UIView *)getLiveShowView{
    UIImageView *liveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    [liveView setImage:[UIImage imageNamed:@"menuBkg"]];
    
    UIImageView *liveIcon = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 35, 35)];
    [liveIcon setImage:[UIImage imageNamed:@"liveIcon"]];
    [liveView addSubview:liveIcon];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 80, 35)];
    text.text = @"发布四";
    [liveView addSubview:text];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 62, 26.5, 7, 12)];
    [rightArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    [liveView addSubview:rightArrow];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionPostLive)];
    liveView.userInteractionEnabled = YES;
    [liveView addGestureRecognizer:tap];
    
    liveView.alpha = 0;
    
    return liveView;
}

-(UIView *)getDreamShowView{
    UIImageView *dreamView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    [dreamView setImage:[UIImage imageNamed:@"menuBkg"]];
    
    UIImageView *liveIcon = [[UIImageView alloc] initWithFrame:CGRectMake(60, 13, 35, 35)];
    [liveIcon setImage:[UIImage imageNamed:@"publishDreamShow"]];
    [dreamView addSubview:liveIcon];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(120, 13, 80, 35)];
    text.text = @"发布五";
    text.textColor = UIColorFromRGB(0x121212, 1);
    [dreamView addSubview:text];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 35, 26.5, 7, 12)];
    [rightArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    [dreamView addSubview:rightArrow];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionPostShow)];
    dreamView.userInteractionEnabled = YES;
    [dreamView addGestureRecognizer:tap];
    
    dreamView.alpha = 0;
    
    return dreamView;
}

#pragma mark - actions
-(void)actionPostPic {
    [self dismiss:^(BOOL finished) {
        if(_delegate && [_delegate respondsToSelector:@selector(postSomethingType:)])
            [_delegate postSomethingType:0];
    }];
}

-(void)actionPostSound {
    [self dismiss:^(BOOL finished) {
        if(_delegate && [_delegate respondsToSelector:@selector(postSomethingType:)])
            [_delegate postSomethingType:1];
    }];
}

-(void)actionPostText {
    [self dismiss:^(BOOL finished) {
        if(_delegate && [_delegate respondsToSelector:@selector(postSomethingType:)])
            [_delegate postSomethingType:2];
    }];
}

-(void)actionPostLive{
    [self dismiss:^(BOOL finished) {
        if(_delegate && [_delegate respondsToSelector:@selector(postSomethingType:)])
            [_delegate postSomethingType:4];
    }];
}

-(void)actionPostShow{
    [self dismiss:^(BOOL finished) {
        if(_delegate && [_delegate respondsToSelector:@selector(postSomethingType:)])
            [_delegate postSomethingType:5];
    }];
}

@end
