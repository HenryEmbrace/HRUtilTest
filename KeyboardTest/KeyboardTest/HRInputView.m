//
//  BeacherInputView.m
//  HealthyWalk
//
//  Created by ZhangHeng on 15/2/28.
//  Copyright (c) 2015年 LC. All rights reserved.
//

#import "HRInputView.h"

@interface HRInputView()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UIButton    *emojButton;
    UIButton    *sendButton;
    UITextView  *inputView;
    BOOL        emojIsShow;
    
    //标志键盘消失时是否需要移动view，仅限在表情时使用
    BOOL        shouldMove;
    CGFloat     keyboardHeight;
    NSArray     *emojsTextArray;
    NSMutableArray  *emojsArray;
}
@property(nonatomic,strong)UICollectionView *emojItems;
@end

@implementation HRInputView

+(NSAttributedString *)getEmojiStringFromPureString:(NSString *)content withTextColor:(UIColor *)color{
    return [[self new] getCustomEmojWithString:content withColor:color?color:[UIColor blackColor]];
}


-(void)startInput{
    @try {
        [inputView becomeFirstResponder];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        NSLog(@"---");
    }
    
    if(self.hidden)
        self.hidden = NO;
}

-(id)init{
    self = [super init];
    if (self) {
        [self configInputView];
    }
    
    return self;
}

-(void)configInputView{
    emojIsShow = NO;
    keyboardHeight = 0;
    self.backgroundColor = [UIColor whiteColor];
    
    //暂无表情图片，先用赞图片代替
    emojsArray = [NSMutableArray new];
    for(int i = 1;i <36 ; i++){
        NSString *imgName = [NSString stringWithFormat:@"ee_%d",i];
        [emojsArray addObject:imgName];
    }
    
    //图片的转义数组
    emojsTextArray = @[@"[sey]",@"[pie]",@"[yun]",@"[dng]",@"[tse]",@"[lvy]",@"[coo]",@"[amz]",@"[kis]",@"[sml]",@"[tsh]",@"[pzl]",@"[drn]",@"[ust]",@"[spz]",@"[hnx]",@"[shy]",@"[hxn]",@"[kxn]",@"[god]",@"[bad]",@"[nwd]",@"[gls]",@"[sht]",@"[waz]",@"[agy]",@"[cry]",@"[evl]",@"[fgt]",@"[sck]",@"[qpi]",@"[tul]",@"[jjj]",@"[ddd]",@"[kkk]"];
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40);
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [lineView setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    [self addSubview:lineView];
    
    emojButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojButton setFrame:CGRectMake(10, 5, 30, 30)];
    [emojButton setImage:[UIImage imageNamed:@"Emoj"] forState:UIControlStateNormal];
    [emojButton addTarget:self action:@selector(changeEmoj) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emojButton];
    
    inputView = [[UITextView alloc] initWithFrame:CGRectMake(50, 5, [UIScreen mainScreen].bounds.size.width - 110, 30)];
    inputView.layer.cornerRadius = 15;
    inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    inputView.delegate = self;
    inputView.layer.borderWidth = 1;
    inputView.clipsToBounds = YES;
    
    [self addSubview:inputView];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:(252.0/255.0) green:(171.0/255.0) blue:(50.0/255.0) alpha:1] forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake([self screenWidth] - 60, 0, 60, 40)];
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    
    shouldMove = YES;
    
    UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing=0;
    layout.itemSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [self emojHeight]-60);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.headerReferenceSize=CGSizeZero;
    layout.footerReferenceSize=CGSizeZero;
    
    _emojItems = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _emojItems.showsHorizontalScrollIndicator = NO;
    _emojItems.pagingEnabled = YES;
    [_emojItems setDelegate:self];
    [_emojItems setDataSource:self];
    _emojItems.backgroundColor = [UIColor grayColor];
    [_emojItems registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EMOJ_ITEM"];
    
    [_emojItems setFrame:CGRectMake(0, 40, [self screenWidth], [self emojHeight])];
    [self addSubview:_emojItems];
    _emojItems.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNote:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNote:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)sendMessage{
    
    if (inputView.text.length >= 1) {
        if(_delegate && [_delegate respondsToSelector:@selector(sendContent:)])
            [_delegate sendContent:inputView.text];
        if(_delegate && [_delegate respondsToSelector:@selector(sendAttributeContent:)])
            [_delegate sendAttributeContent:[self getCustomEmojWithString:inputView.text withColor:[UIColor blackColor]]];
    }else{
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送空消息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        return;
    }
    inputView.text = @"";
    [emojButton setFrame:CGRectMake(10, 5, 30, 30)];
    [sendButton setFrame:CGRectMake([self screenWidth] - 60, 0, 60, 40)];
    
    [self restoreInputFrameEndEditing:NO];
    if(_needHide){
        [inputView resignFirstResponder];
        [self setHidden:YES];
    }
}

