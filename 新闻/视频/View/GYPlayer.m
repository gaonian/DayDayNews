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
<<<<<<< HEAD
//    [self.player play];
//    self.playerItem = [self getAVPlayItem];
//    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
//    [self addObserverAndNotification];
=======
    [self insertSubview:self.circleLoadingV aboveSubview:self];
    [self.circleLoadingV startAnimating];
    
>>>>>>> a1cef1a8efcea6ed162fe444382ab53ff43df833
    [self.player play];

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
<<<<<<< HEAD
            
//            [self.player play];
=======
            [self.circleLoadingV stopAnimating];
>>>>>>> a1cef1a8efcea6ed162fe444382ab53ff43df833
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
//    if(self.){
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        
//        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
//            
//            VideoDataFrame *videoframe = self.videoArray[self.currtRow];
//            self.mpc.view.transform = CGAffineTransformIdentity;
//            self.mpc.view.frame = CGRectMake(0, videoframe.cellH*self.currtRow+videoframe.coverF.origin.y+SCREEN_WIDTH * 0.25, SCREEN_WIDTH, videoframe.coverF.size.height);
//            //            self.controlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//            [self.tableview addSubview:self.mpc.view];
//            
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
}

- (void)left
{
//    if (self.mpc) {
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
//            
//            self.mpc.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
//            self.mpc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            
//            [theWindow addSubview:self.mpc.view];
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
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

@end
