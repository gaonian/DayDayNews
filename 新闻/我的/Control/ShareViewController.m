//
//  ShareViewController.m
//  新闻
//
//  Created by gyh on 16/4/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"小语宙.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        [shareParams SSDKSetupShareParamsByText:@"快来使用我吧 Day Day News"
                                         images:nil
                                            url:[NSURL URLWithString:@"https://www.github.com/gaoyuhang"]
                                          title:@"Day Day News"
                                           type:SSDKContentTypeAuto];
    
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                case SSDKResponseStateFail:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }];

//    [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//        
//        DLog(@"%lu",(unsigned long)state);
//        if(state == SSDKResponseStateSuccess){
//            DLog(@"分享成功");
//        }
//        
//    }];
    
}


@end
