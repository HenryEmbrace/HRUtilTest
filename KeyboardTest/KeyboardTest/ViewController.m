//
//  ViewController.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/2/28.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "ViewController.h"
#import "HRInputView.h"

@interface ViewController ()<HRBeacherInputDelegate>
{
    HRInputView *inputView;
    UITextView      *contents;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    inputView = [HRInputView new];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInput)];
    [self.view addGestureRecognizer:tap];
    
    contents = [UITextView new];
    [contents setFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 260)];
    [contents setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:contents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideInput{
    [inputView dismissInput];
}

-(void)sendContent:(NSString *)content{
    NSLog(@"%@",content);
}

-(void)sendAttributeContent:(NSAttributedString *)attributeString{
    [contents setAttributedText:attributeString];
}

@end
