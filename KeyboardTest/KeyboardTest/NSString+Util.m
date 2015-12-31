//
//  NSString+Util.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/12/31.
//  Copyright © 2015年 ZhangHeng. All rights reserved.
//

#import "NSString+Util.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Util)

static const uint32_t HANZI_START_CODEPOINT = 0x4E00;
static const uint32_t HANZI_END_CODEPOINT = 0x9FFF;

static inline int isHanzi(uint32_t cp) {
    return (HANZI_START_CODEPOINT <= cp && cp <= HANZI_END_CODEPOINT);
}

-(BOOL)stringContainsChinesCharacters{
    const uint32_t *cp = (const uint32_t *)([self cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        //单个字符如果是中文
        if (isHanzi(cp[i])){
            return YES;
        }
    }
    return NO;
}

-(NSArray *)getChineseCharacterRanges{
    NSMutableArray *ranges = [NSMutableArray new];
    const uint32_t *cp = (const uint32_t *)([self cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        //单个字符如果是中文，
        if (isHanzi(cp[i])){
            [ranges addObject:@(i)];
        }
    }
    
    return ranges;
}

-(NSArray *)getChineseCharactersContains{
    NSMutableArray *ranges = [NSMutableArray new];
    const uint32_t *cp = (const uint32_t *)([self cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        //单个字符如果是中文，
        if (isHanzi(cp[i])){
            [ranges addObject:[self substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    return ranges;
}

-(BOOL)stringContainsEmoji{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

#pragma encrypt
- (NSString*) sha1{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *) sha1_base64{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *) md5_base64{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *) base64{
    NSData * data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}


@end
