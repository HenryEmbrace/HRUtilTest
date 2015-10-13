//
//  ScrolManager.h
//  Swipidea
//
//  Created by ZhangHeng on 15/10/13.
//  Copyright © 2015年 cosmo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ScoreChangeBlock)(int finaScore);
@interface ScoreManager : NSObject

@property(nonatomic,copy)ScoreChangeBlock changeBlock;

+(ScoreManager *)manager;

-(void)addScrore:(int)score;

-(int)getTotalScore;

@end
