//
//  HRChatCell.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/9.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRChatCell.h"

@interface HRChatCell(){
    UIImageView *cellBgview;
    UILabel *contentLabel;
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
    cellBgview = [UIImageView new];
    [cellBgview setImage:[[UIImage imageNamed:@"cellbg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    cellBgview.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:cellBgview];
    
    
    contentLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    
}

-(void)setContent:(NSString *)content{
    _content = content;
    contentLabel.text = content;
}

-(void)setAttributeContent:(NSAttributedString *)attributeContent{
    _attributeContent = attributeContent;
    contentLabel.attributedText = attributeContent;
}

@end
