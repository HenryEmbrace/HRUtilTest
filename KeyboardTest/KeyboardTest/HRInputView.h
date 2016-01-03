//
//  BeacherInputView.h
//  HealthyWalk
//
//  Created by ZhangHeng on 15/2/28.
//  Copyright (c) 2015年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HRBeacherInputDelegate <NSObject>

//发送的内容，最后需要调用HREmojiConvert进行一下转换得到图文混排的attributeText
-(void)sendContent:(NSString *)content;
-(void)sendAttributeContent:(NSAttributedString *)attributeString;
-(void)inputViewFrameChanged;
@end

/*
 使用方法，直接new一个以后addSubview即可，位置变换逻辑已经处理好，不需要手动在外部进行任何坐标调整
 同时设置delegate
 */

@interface HRInputView : UIView
@property(nonatomic,weak)id<HRBeacherInputDelegate> delegate;

//初始出现时是否需要隐藏，如不隐藏则会出现在底部，如隐藏，发送和取消发送后会自动隐藏键盘
@property(nonatomic,assign)BOOL     needHide;

+(NSAttributedString *)getEmojiStringFromPureString:(NSString *)content withTextColor:(UIColor *)color;

//取消掉键盘的响应
-(void)dismissInput;

//响应键盘输入
-(void)startInput;
@end
