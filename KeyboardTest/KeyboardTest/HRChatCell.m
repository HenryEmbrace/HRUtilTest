//
//  HRChatCell.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/9.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRChatCell.h"
#import "HRRoundTextView.h"

@interface HRChatCell(){
    HRRoundTextView     *contentText;
}
@end

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
        [self configCell];
    }
    
    return self;
}

-(void)configCell{
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    contentText = [HRRoundTextView new];
    contentText.backgroundColor = [UIColor grayColor];
    contentText.editable = NO;
    [self.contentView addSubview:contentText];
    
}

-(void)layoutSubviews{
    [contentText setFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width - 40, self.contentView.frame.size.height - 10)];
    contentText.roundType = HRTextRoundTypeLeft;
}

-(void)setContent:(NSString *)content{
    _content = content;
    contentText.text = _content;
}

@end
