//
//  GYPlayer.m
//  新闻
//
//  Created by 范英强 on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GYPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "GYHCircleLoadingView.h"

@interface GYPlayer ()

@property (nonatomic, strong) AVPlayerItem *            playerItem;
@property (nonatomic, strong) AVPlayerLayer *           playerLayer;
@property (nonatomic, strong) AVPlayer *                player;
@property (nonatomic, strong) GYHCircleLoadingView *    circleLoadingV;

@property (nonatomic, strong) UIView *                  bottomView;     //整个view
@property (nonatomic, strong) UILabel *                 lbTitle;        //视频标题

@property (nonatomic, strong) UIView *                  bottomBar;      //底部工具栏
@property (nonatomic, strong) UIButton *                btnPlayOrPause; //播放暂停

@end

@implementation GYPlayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        //监听屏幕改变
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
        
        self.circleLoadingV = [[GYHCircleLoadingView alloc]initWithViewFrame:CGRectMake(self.width/2-20, self.height/2-20, 40, 40)];
        [self addSubview:self.circleLoadingV];
        
    }
    return self;
}

- (void)setMp4_url:(NSString *)mp4_url {
    _mp4_url = mp4_url;
    [self.layer addSublayer:self.playerLayer];
    [self insertSubview:self.bottomView aboveSubview:self];
    [self insertSubview:self.circleLoadingV aboveSubview:self.bottomView];
    [self.circleLoadingV startAnimating];
    [self.player play];

}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.lbTitle.text = _title;
}

#pragma mark - action
//添加kvo noti
- (void)addObserverAndNotification {
    //监控状态属性 AVPlayerStatusUnknown,AVPlayerStatusReadyToPlay,AVPlayerStatusFailed
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //加载进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

//kvo监听播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay){
            DLog(@"准备播放");
            [self.circleLoadingV stopAnimating];
//            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
//            self.totalDurationLabel.text = [self timeFormatted:self.totalDuration];
        } else if (status == AVPlayerStatusFailed){
            DLog(@"播放失败");
        } else if (status == AVPlayerStatusUnknown){
            DLog(@"unknown");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSArray *array = playerItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
//        float startSeconds = CMTimeGetSeconds(timeRange.start);
//        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
//        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
////        self.slider.middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
//        //        NSLog(@"totalBuffer：%.2f",totalBuffer);
//        
//        //loading animation
//        if (self.slider.middleValue  <= self.slider.value || (totalBuffer - 1.0) < self.current) {
//            DLog(@"正在缓冲...");
//            self.activityIndicatorView.hidden = NO;
//            //            self.activityIndicatorView.center = self.center;
//            [self.activityIndicatorView startAnimating];
//        }else {
//            self.activityIndicatorView.hidden = YES;
//            if (self.playOrPauseBtn.selected) {
//                [self.player play];
//            }
//        }
    }
}

//屏幕改变
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
    if(self.superview){
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
//            VideoDataFrame *videoframe = self.videoArray[self.currtRow];
//            self.mpc.view.transform = CGAffineTransformIdentity;
//            self.mpc.view.frame = CGRectMake(0, videoframe.cellH*self.currtRow+videoframe.coverF.origin.y+SCREEN_WIDTH * 0.25, SCREEN_WIDTH, videoframe.coverF.size.height);
//            //            self.controlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//            [self.tableview addSubview:self.mpc.view];
            [self isFullScreen:NO];

        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)left
{
    if (self.superview) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            [self isFullScreen:YES];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)isFullScreen:(BOOL)isFullScreen {
    if (isFullScreen) {
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.playerLayer.frame = self.bounds;
        //设置底部工具栏的frame
        self.bottomView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.lbTitle.width = SCREEN_HEIGHT - 20;
        self.bottomBar.originY = SCREEN_WIDTH - 37;
        self.bottomBar.width = SCREEN_HEIGHT;
        [theWindow addSubview:self];
    } else {
        self.transform = CGAffineTransformIdentity;
        self.frame = CGRectMake(0, self.currentOriginY, SCREEN_WIDTH, SCREEN_WIDTH * 0.56);
        self.playerLayer.frame = self.bounds;
        
        self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        self.lbTitle.width = SCREEN_WIDTH - 20;
        self.bottomBar.originY = self.height - 37;
        self.bottomBar.width = SCREEN_WIDTH;

        if (self.currentRowBlock) {
            self.currentRowBlock();
        }
    }
}

- (void)removePlayer {
    if (self.superview) {
        [self.player pause];
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    [self removePlayer];
}

#pragma mark - lazy

- (AVPlayer *)player {
    if (!_player) {
        self.playerItem = [self getAVPlayItem];
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self addObserverAndNotification];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        
    }
    return _playerLayer;
}

//获取url是网络的还是本地的
- (AVPlayerItem *)getAVPlayItem{
    
    if ([self.mp4_url rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.mp4_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.mp4_url] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 40)];
        self.lbTitle.font = [UIFont systemFontOfSize:16];
        self.lbTitle.numberOfLines = 0;
        self.lbTitle.textColor = HEXColor(@"ffffff");
        [_bottomView addSubview:self.lbTitle];

        
        self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 37, SCREEN_WIDTH, 37)];
        self.bottomBar.backgroundColor = RGBA(1, 1, 1, 0.5);
        self.btnPlayOrPause = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 17, 17)];
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
        [self.bottomBar addSubview:self.btnPlayOrPause];
        [_bottomView addSubview:self.bottomBar];
        
        [self addSubview:_bottomView];
    }
    return _bottomView;
}





























@end
