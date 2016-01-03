//
//  HRChatImageCell.m
//  KeyboardTest
//
//  Created by ZhangHeng on 16/1/3.
//  Copyright © 2016年 ZhangHeng. All rights reserved.
//

#import "HRChatImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HRChatImageCell()
{
    UIImageView *contentImage;
}
@end

@implementation HRChatImageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configCell{
    contentImage = [UIImageView new];
    contentImage.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:contentImage];
    [contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

-(void)setMessage:(HRChatMessage *)message{
    [super setMessage:message];
    
    [contentImage sd_setImageWithURL:[NSURL URLWithString:message.url]];
}

@end
