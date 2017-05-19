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

#import "TBloaderURLConnection.h"
#import "TBVideoRequestTask.h"

static void * playerItemDurationContext = &playerItemDurationContext;
static void * playerItemStatusContext = &playerItemStatusContext;
static void * playerPlayingContext = &playerPlayingContext;


@interface GYPlayer ()<TBloaderURLConnectionDelegate>

//
@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVAsset        *videoAsset;
@property (nonatomic, strong) TBloaderURLConnection *resouerLoader;

@property (nonatomic, strong) AVPlayerItem *            playerItem;
@property (nonatomic, strong) AVPlayerLayer *           playerLayer;
@property (nonatomic, strong) AVPlayer *                player;

//
@property (nonatomic, strong) GYHCircleLoadingView *    circleLoadingV;

@property (nonatomic, strong) UIView *                  bottomView;     //整个view
@property (nonatomic, strong) UILabel *                 lbTitle;        //视频标题
@property (nonatomic, strong) UIImageView *             imgBgTop;       //视频标题背景

@property (nonatomic, strong) UIView *                  bottomBar;      //底部工具栏
@property (nonatomic, strong) UIImageView *             imgBgBottom;    //视频底部背景
@property (nonatomic, strong) UIButton *                btnPlayOrPause; //播放暂停
@property (nonatomic, strong) UIButton *                btnFullScreen;  //全屏按钮

@property (nonatomic)         BOOL                      isFullScreen;

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIProgressView *progressView;//缓冲进度
@property (nonatomic, strong) UIProgressView *playProgressView;//播放进度

@property (nonatomic, strong) id timeObserver;

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

#pragma mark - Custom Accessors
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(44, 10, SCREEN_WIDTH-100, 5)];
    }
    return _slider;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH-100, 1)];
        //        _progressView.tintColor = [UIColor grayColor];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.trackTintColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        _progressView.progressTintColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _progressView;
}

- (UIProgressView *)playProgressView {
    if (!_playProgressView) {
        _playProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH-100, 1)];
        //        _progressView.tintColor = [UIColor grayColor];
        _playProgressView.backgroundColor = [UIColor clearColor];
        _playProgressView.trackTintColor =[UIColor clearColor];
        _playProgressView.progressTintColor =[UIColor lightGrayColor];
    }
    return _playProgressView;
}

//#pragma mark - lazy

- (TBloaderURLConnection *)resouerLoader {
    if (!_resouerLoader) {
        _resouerLoader = [[TBloaderURLConnection alloc] init];
        _resouerLoader.delegate = self;
    }
    return _resouerLoader;
}

//获取url是网络的还是本地的
- (AVPlayerItem *)getAVPlayItem{
    
    if ([self.mp4_url rangeOfString:@"http"].location != NSNotFound) {
        self.resouerLoader.filePath = [[AVCacheManager sharedInstance] getPathByFileName:self.mp4_url];
        NSURL *playUrl = [self.resouerLoader getSchemeVideoURL:[NSURL fileURLWithPath:_mp4_url]];
        //缓存资源
        self.videoURLAsset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        [self.videoURLAsset.resourceLoader setDelegate:self.resouerLoader queue:dispatch_get_main_queue()];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
        
        return playerItem;
    }else{
        AVURLAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.mp4_url] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}

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

- (void)setMp4_url:(NSString *)mp4_url {
//    _mp4_url = mp4_url;
    _mp4_url = [[AVCacheManager sharedInstance] isExistLocalFile:mp4_url];
    NSLog(@"%@",_mp4_url);
    
    [self.layer addSublayer:self.playerLayer];
    [self insertSubview:self.bottomView aboveSubview:self];
    [self insertSubview:self.circleLoadingV aboveSubview:self.bottomView];
    [self.circleLoadingV startAnimating];
//    [self.player play];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.lbTitle.text = _title;
}

#pragma mark - action
//添加kvo noti
- (void)addObserverAndNotification {
    //监控状态属性 AVPlayerStatusUnknown,AVPlayerStatusReadyToPlay,AVPlayerStatusFailed
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:playerItemStatusContext];
    //加载进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observePlayProgress {
    //监听播放进度
//    __weak typeof(self) weakSelf = self;
    @weakify_self;
    // 更新当前播放条目的已播时间, CMTimeMake(3, 30) == (Float64)3/30 秒
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:nil usingBlock:^(CMTime time) {
        @strongify_self;
        // 当前播放时间
//        NSString *curTime = [self timeStringWithCMTime:time];
        // 剩余时间
//        NSString *lastTime = [self timeStringWithCMTime:CMTimeSubtract(self.playerItem.duration, time)];
//        NSLog(@"当前播放时间:%@  剩余时间%@",curTime,lastTime);
        
        // 更新进度
        self.playProgressView.progress = CMTimeGetSeconds(time) / CMTimeGetSeconds(self.playerItem.duration);
    }];
}


#pragma mark 根据CMTime生成一个时间字符串
- (NSString *)timeStringWithCMTime:(CMTime)time {
    Float64 seconds = time.value / time.timescale;
    // 把seconds当作时间戳得到一个date
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    // 格林威治标准时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // 设置时间显示格式
    [formatter setDateFormat:(seconds / 3600 >= 1) ? @"h:mm:ss" : @"mm:ss"];
    
    // 返回这个date的字符串形式
    return [formatter stringFromDate:date];
}

