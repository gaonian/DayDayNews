//
//  ClassViewController.m
//  新闻
//
//  Created by gyh on 15/9/29.
//  Copyright © 2015年 apple. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "ClassViewController.h"
#import "AFNetworking.h"
#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "GCPlayer.h"
#import "DetailViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "HYCircleLoadingView.h"

@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *videoArray;
@property (nonatomic , weak) UITableView *tableview;
@property (nonatomic , assign)int count;

@property (nonatomic, strong) MPMoviePlayerController *mpc;
@property (nonatomic, strong) MPMoviePlayerController *hpmpc;
@property (nonatomic , strong) UIView *cbfxView;
@property (nonatomic , strong) UIView *controlView;
@property (nonatomic , assign) int currtRow;

@property (nonatomic , assign) BOOL smallmpc;

@property (strong, nonatomic) HYCircleLoadingView *loadingView;
@end

@implementation ClassViewController

-(NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    [self initUI];
    
    //监听屏幕改变
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];

}

-(void)initUI
{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.frame = self.view.frame;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(ClassViewController);
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
}

- (void)initNetWork
{
    IMP_BLOCK_SELF(ClassViewController);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *getstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/%@/y/%d-10.html",_url,self.count];
    
    [mgr GET:getstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *dataarray = [VideoData objectArrayWithKeyValuesArray:responseObject[_url]];
        // 创建frame模型对象
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
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    cell.videodataframe = self.videoArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoframe = self.videoArray[indexPath.row];
    VideoData *videodata = videoframe.videodata;
    DLog(@"%@",videodata.mp4_url);

        
    if (self.mpc) {
        [self.mpc.view removeFromSuperview];
    }
    self.currtRow = (int)indexPath.row;
    // 创建播放器对象
    self.mpc = [[MPMoviePlayerController alloc] init];
    self.mpc.contentURL = [NSURL URLWithString:videodata.mp4_url];
    // 添加播放器界面到控制器的view上面
    self.mpc.view.frame = CGRectMake(0, videoframe.cellH*indexPath.row+videoframe.coverF.origin.y, SCREEN_WIDTH, videoframe.coverF.size.height);
    //设置加载指示器
    [self setupLoadingView];
   
    [self.tableview addSubview:self.mpc.view];
    
    
//    UIView *controlView = [[UIView alloc] init];
//    controlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//    [mpc.view addSubview:controlView];
//    self.controlView = controlView;
//    
////    [self setupStrolView];
//    UIButton *l1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
//    l1.backgroundColor = [UIColor blackColor];
//    [self.controlView addSubview:l1];
//    UIButton *l2 = [[UIButton alloc]initWithFrame:CGRectMake(self.controlView.frame.size.width-10-50, 10, 50, 30)];
//    l2.backgroundColor = [UIColor blackColor];
//    [l2 addTarget:self action:@selector(l2click) forControlEvents:UIControlEventTouchUpInside];
//    [self.controlView addSubview:l2];
//
    
    
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
    HYCircleLoadingView *loadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(self.mpc.view.frame.size.width/2-20, self.mpc.view.frame.size.height/2-20, 40, 40)];
    loadingView.loadingType = 1;
    [self.mpc.view addSubview:loadingView];
    self.loadingView = loadingView;
    [self loadingViewIsShowing:YES];
}

- (void)loadingViewIsShowing:(BOOL)isShowing
{
    _loadingView.hidden = !isShowing;
    if(isShowing){
        [_loadingView startAnimation];
    }
    else{
        [_loadingView stopAnimation];
    }
}

#pragma mark - 设置控制面板
- (void)setupStrolView
{
    UIButton *l1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    l1.backgroundColor = [UIColor whiteColor];
    [self.controlView addSubview:l1];
    UIButton *l2 = [[UIButton alloc]initWithFrame:CGRectMake(self.controlView.frame.size.width-10-50, 10, 50, 30)];
    l2.backgroundColor = [UIColor whiteColor];
    [l2 addTarget:self action:@selector(l2click) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView addSubview:l2];
}

- (void)l2click
{
    DLog(@"l2Click");
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoFrame = self.videoArray[indexPath.row];
    return videoFrame.cellH;
}



#pragma mark - 监听播放完毕
- (void)movieDidFinish
{
    DLog(@"----播放完毕");

//    if (self.mpc) {
//        [self.mpc.view removeFromSuperview];
//        self.mpc = nil;
//    }
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.mpc.view.frame.size.height)];
    vc.backgroundColor = [UIColor yellowColor];
    [self.mpc.view addSubview:vc];

}
#pragma mark - 监听播放状态
- (void)movieStateDidChange
{
    DLog(@"----播放状态--%ld", (long)self.mpc.playbackState);
    if (self.mpc.playbackState == 1) {
        [self loadingViewIsShowing:NO];
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
        
        if (self.smallmpc) {
            DLog(@"000");
        }else{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                
                VideoDataFrame *videoframe = self.videoArray[self.currtRow];
                self.mpc.view.transform = CGAffineTransformIdentity;
                self.mpc.view.frame = CGRectMake(0, videoframe.cellH*self.currtRow+videoframe.coverF.origin.y, SCREEN_WIDTH, videoframe.coverF.size.height);
                [self.tableview addSubview:self.mpc.view];
            } completion:^(BOOL finished) {
                
            }];
        }
    
    }
    
}

- (void)left
{
        if (self.mpc) {
            
            if (self.smallmpc) {
                DLog(@"小于");
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                    
                    self.mpc.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
                    
                    self.mpc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    //                self.controlView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50);
                    //                [self setupStrolView];
                    
                    UIWindow * window = [[UIApplication sharedApplication].delegate window];
                    [window addSubview:self.mpc.view];
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
        }

   
}
#pragma mark - 判断滚动事件，如何超出播放界面，停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.mpc) {

        if (fabs(scrollView.contentOffset.y)+64 > CGRectGetMaxY(self.mpc.view.frame)) {
//            [self.mpc stop];
//            [self.mpc.view removeFromSuperview];
//            self.mpc = nil;
            [self setupSmallmpc];
        }else{
//            self.smallmpc = NO;
//            VideoDataFrame *videoframe = self.videoArray[self.currtRow];
//            self.mpc.view.frame = CGRectMake(0, videoframe.cellH*self.currtRow+videoframe.coverF.origin.y, SCREEN_WIDTH, videoframe.coverF.size.height);
//            [self.tableview addSubview:self.mpc.view];
        }
    }
}

- (void)setupSmallmpc
{
    self.smallmpc = YES;
    self.mpc.view.frame = CGRectMake(SCREEN_WIDTH-20-200, SCREEN_HEIGHT - 120, 200, 200*0.56);
    [self.view addSubview:self.mpc.view];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.mpc) {
        DLog(@"销毁了");
        [self.mpc stop];
        [self.mpc.view removeFromSuperview];
        self.mpc = nil;
    }
    self.tableview.delegate = nil;
}

@end
