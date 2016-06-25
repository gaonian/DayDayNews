//
//  SettingHeaderView.m
//  新闻
//
//  Created by gyh on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SettingHeaderView.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "EMSDK.h"


@interface SettingHeaderView()<UIAlertViewDelegate>

@end

@implementation SettingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sureLogin:) name:@"QQLogin" object:nil];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.6*SCREEN_WIDTH);
        self.backgroundColor = [UIColor colorWithRed:186/255.0f green:71/255.0f blue:58/255.0f alpha:1];
             
        UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 30, 50, 20)];
        [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
        [self addSubview:logoutBtn];
        
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(self.frame.size.width/2-40, self.frame.size.height/2-40, 80, 80);
        imageV.image = [UIImage imageNamed:@"comment_profile_default"];
        [self addSubview:imageV];
        [imageV.layer setCornerRadius:40];
        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = YES;
        self.photoimageV = imageV;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+10, SCREEN_WIDTH, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"立即登录";
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        label.userInteractionEnabled = YES;
        self.nameL = label;
        
        NSString *loginImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINIMAGE"];
        NSString *loginName = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINNAME"];
        if (loginImage.length != 0 && loginName.length != 0) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:loginImage]];
            label.text = loginName;
        }

        UIButton *cover = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height/2-40, 80, 110)];
        [cover addTarget:self action:@selector(countLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        
    }
    return self;
}

#pragma mark - 登录
- (void)countLogin
{
    if ([self.nameL.text isEqualToString:@"立即登录"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(LoginBtnClck:)]) {
            [self.delegate LoginBtnClck:@""];
        }
    }else{
        
    }
}

#pragma mark - 最终登录方式
- (void)sureLogin:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    NSString *title = noti.object;
    if ([title isEqualToString:@"QQ"]) {
        
            [ShareSDK getUserInfo:SSDKPlatformTypeQQ
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
             {
                 if (state == SSDKResponseStateSuccess)
                 {
                     NSLog(@"%@",user.rawData[@"figureurl_qq_2"]);
                     NSLog(@"uid -- %@",user.uid);
                     NSLog(@"token=%@",user.credential.token);
                     NSLog(@"nickname=%@",user.nickname);
        
                     [self.photoimageV sd_setImageWithURL:[NSURL URLWithString:user.rawData[@"figureurl_qq_2"]]];
                     self.nameL.text = user.nickname;
        
                     [[NSUserDefaults standardUserDefaults] setObject:user.rawData[@"figureurl_qq_2"] forKey:@"LOGINIMAGE"];
                     [[NSUserDefaults standardUserDefaults] setObject:user.nickname forKey:@"LOGINNAME"];
                     [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:@"UID"];
                     
                     EMError *error = [[EMClient sharedClient] registerWithUsername:user.uid password:@"123"];
                     if (error==nil) {
                         NSLog(@"注册成功");
//                         [MBProgressHUD showSuccess:@"注册成功"];
                         
                         EMError *error = [[EMClient sharedClient] loginWithUsername:user.uid password:@"123"];
                         if (error==nil) {
                             NSLog(@"登录成功");
//                             [MBProgressHUD showSuccess:@"登录成功"];
                             [[EMClient sharedClient].options setIsAutoLogin:YES];
                             
                         }else{
                             NSLog(@"登录失败,%@",error.errorDescription);
                         }
                         
                     }else{
                         NSLog(@"注册失败,%@",error.errorDescription);
                         if (error.code == EMErrorUserAlreadyExist){
                             
                             EMError *error = [[EMClient sharedClient] loginWithUsername:user.uid password:@"123"];
                             if (error==nil) {
                                 NSLog(@"登录成功");
                                 //                             [MBProgressHUD showSuccess:@"登录成功"];
                                 [[EMClient sharedClient].options setIsAutoLogin:YES];
                                 
                             }else{
                                 NSLog(@"登录失败,%@",error.errorDescription);
                             }
                         }
                     }

                                          
                 }else{
                     [MBProgressHUD showError:@"登录失败"];
                 }
                 
             }];

    }else if ([title isEqualToString:@"微信"]){
        
    }else{
        
            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
             {
                 if (state == SSDKResponseStateSuccess)
                 {
                     NSLog(@"uid --- %@",user.uid);
                     NSLog(@"%@",user.icon);
                     NSLog(@"nickname=%@",user.nickname);
        
                     [self.photoimageV sd_setImageWithURL:[NSURL URLWithString:user.icon]];
                     self.nameL.text = user.nickname;

                     [[NSUserDefaults standardUserDefaults] setObject:user.icon forKey:@"LOGINIMAGE"];
                     [[NSUserDefaults standardUserDefaults] setObject:user.nickname forKey:@"LOGINNAME"];
                     [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:@"UID"];
        
                 }else{
                     [MBProgressHUD showError:@"登录失败"];
                 }
                 
             }];
    }
    
}


#pragma mark - 取消授权 退出
- (void)logoutBtnClick
{
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]) {
        NSLog(@"qq");
    }else{
        NSLog(@"不是");
    }
    
    if ([self.nameL.text isEqualToString:@"立即登录"]) {
        [MBProgressHUD showError:@"当前未登录账号"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要退出账号吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            [MBProgressHUD showSuccess:@"注销成功"];
        }
        
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        
        self.photoimageV.image = [UIImage imageNamed:@"comment_profile_default"];
        self.nameL.text = @"立即登录";
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"LOGINIMAGE"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"LOGINNAME"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"UID"];
    }
}

@end
