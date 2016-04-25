//
//  ShareViewController.m
//  新闻
//
//  Created by gyh on 16/4/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>


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
        [shareParams SSDKSetupShareParamsByText:@"快来使用我吧"
                                         images:nil
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"Day Day News"
                                           type:SSDKContentTypeAuto];
        [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
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
                }
                    break;
                    
                default:
                    break;
            }
        }];
//                //2、分享（可以弹出我们的分享菜单和编辑界面）
//                [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                         items:nil
//                                   shareParams:shareParams
//                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType SSDKPlatformSubTypeQZone, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//        
//                               switch (state) {
//                                   case SSDKResponseStateSuccess:
//                                   {
//                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                           message:nil
//                                                                                          delegate:nil
//                                                                                 cancelButtonTitle:@"确定"
//                                                                                 otherButtonTitles:nil];
//                                       [alertView show];
//                                       break;
//                                   }
//                                   case SSDKResponseStateFail:
//                                   {
//                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                       message:[NSString stringWithFormat:@"%@",error]
//                                                                                      delegate:nil
//                                                                             cancelButtonTitle:@"OK"
//                                                                             otherButtonTitles:nil, nil];
//                                       [alert show];
//                                       break;
//                                   }
//                                   default:
//                                       break;
//                               }
//                           }
//                 ];
//    }else{
//        NSLog(@"hahahh");
//    }

}


@end
