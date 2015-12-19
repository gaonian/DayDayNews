//
//  DetailViewController.m
//  新闻
//
//  Created by gyh on 15/9/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DetailViewController.h"
#import "GCPlayer.h"

@interface DetailViewController ()
@property (nonatomic , strong) GCPlayer *player;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBackButton];
}

-(void)initBackButton
{

    self.player = [[GCPlayer alloc]initWithFrame:self.view.bounds];
    [self.player getPlayItem:_mp4url];
    [self.view addSubview:self.player];

    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, 25, 30, 30);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_white"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.player.playerr pause];
    [self.player removeFromSuperview];
}




@end
