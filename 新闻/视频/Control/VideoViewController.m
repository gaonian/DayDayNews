//
//  VideoViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "VideoViewController.h"
#import "testViewController.h"
#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "DetailViewController.h"
#import "TabbarButton.h"
#import "ClassViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GYHCircleLoadingView.h"
#import "CategoryView.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *             videoArray;
@property (nonatomic , weak) UITableView *                  tableview;
@property (nonatomic , assign)int                           count;
@property (nonatomic , strong) TabbarButton *               btn;

@property (nonatomic , strong) MPMoviePlayerController *    mpc;
@property (nonatomic , assign) int                          currtRow;
@property (nonatomic , strong) GYHCircleLoadingView *       circleLoadingV;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
    [self initUI];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:self.title object:nil];
    
    //监听屏幕改变
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
    
}
- (void)mynotification
{
    [self.tableview.header beginRefreshing];
}

- (void)initUI
{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.frame = self.view.frame;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(VideoViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        block_self.count = 0;
        [block_self initNetWork];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    [header beginRefreshing];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self initNetWork];
    }];
    
    CategoryView *view = [[CategoryView alloc]init];
    view.SelectBlock = ^(NSString *tag, NSString *title) {
        NSArray *arr = @[@"VAP4BFE3U",
                         @"VAP4BFR16",
                         @"VAP4BG6DL",
                         @"VAP4BGTVD"];
        
        ClassViewController *classVC = [[ClassViewController alloc]init];
        classVC.url = arr[[tag intValue]];
        classVC.title = title;
        [block_self.navigationController pushViewController:classVC animated:YES];
    };
    self.tableview.tableHeaderView = view;
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    if ([[[ThemeManager sharedInstance] themeName] isEqualToString:@"高贵紫"]) {
        cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.videodataframe = self.videoArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoframe = self.videoArray[indexPath.row];
    VideoData *videodata = videoframe.videodata;
    
    if (self.mpc) {
        [self.mpc.view removeFromSuperview];
    }
    self.currtRow = (int)indexPath.row;
    // 创建播放器对象
    self.mpc = [[MPMoviePlayerController alloc] init];
    self.mpc.contentURL = [NSURL URLWithString:videodata.mp4_url];
    // 添加播放器界面到控制器的view上面
    self.mpc.view.frame = CGRectMake(0, videoframe.cellH*indexPath.row+videoframe.coverF.origin.y+SCREEN_WIDTH * 0.25, SCREEN_WIDTH, videoframe.coverF.size.height);
    //设置加载指示器
    [self setupLoadingView];
    
    [self.tableview addSubview:self.mpc.view];
    
    // 隐藏自动自带的控制面板
    self.mpc.controlStyle = MPMovieControlStyleNone;
    
    // 监听播放器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:self.mpc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStateDidChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mpc];
    
    [self.mpc play];

}


#pragma mark - 设置加载指示器
- (void)setupLoadingView
{
    self.circleLoadingV = [[GYHCircleLoadingView alloc]initWithViewFrame:CGRectMake(self.mpc.view.frame.size.width/2-20, self.mpc.view.frame.size.height/2-20, 40, 40)];
    self.circleLoadingV.isShowProgress = YES;   //设置中间label进度条
    [self.mpc.view addSubview:self.circleLoadingV];
    [self.circleLoadingV startAnimating];
}


#pragma mark - 设置控制面板
- (void)setupStrolView
{

}


#pragma mark - 监听播放完毕
- (void)movieDidFinish
{
    DLog(@"----播放完毕");
    if (self.mpc) {
        [self.mpc.view removeFromSuperview];
        self.mpc = nil;
    }
}

#pragma mark - 监听播放状态
- (void)movieStateDidChange
{
    DLog(@"----播放状态--%ld", (long)self.mpc.playbackState);
    if (self.mpc.playbackState == 1) {
        [self.circleLoadingV stopAnimating];
    }
}


#pragma mark - 屏幕改变
- (void)orientationChanged:(NSNotification *)note  {
    
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:            // 屏幕变正
            DLog(@"屏幕变正");
            [self up];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:       //屏幕左转
            DLog(@"屏幕变左");
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [self left];
            
            break;
        case UIDeviceOrientationLandscapeRight:   //屏幕右转
            DLog(@"屏幕变右");
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            
            
            break;
        default:
            break;
    }
}

- (void)up
{
    if(self.mpc){
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            VideoDataFrame *videoframe = self.videoArray[self.currtRow];
            self.mpc.view.transform = CGAffineTransformIdentity;
            self.mpc.view.frame = CGRectMake(0, videoframe.cellH*self.currtRow+videoframe.coverF.origin.y+SCREEN_WIDTH * 0.25, SCREEN_WIDTH, videoframe.coverF.size.height);
            //            self.controlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            [self.tableview addSubview:self.mpc.view];
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)left
{
    if (self.mpc) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            self.mpc.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
            self.mpc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            [theWindow addSubview:self.mpc.view];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoFrame = self.videoArray[indexPath.row];
    return videoFrame.cellH;
}

//判断滚动事件，如何超出播放界面，停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.mpc) {
        
        if (fabs(scrollView.contentOffset.y)+64 > CGRectGetMaxY(self.mpc.view.frame)) {
            
                [self.mpc stop];
                [self.mpc.view removeFromSuperview];
                self.mpc = nil;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (self.mpc) {
        [self.mpc stop];
        [self.mpc.view removeFromSuperview];
        self.mpc = nil;
    }
}

- (void)initNetWork
{
    IMP_BLOCK_SELF(VideoViewController);
    NSString *getstr = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-10.html",self.count];
    
    [[BaseEngine shareEngine] runRequestWithPara:nil path:getstr success:^(id responseObject) {
        
        NSArray *dataarray = [VideoData objectArrayWithKeyValuesArray:responseObject[@"videoList"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (VideoData *videodata in dataarray) {
            VideoDataFrame *videodataFrame = [[VideoDataFrame alloc] init];
            videodataFrame.videodata = videodata;
            [statusFrameArray addObject:videodataFrame];
        }
        
        if (block_self.videoArray.count == 0) {
            block_self.videoArray = statusFrameArray;
        }else{
            [block_self.videoArray addObjectsFromArray:statusFrameArray];
        }
        
        block_self.count += 10;
        [block_self.tableview reloadData];
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
        block_self.tableview.footer.hidden = block_self.videoArray.count < 10;

    } failure:^(id error) {
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
    }];
}

-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [defaultManager themeColor];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.tableview reloadData];
}

#pragma mark - lazy
- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
@end
