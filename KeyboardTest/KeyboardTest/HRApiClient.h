//
//  HRApiClient.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/5/22.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^ApiCompletion)(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError* anError);

@interface HRApiClient : AFHTTPSessionManager

+(id)sharedClient;

-(NSURLSessionTask *)loginWithUserName:(NSString  *)userName andPassword:(NSString *)password andResponse:(ApiCompletion)completion;

@end
