//
//  NSString+encrypt.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/10/16.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encrypt)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
- (NSString *) base64;
@end
