//
//  ShareManager.m
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShareManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@implementation ShareManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)shareWeiboWithTitle:(NSString *)title images:(UIImage *)image dismissBlock:(void(^)())dismissBlock
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:title?title:@"快来使用我吧 Day Day News"
                                     images:image
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
                dismissBlock();
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
                dismissBlock();
            }
                break;
                
            default:
                break;
        }
    }];
}

@end
