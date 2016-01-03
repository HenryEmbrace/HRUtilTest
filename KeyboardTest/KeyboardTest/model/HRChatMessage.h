//
//  HRChatMessage.h
//  KeyboardTest
//
//  Created by ZhangHeng on 16/1/3.
//  Copyright © 2016年 ZhangHeng. All rights reserved.
//

#import "HRBaseModel.h"

typedef NS_ENUM(NSUInteger,MessageType){
    MessageTypeText,
    MessageTypeImage,
    MessageTypeSound,
    MessageTypeVideo,
    MessageTypeWebContent,
    MessageTypeOther
};

@interface HRChatMessage : HRBaseModel

@property(nonatomic,assign)MessageType type;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,assign)BOOL isFromMe;

//images message had
@property(nonatomic,assign)CGFloat  width;
@property(nonatomic,assign)CGFloat  height;

//audio and video message had
@property(nonatomic,assign)CGFloat duration;

//web content message had
@property(nonatomic,strong)NSString *title;

@property(nonatomic,assign)CGFloat  cellHeight;
@end
