//
//  AppDelegate.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信sdk头文件
#import "WXApi.h"

//新浪微博
#import "WeiboSDK.h"

#import "EMSDK.h"


@interface AppDelegate ()<EMChatManagerDelegate>

@property (nonatomic , strong) NSArray *conversations;

@end

@implementation AppDelegate

- (NSArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSArray array];
    }
    return _conversations;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    TabbarViewController *main = [[TabbarViewController alloc]init];
    self.window.rootViewController = main;
    [self.window makeKeyAndVisible];
    
    //环信
    EMOptions *options = [EMOptions optionsWithAppkey:@"gaoyuhang#daydaynews"];
    options.apnsCertName = @"gaoyuhangDevelop";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

    [self setupShareSDK];
    
    //注册一个本地通知
    [self registLocalNoti:application];
    
    //获取未读的消息数
    [self loadConversations];
    
    return YES;
}


#pragma mark - 接收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    NSLog(@"接收到消息了-----%@",aMessages);
    
    [self loadConversations];
    
    EMMessage *message = aMessages[0];
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //发送一个本地通知
        UILocalNotification *localnoti = [[UILocalNotification alloc]init];
        localnoti.alertBody = [NSString stringWithFormat:@"gaoyuhang:%@",textBody.text];
        localnoti.fireDate = [NSDate date];
        localnoti.soundName = @"default";
        [[UIApplication sharedApplication]scheduleLocalNotification:localnoti];
    }
}

#pragma mark - 注册一个本地通知
- (void)registLocalNoti:(UIApplication *)application
{
    //注册应用接收通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

-(void)loadConversations{
    //获取历史会话记录
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    if (conversations.count == 0) {
        conversations =  [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    }
    self.conversations = conversations;
    //显示总的未读数
    [self showTabBarBadge];
}

- (void)showTabBarBadge{
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += [conversation unreadMessagesCount];
    }
    NSLog(@"未读消息总数:%ld",(long)totalUnreadCount);
    //发送未读消息数给setting界面，展示未读数
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChatCount" object:[NSString stringWithFormat:@"%ld",(long)totalUnreadCount]];
}


#pragma mark - 设置第三方登陆信息
- (void)setupShareSDK
{
    [ShareSDK registerApp:@"ce834ae164c4" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                             //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:@"3964063087"appSecret:@"7a1b47a262c3c0557e36c5a01f33eb68"redirectUri:@"http://www.baidu.com"
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:@"wx2aaa2d1871fa3bb4" appSecret:@"1c72adc1f0150c6c5c4d0de4cbb9613e"];
                             break;
                             
                         case SSDKPlatformTypeQQ:
                             //41DD38F3
                             [appInfo SSDKSetupQQByAppId:@"1104984866" appKey:@"HpGu2fsbpohnbw3F"
                                                authType:SSDKAuthTypeBoth];
                             break;
                         default:
                             break;
                     }
                 }];

}

@end
