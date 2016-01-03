//
//  HRChatTextCell.m
//  KeyboardTest
//
//  Created by ZhangHeng on 16/1/3.
//  Copyright © 2016年 ZhangHeng. All rights reserved.
//

#import "HRChatTextCell.h"
#import "HRInputView.h"

@interface HRChatTextCell(){
    UIImageView *cellBgview;
    UILabel *contentLabel;
}
@end

@implementation HRChatTextCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configCell{
    self.contentView.backgroundColor = [UIColor clearColor];
    cellBgview = [UIImageView new];
    [cellBgview setImage:[[UIImage imageNamed:@"cellbg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    cellBgview.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:cellBgview];
    [cellBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellBgview.mas_left).offset(10);
        make.right.equalTo(cellBgview.mas_right).offset(-10);
        make.top.equalTo(cellBgview.mas_top);
        make.bottom.equalTo(cellBgview.mas_bottom);
    }];
}

-(void)setMessage:(HRChatMessage *)message{
    [super setMessage:message];
    
    [contentLabel setAttributedText:[HRInputView getEmojiStringFromPureString:message.text withTextColor:message.isFromMe?[UIColor whiteColor]:[UIColor blackColor]]];
    if(message.isFromMe){
        [cellBgview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }else{
        [cellBgview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
}

@end
