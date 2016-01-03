//
//  ViewController.m
//  KeyboardTest
//
//  Created by ZhangHeng on 15/2/28.
//  Copyright (c) 2015年 ZhangHeng. All rights reserved.
//

#import "ViewController.h"
#import "HRInputView.h"

#import "HRChatTextCell.h"
#import "HRChatImageCell.h"
#import "HRChatAudioCell.h"
#import "HRChatVideoCell.h"
#import "HRChatWebcontentCell.h"
#import "HRChatUnknowCell.h"

#import "HRChatMessage.h"

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

#define CHAT_TEXT_CELL   @"CHAT_TXT_CELL"
#define CHAT_IMG_CELL   @"CHAT_IMG_CELL"
#define CHAT_AUDIO_CELL   @"CHAT_AUDIO_CELL"
#define CHAT_VIDEO_CELL   @"CHAT_VIDEO_CELL"
#define CHAT_WEB_CELL   @"CHAT_WEB_CELL"
#define CHAT_UNKNOWN_CELL   @"CHAT_UNKNOWN_CELL"

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
    slider.progressWidth = 6;
    slider.sliderColor = [UIColor blueColor];
    slider.sliderRadius = 5;
    slider.progressColor = [UIColor redColor];
    [self.view addSubview:slider];
    
    chatArray = [NSMutableArray new];
    
    chatListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 80) style:UITableViewStyleGrouped];
    [chatListTable setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    chatListTable.delegate = self;
    chatListTable.dataSource = self;
    [chatListTable registerClass:[HRChatTextCell class] forCellReuseIdentifier:CHAT_TEXT_CELL];
    [chatListTable registerClass:[HRChatImageCell class] forCellReuseIdentifier:CHAT_IMG_CELL];
    [chatListTable registerClass:[HRChatAudioCell class] forCellReuseIdentifier:CHAT_AUDIO_CELL];
    [chatListTable registerClass:[HRChatVideoCell class] forCellReuseIdentifier:CHAT_VIDEO_CELL];
    [chatListTable registerClass:[HRChatWebcontentCell class] forCellReuseIdentifier:CHAT_WEB_CELL];
    [chatListTable registerClass:[HRChatUnknowCell class] forCellReuseIdentifier:CHAT_UNKNOWN_CELL];
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return chatArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRChatMessage *msg = [chatArray objectAtIndex:indexPath.section];
    HRChatCell  *cell = [self getCellByMessageType:msg.type];
    cell.message = msg;
    
    return cell;
}

-(HRChatCell *)getCellByMessageType:(MessageType)type{
    HRChatCell *cell;
    switch (type) {
        case MessageTypeText: {
            cell = [chatListTable dequeueReusableCellWithIdentifier:CHAT_TEXT_CELL];
            break;
        }
        case MessageTypeImage: {
            cell = [chatListTable dequeueReusableCellWithIdentifier:CHAT_IMG_CELL];
            break;
        }
        case MessageTypeSound: {
            cell = [chatListTable dequeueReusableCellWithIdentifier:CHAT_AUDIO_CELL];
            break;
        }
        case MessageTypeVideo: {
            cell = [chatListTable dequeueReusableCellWithIdentifier:CHAT_VIDEO_CELL];
            break;
        }
        case MessageTypeWebContent: {
            cell = [chatListTable dequeueReusableCellWithIdentifier:CHAT_WEB_CELL];
            break;
        }
        case MessageTypeOther: {
            cell = [chatListTable dequeueReusableCellWithIdentifier:CHAT_UNKNOWN_CELL];
            break;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HRChatMessage *msg = [chatArray objectAtIndex:indexPath.section];
    return  msg.cellHeight;
}

#pragma inputView delegate
-(void)sendContent:(NSString *)content{
    //NSLog(@"%@",content);
    HRChatMessage *message = [[HRChatMessage alloc] init];
    message.type = MessageTypeText;
    message.text = content;
    message.isFromMe = chatArray.count%2;
    
//    HRChatMessage *message = [[HRChatMessage alloc] init];
//    message.type = MessageTypeImage;
//    message.url = @"http://pic.yesky.com/imagelist/06/49/1137252_9255.jpg";
//    message.width = 688.0;
//    message.height = 1025.0;
    
    [chatArray addObject:message];
    [chatListTable insertSections:[NSIndexSet indexSetWithIndex:chatArray.count - 1] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)sendAttributeContent:(NSAttributedString *)attributeString{
}

-(void)inputViewFrameChanged{
    //NSLog(@"input frame changed");
    [chatListTable setContentInset:UIEdgeInsetsMake(0, 0, inputView.frame.size.height, 0)];
}

@end
