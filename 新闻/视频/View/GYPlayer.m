//
//  GYPlayer.m
//  新闻
//
//  Created by 范英强 on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GYPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface GYPlayer ()

@property (nonatomic, strong) AVPlayerItem *        playerItem;
@property (nonatomic, strong) AVPlayerLayer *       playerLayer;
@property (nonatomic, strong) AVPlayer *            player;

@end

@implementation GYPlayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        //监听屏幕改变
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];

    }
    return self;
}

- (void)setMp4_url:(NSString *)mp4_url {
    _mp4_url = mp4_url;
//    DLog(@"%@",NSStringFromCGRect(self.playerLayer.frame));
//    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
//    [self.player play];
//    self.playerItem = [self getAVPlayItem];
//    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
//    [self addObserverAndNotification];
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
            
            [self.player play];
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

#pragma mark - lazy

- (AVPlayer *)player {
    if (!_player) {
//        _player = [[AVPlayer alloc] init];
        self.playerItem = [self getAVPlayItem];
//        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor redColor].CGColor;
//        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        
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