//kvo监听播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *playerItem = object;
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
            if (status == AVPlayerStatusReadyToPlay){
                DLog(@"准备播放");
                [self.circleLoadingV stopAnimating];
                //            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
                //            self.totalDurationLabel.text = [self timeFormatted:self.totalDuration];
                [self.player play];
                //监听播放进度
                [self observePlayProgress];
                
            } else if (status == AVPlayerStatusFailed){
                DLog(@"播放失败");
            } else if (status == AVPlayerStatusUnknown){
                DLog(@"unknown");
            }
        }
        else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSArray *array = playerItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//            NSTimeInterval middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
//            NSLog(@"loadedTimeRanges:%f",middleValue);
            self.slider.value = totalBuffer / CMTimeGetSeconds(playerItem.duration);
            self.progressView.progress = totalBuffer / CMTimeGetSeconds(playerItem.duration);
            
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

- (void)up {
    if(self.superview) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [self isFullScreen:NO];
        } completion:nil];
    }
}

- (void)left {
    if (self.superview) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [self isFullScreen:YES];
        } completion:nil];
    }
}

//播放暂停
- (void)playOrPause:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
        [self.player play];
    } else {
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateNormal];
        [self.player pause];
    }
}

//全屏不全屏
- (void)fullScreen:(UIButton *)btn {
    //设置与当前状态相反的状态
    [self isFullScreen:!self.isFullScreen];
    if (self.isFullScreen) {
        [self.btnFullScreen setImage:[UIImage imageNamed:@"sc_video_play_fs_enter_ns_btn.png"] forState:UIControlStateNormal];
    } else {
        [self.btnFullScreen setImage:[UIImage imageNamed:@"sc_video_play_ns_enter_fs_btn.png"] forState:UIControlStateNormal];
    }
}

//是否全屏
- (void)isFullScreen:(BOOL)isFullScreen {
    if (isFullScreen) {
        self.isFullScreen = YES;
        
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.playerLayer.frame = self.bounds;
        //设置底部工具栏的frame
        self.bottomView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.imgBgTop.width = SCREEN_HEIGHT;
        self.lbTitle.width = SCREEN_HEIGHT - 20;
        self.bottomBar.originY = SCREEN_WIDTH - 37;
        self.bottomBar.width = SCREEN_HEIGHT;
        self.imgBgBottom.width = SCREEN_HEIGHT;
        self.btnFullScreen.originX = SCREEN_HEIGHT - 10 - 37;
        self.progressView.width = SCREEN_WIDTH - 100;
        self.playProgressView.width = SCREEN_WIDTH - 100;
        [theWindow addSubview:self];
    } else {
        self.isFullScreen = NO;
        
        self.transform = CGAffineTransformIdentity;
        self.frame = CGRectMake(0, self.currentOriginY, SCREEN_WIDTH, SCREEN_WIDTH * 0.56);
        self.playerLayer.frame = self.bounds;
        
        self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        self.lbTitle.width = SCREEN_WIDTH - 20;
        self.imgBgTop.width = SCREEN_WIDTH;
        self.bottomBar.originY = self.height - 37;
        self.bottomBar.width = SCREEN_WIDTH;
        self.imgBgBottom.width = SCREEN_WIDTH;
        self.btnFullScreen.originX = SCREEN_WIDTH - 10 - 37;
        self.progressView.width = SCREEN_WIDTH - 100;
        self.playProgressView.width = SCREEN_WIDTH - 100;
        
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
        
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    [self removePlayer];
}

#pragma mark - TBloaderURLConnectionDelegate

- (void)didFinishLoadingWithTask:(TBVideoRequestTask *)task
{
    NSLog(@"%s:下载完成",__func__);
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003
- (void)didFailLoadingWithTask:(TBVideoRequestTask *)task WithError:(NSInteger)errorCode
{
    NSString *str = nil;
    switch (errorCode) {
        case -1001:
            str = @"请求超时";
            break;
        case -1003:
        case -1004:
            str = @"服务器错误";
            break;
        case -1005:
            str = @"网络中断";
            break;
        case -1009:
            str = @"无网络连接";
            break;
            
        default:
            str = [NSString stringWithFormat:@"%@", @"(_errorCode)"];
            break;
    }
    NSLog(@"%s:%@",__func__,str);
}


- (UIView *)bottomView {
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        
        self.imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.imgBgTop.image = [UIImage imageNamed:@"top_shadow.png"];
        [_bottomView addSubview:self.imgBgTop];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 40)];
        self.lbTitle.font = [UIFont systemFontOfSize:16];
        self.lbTitle.numberOfLines = 0;
        self.lbTitle.textColor = HEXColor(@"ffffff");
        [_bottomView addSubview:self.lbTitle];
        
        
        self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 37, SCREEN_WIDTH, 37)];
        [_bottomView addSubview:self.bottomBar];
        
        self.imgBgBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
        self.imgBgBottom.image = [UIImage imageNamed:@"bottom_shadow.png"];
        [self.bottomBar addSubview:self.imgBgBottom];
        
        self.btnPlayOrPause = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 17, 17)];
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
        [self.btnPlayOrPause addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        self.btnPlayOrPause.selected = YES;
        [self.bottomBar addSubview:self.btnPlayOrPause];
        
        self.btnFullScreen = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 37, 0, 37, 37)];
        [self.btnFullScreen setImage:[UIImage imageNamed:@"sc_video_play_ns_enter_fs_btn.png"] forState:UIControlStateNormal];
        [self.btnFullScreen addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:self.btnFullScreen];
        
        [self.bottomBar addSubview:self.progressView];
        //        [self.bottomBar addSubview:self.slider];
        [self.bottomBar addSubview:self.playProgressView];
        
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

@end
