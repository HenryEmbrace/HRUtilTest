//
//  HRCameraView.h
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/6.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//get the front camera content display at the view in time
@interface HRCameraView : UIView<AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic,assign)BOOL   isGetFront;
@end
