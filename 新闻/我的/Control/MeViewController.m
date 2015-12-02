//
//  MeViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MeViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface MeViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_oauth;
}
@property (nonatomic , weak) UIImageView *iV;


@property (nonatomic , strong) NSString *clearCacheName;
@end

@implementation MeViewController

-(NSString *)clearCacheName
{
    if (!_clearCacheName) {
        
        float tmpSize = [[SDImageCache sharedImageCache]getSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fMB",tmpSize/(1024*1024)] : [NSString stringWithFormat:@"%.1fKB",tmpSize * 1024];
        _clearCacheName = clearCacheName;
        
    }
    return _clearCacheName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:self.clearCacheName forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(200, 300, 100, 50)];
    [btn1 setTitle:@"登录" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIImageView *iV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 400, 100, 100)];
    [self.view addSubview:iV];
    self.iV = iV;
    
    
    [self inittencent];
}

- (void)click
{
    [[SDImageCache sharedImageCache]clearDisk];
    
}

- (void)inittencent
{
//    _oauth = [[TencentOAuth alloc]initWithAppId:@"1104984866" andDelegate:self];
    
}

- (void)login
{
    _oauth = [[TencentOAuth alloc]initWithAppId:@"1104984866" andDelegate:self];
    [_oauth authorize:nil inSafari:NO];
}


- (void)tencentDidLogin
{
    NSLog(@"登录成功");
    if ([_oauth getUserInfo]) {
        
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    /*
     figureurl_qq_2  //qq头像
     nickname        //昵称
     province
     city
     */
    NSLog(@"%@",response.jsonResponse[@"figureurl_qq_2"]);
    
    [self.iV sd_setImageWithURL:[NSURL URLWithString:response.jsonResponse[@"figureurl_qq_2"]]];
}

@end
