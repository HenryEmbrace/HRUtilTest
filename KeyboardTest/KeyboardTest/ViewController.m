//
//  ViewController.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/2/28.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "ViewController.h"
#import "HRInputView.h"
#import "HRChatCell.h"

#import "HRPostMenuView.h"

#import "HRRoundSlider.h"

@interface ViewController ()<HRBeacherInputDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HRInputView *inputView;
    UITableView     *chatListTable;
    NSMutableArray  *chatArray;
    
    //环形slider
    HRRoundSlider *slider;
}
@end

#define CHAT_CELL   @"HRCHATCELL"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *showPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showPost.backgroundColor = [UIColor grayColor];
    [showPost setFrame:CGRectMake(0, 30, 80, 40)];
    [showPost setTitle:@"发布动画" forState:UIControlStateNormal];
    [showPost setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:showPost];
    [showPost addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    
    slider = [[HRRoundSlider alloc] initWithFrame:CGRectMake(200, 20, 60, 60)];
    slider.progressWidth = 8;
    slider.sliderColor = [UIColor blueColor];
    slider.sliderRadius = 10;
    slider.progressColor = [UIColor redColor];
    [self.view addSubview:slider];
    
    chatArray = [NSMutableArray new];
    
    chatListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 80) style:UITableViewStyleGrouped];
    [chatListTable setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    chatListTable.delegate = self;
    chatListTable.dataSource = self;
    [chatListTable registerClass:[HRChatCell class] forCellReuseIdentifier:CHAT_CELL];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInput)];
    [chatListTable addGestureRecognizer:tap];
    
    [self.view addSubview:chatListTable];
    
    inputView = [HRInputView new];
    inputView.delegate = self;
    [self.view addSubview:inputView];
}

-(void)showMenu{
    HRPostMenuView *menu = [[HRPostMenuView alloc] init];
    [menu show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideInput{
    [inputView dismissInput];
}

#pragma mark- UITableView function
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return chatArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRChatCell  *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_CELL];
    cell.attributeContent = [chatArray objectAtIndex:indexPath.section];
    
    return cell;
}


#pragma inputView delegate
-(void)sendContent:(NSString *)content{
    //NSLog(@"%@",content);
}

-(void)sendAttributeContent:(NSAttributedString *)attributeString{
    //[contents setAttributedText:attributeString];
    [chatArray addObject:attributeString];
    [chatListTable insertSections:[NSIndexSet indexSetWithIndex:chatArray.count - 1] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)inputViewFrameChanged{
    //NSLog(@"input frame changed");
    [chatListTable setContentInset:UIEdgeInsetsMake(0, 0, inputView.frame.size.height, 0)];
}

@end