//如果结束编辑
-(void)restoreInputFrameEndEditing:(BOOL)endEditing{
    //是否取消键盘
    if(endEditing){
        if(!emojIsShow)
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10- [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
        else
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10- [self getInputViewHeight] - [self emojHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10 + [self emojHeight]);
    }else{
        if(!emojIsShow)
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10 - keyboardHeight - [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
        else{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10- [self getInputViewHeight] - [self emojHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10 + [self emojHeight]);
            [_emojItems setFrame:CGRectMake(0, 40, [self screenWidth], [self emojHeight])];
        }
    }
    
    [inputView setFrame:CGRectMake(inputView.frame.origin.x, inputView.frame.origin.y, inputView.frame.size.width, [self getInputViewHeight])];
}

-(CGFloat )screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

-(void)changeEmoj{
    if(inputView.isFirstResponder){
        shouldMove = NO;
        [inputView resignFirstResponder];
    }
    
    //是否有弹出表情键盘
    if(emojIsShow){
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10 - [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
            _emojItems.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10 -[self emojHeight] - [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + [self emojHeight] + 10);
            _emojItems.hidden = NO;
        }];
    }
    emojIsShow = !emojIsShow;
    [self setNeedsLayout];
    if(_delegate && [_delegate respondsToSelector:@selector(inputViewFrameChanged)])
        [_delegate inputViewFrameChanged];
}

-(CGFloat)emojHeight{
    if([UIScreen mainScreen].scale < 3.0)
        return 200.0;
    else
        return 240;
}

//获取输入框的高度
-(CGFloat )getInputViewHeight{
    CGRect usedFrame = [inputView.layoutManager usedRectForTextContainer:inputView.textContainer];
    
    CGFloat lineHeight = inputView.font.lineHeight;
    int numberOfActualLines = (int)ceilf(usedFrame.size.height / lineHeight);
    
    CGFloat actualHeight = numberOfActualLines * lineHeight;
    
    actualHeight = MAX(30, actualHeight);
    actualHeight = MIN(120, actualHeight);
    
    return actualHeight;
}

-(void)textViewDidChange:(UITextView *)textView{
    //判断是否有表情弹出的情况
    if(emojIsShow){
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10- [self getInputViewHeight] -[self emojHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + [self emojHeight] + 10);
    }else{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10 - keyboardHeight - [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
    }
    
    [_emojItems setFrame:CGRectMake(0, [self getInputViewHeight] + 10, [self screenWidth], [self emojHeight])];
    [inputView setFrame:CGRectMake(inputView.frame.origin.x, inputView.frame.origin.y, inputView.frame.size.width, [self getInputViewHeight])];
    [emojButton setFrame:CGRectMake(10, [self getInputViewHeight]/2 - 10, 30, 30)];
    [sendButton setFrame:CGRectMake(sendButton.frame.origin.x, [self getInputViewHeight]/2 - 15, 60, 40)];
    [self setNeedsDisplay];
}

-(void)handleKeyboardWillShowNote:(NSNotification *)notification{
    
    if(emojIsShow){
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10 - [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
            _emojItems.hidden = YES;
        }];
        emojIsShow = NO;
    }
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10 - keyboardHeight - [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
    }];
    if(_delegate && [_delegate respondsToSelector:@selector(inputViewFrameChanged)])
        [_delegate inputViewFrameChanged];
}

-(void)handleKeyboardWillHideNote:(NSNotification *)notification{
    //当是出现表情使键盘消失时，不移动
    keyboardHeight = 0;
    if(!shouldMove){
        shouldMove = YES;
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 10- [self getInputViewHeight], [UIScreen mainScreen].bounds.size.width, [self getInputViewHeight] + 10);
        [inputView setFrame:CGRectMake(inputView.frame.origin.x, inputView.frame.origin.y, inputView.frame.size.width, [self getInputViewHeight])];
    }];
    
    if(_delegate && [_delegate respondsToSelector:@selector(inputViewFrameChanged)])
        [_delegate inputViewFrameChanged];
}

-(void)dismissInput{
    if([inputView isFirstResponder])
        [inputView resignFirstResponder];
    if(emojIsShow)
        [self changeEmoj];
    
    if(_needHide){
        [self setHidden:YES];
    }
}

//初始出现时是否需要隐藏
-(void)setNeedHide:(BOOL)needHide{
    _needHide = needHide;
    if(needHide)
        self.hidden = YES;
}

