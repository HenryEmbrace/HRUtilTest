//
//  HRChatCell.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/9.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRChatCell.h"

@implementation HRChatCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avator = [UIImageView new];
        _avator.layer.cornerRadius = 15;
        _avator.clipsToBounds = YES;
        _avator.backgroundColor = [UIColor yellowColor];
        
        [self.contentView addSubview:_avator];
        [_avator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
        [self configCell];
    }
    
    return self;
}

-(void)configCell{
    NSLog(@"子类实现重新排版cell");
}

-(void)setMessage:(HRChatMessage *)message{
    _message = message;
    if(_message.isFromMe){
        [self.avator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
    }else{
        [self.avator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:_avator];
}

@end
