//
//  HRChatMessage.m
//  KeyboardTest
//
//  Created by ZhangHeng on 16/1/3.
//  Copyright © 2016年 ZhangHeng. All rights reserved.
//

#import "HRChatMessage.h"
#import "HRInputView.h"

@implementation HRChatMessage


-(CGFloat)cellHeight{
    if(_cellHeight <=0){
        switch (_type) {
            case MessageTypeText: {
                CGSize constrainedSize = CGSizeMake(ScreenWidth - 75, 9999);
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:[HRInputView getEmojiStringFromPureString:[_text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] withTextColor:[UIColor whiteColor]]];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.length)];
                
                CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesFontLeading context:nil];
                _cellHeight = requiredHeight.size.height;
                if(_cellHeight < 40)
                    _cellHeight = 40;
                
                break;
            }
            case MessageTypeImage: {
                _cellHeight = ScreenWidth/_width*_height;
                break;
            }
            case MessageTypeSound: {
                _cellHeight = 40;
                break;
            }
            case MessageTypeVideo: {
                _cellHeight = 80;
                break;
            }
            case MessageTypeWebContent: {
                _cellHeight = 80;
                break;
            }
            case MessageTypeOther: {
                _cellHeight = 40;
                break;
            }
        }
    }
    
    return _cellHeight;
}

@end
