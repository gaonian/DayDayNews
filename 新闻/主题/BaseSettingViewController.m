//
//  BaseSettingViewController.m
//  新闻
//
//  Created by gyh on 16/3/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface BaseSettingViewController ()

@end

@implementation BaseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUIAppearce];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
}


-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self configUIAppearce];
}


-(void)configUIAppearce
{
    
}


@end
