//
//  testViewController.m
//  新闻
//
//  Created by gyh on 15/9/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "testViewController.h"
#import "UIBarButtonItem+gyh.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithIcon:@"dislike" highIcon:nil target:self action:@selector(like)];
    
    
    [self initWebView];
    
}

-(void)like
{
    
}



-(void)initWebView
{
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *webview = [[UIWebView alloc]init];
    webview.frame = self.view.frame;
    [webview loadRequest:request];
    [self.view addSubview:webview];
}


@end
