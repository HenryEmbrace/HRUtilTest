//
//  MokoPostMenuView.h
//  Moko
//
//  Created by Zhang Heng on 7/22/15.
//  Copyright (c) 2014 Moko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostMenuDelegate <NSObject>

-(void)postSomethingType:(int)typeIndex;

@end

@interface HRPostMenuView : UIView
@property(nonatomic,weak)id<PostMenuDelegate>delegate;
@property(nonatomic,assign)BOOL showPostlive;
@property(nonatomic,assign)BOOL showPostDream;


-(void)show;
-(void)dismiss;

@end
