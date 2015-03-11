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

@interface ViewController ()<HRBeacherInputDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HRInputView *inputView;
    UITableView     *chatListTable;
    NSMutableArray  *chatArray;
}
@end

#define CHAT_CELL   @"HRCHATCELL"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    chatArray = [NSMutableArray new];
    
    chatListTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
