//
//  HRChatViewController.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/3/9.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "HRChatViewController.h"
#import "HRChatCell.h"

@interface HRChatViewController ()<UITableViewDataSource,UITableViewDelegate>{

}

@property(nonatomic,strong)UITableView  *chatList;
@end

#define CHAT_CELL   @"chat_cell"
@implementation HRChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chatList = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_chatList];
    
    _chatList.delegate = self;
    _chatList.dataSource = self;
    _chatList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_chatList registerClass:[HRChatCell class] forCellReuseIdentifier:CHAT_CELL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRChatCell  *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_CELL];
    
    
    return cell;
}

@end
