//
//  ChatViewController.m
//  新闻
//
//  Created by gyh on 16/5/7.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "ChatViewController.h"
#import "AddView.h"
#import "AddViewButton.h"
#import "NSString+Extension.h"
#import "LVRecordTool.h"
#import "LVRecordView.h"

#import "MessageCell.h"
#import "MessageImageCell.h"
#import "MessageVideoCell.h"
#import "GYHTimeTool.h"
#import "EMSDK.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EMChatManagerDelegate,LVRcordViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *sound;
-(IBAction)soundvoice;

@property (weak, nonatomic) IBOutlet UIButton *btn;   //添加按钮
@property (weak, nonatomic) IBOutlet UITextField *inputView;
- (IBAction)addView;
/**
 *  聊天记录数组
 */
@property (nonatomic, strong) NSMutableArray *messageArr;
@property (weak,  nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, readwrite)UIInputView *input;

/**
 *  录音
 */
@property (nonatomic , weak) UIButton *backrecordBtn;
@property (nonatomic , strong) LVRecordTool *lvrecordTool;
@property (nonatomic,strong) NSURL * recordURL;         //录制音频 存放地址
@property (nonatomic , strong) UIButton *addrecordBtn;  //添加录音的按钮
@property (nonatomic , copy)   NSString *recordTime;     //录制时间
@property (nonatomic , weak)   UIButton *recordbtn;      //录音完成
@property (nonatomic , weak)   UIButton *deleteB;        //删除按钮

/**
 *  会话
 */
@property (nonatomic , strong)  EMConversation *conversation;
@end

@implementation ChatViewController


- (NSMutableArray *)messageArr
{
    if (_messageArr == nil) {
        _messageArr = [[NSMutableArray alloc]init];
    }
    return _messageArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"---%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UID"]);
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    self.title = @"帮助与反馈";
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.fromname type:EMConversationTypeChat createIfNotExist:YES];
    self.conversation = conversation;
    //将所有消息设置为已读
    [conversation markAllMessagesAsRead];
    
    //获取聊天记录
    NSArray *array = [conversation loadMoreMessagesFromId:nil limit:100];
    [self.messageArr addObjectsFromArray:array];
    
    
    self.btn.tag = 0;
    [self.btn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
    self.tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    
    //监听键盘的frame改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(click:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //设置输入框左边的间距
    self.inputView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    self.inputView.delegate = self;
    
    [self tongzhi];
    
    [self scrollToTableBottom];
}


-(void)tongzhi
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"Photo" object:nil];
}


- (void)event:(NSNotification *)notifition
{
    if ([notifition.object isEqualToString:@"图片"]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if ([notifition.object isEqualToString:@"拍照"]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        
    }
}


#pragma mark - 接收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    NSLog(@"接收到消息了-----%@",aMessages);
    for (EMMessage *msg in aMessages) {
        [self.conversation markMessageAsReadWithId:msg.messageId];
    }
    [self.messageArr addObjectsFromArray:aMessages];
    [self.tableview reloadData];
    [self scrollToTableBottom];
    
    EMMessage *message = aMessages[0];
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //发送一个本地通知
        UILocalNotification *localnoti = [[UILocalNotification alloc]init];
        localnoti.alertBody = textBody.text;
        localnoti.fireDate = [NSDate date];
        localnoti.soundName = @"default";
        [[UIApplication sharedApplication]scheduleLocalNotification:localnoti];
    }
}