#pragma mark-collectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMOJ_ITEM" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [[cell.contentView viewWithTag:999] removeFromSuperview];
    
    [cell.contentView addSubview:[self getCollectionCellByIndex:indexPath]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([self screenWidth], [self emojHeight]);
}

//emoj自定表情的选择
-(UIView *)getCollectionCellByIndex:(NSIndexPath *)indexPath{
    UIView *collectionCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self screenWidth], [self emojHeight])];
    collectionCell.tag = 999;
    for(int i= 0 ; i < 15 ; i++){
        UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgButton setFrame:CGRectMake(0, 0, [self getCollectionWidth], [self getCollectionWidth])];
        imgButton.center = CGPointMake((i%5 + 0.5)*([self getOffsetOfCell]*2 + [self getCollectionWidth]), (i/5 +0.5)*([self getOffsetOfCell] + [self getCollectionWidth])+15);
        [collectionCell addSubview:imgButton];
        imgButton.tag = i+(indexPath.row)*14;
        if(i == 14){
            [imgButton setImage:[UIImage imageNamed:@"chat_icon_delete"] forState:UIControlStateNormal];
            [imgButton setImage:[UIImage imageNamed:@"chat_icon_delete_press"] forState:UIControlStateSelected];
            [imgButton setTitle:@"删除" forState:UIControlStateNormal];
            [imgButton addTarget:self action:@selector(deleteEmoj) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if(imgButton.tag + 1 > emojsArray.count){
                imgButton.hidden = YES;
            }else{
                [imgButton setImage:[UIImage imageNamed:[emojsArray objectAtIndex:imgButton.tag]] forState:UIControlStateNormal];
                [imgButton addTarget:self action:@selector(emojButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    return collectionCell;
}

//表情删除键盘
-(void)deleteEmoj{
    NSString *contentText = inputView.text;
    if([contentText hasSuffix:@"]"]){
        NSRange range = [contentText rangeOfString:@"[" options:NSBackwardsSearch];
        [inputView setText:[contentText substringToIndex:range.location]];
    }else{
        NSString *origalTest = inputView.text;
        if(origalTest.length > 0){
            inputView.text = [origalTest substringToIndex:origalTest.length-1];
        }
    }
}

-(CGFloat)getOffsetOfCell{
    return 8;
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

-(void)emojButtonSelected:(id)sender{
    UIButton *btn = (UIButton*)sender;
    long arrayIndex = btn.tag;
    NSString *emojStr = [emojsTextArray objectAtIndex:arrayIndex];
    [inputView setText:[inputView.text stringByAppendingString:emojStr]];
    [self scrollToCaretInTextView:inputView animated:NO];
    [self textViewDidChange:inputView];
}

-(CGFloat)getCollectionWidth{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat cellWidth = (screenWidth - [self getOffsetOfCell]*10)/5;
    
    return cellWidth;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(NSAttributedString *)getCustomEmojWithString:(NSString *)customEmojString withColor:(UIColor *)textColor{
    if(!customEmojString)
        return nil;
    
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5\\-\\123~!@#$%^&*()_+<>?:,./;'，。、‘：“《》？~！@#￥%……（）|]+\\]";
    NSError * error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    CGFloat scale = 1.0;
    NSArray *resultArray = [re matchesInString:customEmojString options:0 range:NSMakeRange(0, customEmojString.length)];
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:customEmojString  attributes:nil];
    [string addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, string.length)];
    if([UIScreen mainScreen].scale >= 3.0){
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.length)];
        scale = 0.8;
    }else{
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
        scale = 0.7;
    }
    NSMutableArray * tempImgArray = [NSMutableArray array];
    
    for (int i = 0; i < resultArray.count; i ++) {
        NSTextCheckingResult * result = [resultArray objectAtIndex:i];
        NSString * faceText = [customEmojString substringWithRange:result.range];
        if ([emojsTextArray containsObject:faceText]) {
            NSInteger index = [emojsTextArray indexOfObject:faceText];
            NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:nil ofType:nil ] ;
            UIImage * smileImage = [UIImage imageNamed: [emojsArray objectAtIndex:index]];
            textAttachment.image = [self imageWithImage:smileImage scaledToSize:CGSizeMake(20, 20)];
            NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:textAttachmentString,@"image",[NSValue valueWithRange:result.range],@"range", nil];
            [tempImgArray addObject:tempDic];
        }
    }
    
    while (YES) {
        if (tempImgArray.count == 0) {
            break;
        }
        NSDictionary * dic = [tempImgArray lastObject];
        [string replaceCharactersInRange:[[dic objectForKey:@"range"] rangeValue] withAttributedString:[dic objectForKey:@"image"]];
        [tempImgArray removeLastObject];
    }
    return string;
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
