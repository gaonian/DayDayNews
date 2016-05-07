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


@interface AppDelegate ()

@end

@implementation AppDelegate


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

    
    [self setupShareSDK];
    

    return YES;
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