#pragma mark 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EMMessage *message = self.messageArr[indexPath.row];
    NSString *currentname = [[EMClient sharedClient] currentUsername];
    
    if ([message.body isKindOfClass:[EMTextMessageBody class]]) {
        
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        
        MessageCell *cell = [MessageCell cellWithTableView:tableView];
        if ([message.from isEqualToString:currentname]) {//自己发
            
            [cell setMessage:[NSString stringWithFormat:@"%@",textBody.text] andType:0 andTime:[GYHTimeTool timeStr:message.timestamp]];
            [cell.textView setTitle:[NSString stringWithFormat:@"%@",textBody.text] forState:UIControlStateNormal];
            //头像
            cell.iconView.image = [UIImage imageNamed:@"2"];
            
        }else{//别人发的
            
            [cell setMessage:[NSString stringWithFormat:@"%@",textBody.text] andType:1 andTime:[GYHTimeTool timeStr:message.timestamp]];
            [cell.textView setTitle:[NSString stringWithFormat:@"%@",textBody.text] forState:UIControlStateNormal];
            cell.iconView.image = [UIImage imageNamed:@"1"];
        }
        return cell;
        
        
        
    }else if ([message.body isKindOfClass:[EMVoiceMessageBody class]]){
        
        
    }else if([message.body isKindOfClass:[EMImageMessageBody class]]){
        
        
    }else{
        
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultsContr.fetchedObjects[indexPath.row];
    //    NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
    //    if ([chatType isEqualToString:@"Video"]) {
    //        NSLog(@"video---%@",msg.body);
    //
    //        AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:msg.body]];
    //        [player play];
    //        self.player = player;
    //
    //    }else{
    //        NSLog(@"did---%@",msg.body);
    //    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EMMessage *message = self.messageArr[indexPath.row];
    
    if ([message.body isKindOfClass:[EMTextMessageBody class]]){
        
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        
        NSString *str = textBody.text;
        CGSize textBtnSize;
        CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
        CGSize textRealSize = [str sizeWithFont:[UIFont systemFontOfSize:15] maxSize:textMaxSize];
        // 按钮最终的真实尺寸
        textBtnSize = CGSizeMake(textRealSize.width + 20, textRealSize.height + 20);
        //根据文本空间计算行高
        if (textBtnSize.height + 50.0 > 100.0) {
            return textBtnSize.height + 70;
        }
        return 100;
        
    }else if ([message.body isKindOfClass:[EMTextMessageBody class]]) {
        return 100;
    }else{
        return 150;
    }
}


#pragma mark 文本框代理
#pragma mark - 发送文字消息
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //构造文字消息
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textField.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.fromname from:from to:self.fromname body:body ext:nil];
    message.chatType = EMChatTypeChat;
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"%@",[GYHTimeTool timeStr:[message timestamp]]);
        if(error){
            NSLog(@"error----%@",error);
        }
    }];
    [self.messageArr addObject:message];
    self.inputView.text = nil;
    [self.tableview reloadData];
    [self scrollToTableBottom];
    return YES;
}



#pragma mark - 右侧添加按钮
- (IBAction)addView
{
    UITextView *test = [[UITextView alloc]init];
    test.delegate = self;
    [self.btn addSubview:test];
    
    AddView *view = [[AddView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-218, SCREEN_WIDTH, 218)];
    test.inputAccessoryView = nil;
    test.inputView = nil;
    test.inputView = view;
    
    [test becomeFirstResponder];
    
    if (self.btn.tag == 0) {
        self.btn.tag = 1;
    }else {
        [test resignFirstResponder];
        self.btn.tag = 0;
    }
}


#pragma mark - 录音
- (IBAction)soundvoice
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    UIButton *backrecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backrecordBtn.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4];
    [backrecordBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:backrecordBtn];
    
    LVRecordView *v = [[LVRecordView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 200)];
    v.delegate = self;
    v.backgroundColor = [UIColor clearColor];
    [backrecordBtn addSubview:v];
    self.backrecordBtn = backrecordBtn;
}

- (void)LVRecordTime:(double)time
{
    NSLog(@"%.0f",time);
    self.recordTime = [NSString stringWithFormat:@"%.0f''",time];
}

-(void)LVRecordDoneRecord:(NSURL *)recordURL
{
    self.recordURL = recordURL;
    NSLog(@"完成录制");
    [self.backrecordBtn removeFromSuperview];
    
    
}


#pragma mark - 点击背部遮盖退出录音
- (void)backBtnClick:(UIButton *)btn
{
        if ([self.lvrecordTool.player isPlaying]) [self.lvrecordTool stopPlaying];
        if ([self.lvrecordTool.recorder isRecording]) [self.lvrecordTool stopRecording];
        [self.lvrecordTool destructionRecordingFile];
        [btn removeFromSuperview];
}






/**
 *  键盘通知方法
 *
 *  @param note 键盘通知的参数
 */
-(void)click:(NSNotification *)note
{
    self.view.window.backgroundColor = self.tableview.backgroundColor;
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

#pragma mark  - 滚动到底部
-(void)scrollToTableBottom{
    NSInteger lastRow = self.messageArr.count - 1;
    if (lastRow < 0) {
        //行数如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[EMClient sharedClient].contactManager removeDelegate:self];
}

@end

