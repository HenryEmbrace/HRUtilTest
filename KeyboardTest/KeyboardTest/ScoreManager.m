//
//  ScrolManager.m
//  Swipidea
//
//  Created by ZhangHeng on 15/10/13.
//  Copyright © 2015年 cosmo. All rights reserved.
//

#import "ScoreManager.h"

@interface ScoreManager()

@property(nonatomic,assign)int totalScore;
@end

static ScoreManager *_manager = nil;
@implementation ScoreManager

+(ScoreManager *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ScoreManager alloc] init];
    });
    
    return _manager;
}

-(id)init{
    self = [super init];
    if(self){
        self.totalScore = 99;
    }
    return self;
}

-(void)addScrore:(int)score{
    _totalScore += score;
    if(_changeBlock){
        _changeBlock(_totalScore);
    }
}

-(int)getTotalScore{
    return _totalScore;
}

@end
