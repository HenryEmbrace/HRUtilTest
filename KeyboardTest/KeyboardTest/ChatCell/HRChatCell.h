//
//  HRChatCell.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/9.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "HRChatMessage.h"

@interface HRChatCell : UITableViewCell

@property(nonatomic,strong)HRChatMessage *message;
@property(nonatomic,strong)UIImageView  *avator;

-(void)configCell;

@end
