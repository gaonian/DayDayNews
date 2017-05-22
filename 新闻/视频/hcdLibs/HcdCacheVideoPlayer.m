//
//  ____    ___   _        ___  _____  ____  ____  ____
// |    \  /   \ | T      /  _]/ ___/ /    T|    \|    \
// |  o  )Y     Y| |     /  [_(   \_ Y  o  ||  o  )  o  )
// |   _/ |  O  || l___ Y    _]\__  T|     ||   _/|   _/
// |  |   |     ||     T|   [_ /  \ ||  _  ||  |  |  |
// |  |   l     !|     ||     T\    ||  |  ||  |  |  |
// l__j    \___/ l_____jl_____j \___jl__j__jl__j  l__j
//
//
//	Powered by Polesapp.com
//
//
//  HcdCachePlayer.m
//  hcdCachePlayerDemo
//
//  Created by polesapp-hcd on 16/7/4.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdCacheVideoPlayer.h"
#import "HcdCachePlayer.h"

#define LeastMoveDistance 15
#define TotalScreenTime 90

NSString *const kHCDPlayerStateChangedNotification    = @"HCDPlayerStateChangedNotification";
NSString *const kHCDPlayerProgressChangedNotification = @"HCDPlayerProgressChangedNotification";
NSString *const kHCDPlayerLoadProgressChangedNotification = @"HCDPlayerLoadProgressChangedNotification";

static NSString *const HCDVideoPlayerItemStatusKeyPath = @"status";
static NSString *const HCDVideoPlayerItemLoadedTimeRangesKeyPath = @"loadedTimeRanges";
static NSString *const HCDVideoPlayerItemPlaybackBufferEmptyKeyPath = @"playbackBufferEmpty";
static NSString *const HCDVideoPlayerItemPlaybackLikelyToKeepUpKeyPath = @"playbackLikelyToKeepUp";
static NSString *const HCDVideoPlayerItemPresentationSizeKeyPath = @"presentationSize";

typedef enum : NSUInteger {
    HCDPlayerControlTypeProgress,
    HCDPlayerControlTypeVoice,
    HCDPlayerControlTypeLight,
    HCDPlayerControlTypeNone = 999,
} HCDPlayerControlType;


//私有类
@interface HcdPlayerView : UIView
@end
@implementation HcdPlayerView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
@end


@interface HcdCacheVideoPlayer()<HCDLoaderURLConnectionDelegate, UIGestureRecognizerDelegate>
{
    //用来控制上下菜单view隐藏的timer
    NSTimer * _hiddenTimer;
    UIInterfaceOrientation _currentOrientation;
    
    //用来判断手势是否移动过
    BOOL _hasMoved;
    //判断是否已经判断出手势划的方向
    BOOL _controlJudge;
    //触摸开始触碰到的点
    CGPoint _touchBeginPoint;
    //记录触摸开始时的视频播放的时间
    float _touchBeginValue;
    //记录触摸开始亮度
    float _touchBeginLightValue;
    //记录触摸开始的音量
    float _touchBeginVoiceValue;
}

@property (nonatomic, assign) HCDPlayerState state;
@property (nonatomic, assign) CGFloat        loadedProgress;
@property (nonatomic, assign) CGFloat        duration;
@property (nonatomic, assign) CGFloat        current;

@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVAsset        *videoAsset;
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
//@property (nonatomic, strong) AVPlayerLayer  *currentPlayerLayer;
@property (nonatomic, strong) NSObject       *playbackTimeObserver;
@property (nonatomic, assign) BOOL           isPauseByUser;           //是否被用户暂停
@property (nonatomic, assign) BOOL           isLocalVideo;            //是否播放本地文件
@property (nonatomic, assign) BOOL           isFinishLoad;            //是否下载完毕

@property (nonatomic, weak  ) UIView         *showView;
@property (nonatomic, assign) CGRect         showViewRect;            //视频展示ViewRect
@property (nonatomic, strong) HcdPlayerView  *playerLayerView;
@property (nonatomic, strong) UIView         *touchView;              //事件响应View
@property (nonatomic, weak  ) UIView         *playerSuperView;        //播放界面的父页面

@property (nonatomic, strong) UIView         *statusBarBgView;        //全屏状态栏的背景view
@property (nonatomic, strong) UIView         *toolView;
@property (nonatomic, strong) UILabel        *currentTimeLbl;
@property (nonatomic, strong) UILabel        *totalTimeLbl;
@property (nonatomic, strong) UIProgressView *videoProgressView;      //缓冲进度条
@property (nonatomic, strong) UISlider       *playSlider;             //滑竿
@property (nonatomic, strong) UIButton       *stopButton;             //播放暂停按钮
@property (nonatomic, strong) UIButton       *screenButton;           //全屏按钮
@property (nonatomic, strong) UIButton       *repeatBtn;              //重播按钮
@property (nonatomic, assign) BOOL           isFullScreen;
@property (nonatomic, assign) BOOL           canFullScreen;
@property (nonatomic, strong) UIActivityIndicatorView *actIndicator;  //加载视频时的旋转菊花

@property (nonatomic, strong) MPVolumeView   *volumeView;             //音量控制控件
@property (nonatomic, strong) UISlider       *volumeSlider;           //用这个来控制音量

@property (nonatomic, strong) HcdLoaderURLConnection *resouerLoader;

@property (nonatomic, assign) HCDPlayerControlType controlType;       //当前手势是在控制进度、声音还是亮度
@property (nonatomic, strong) HcdTimeSheetView *timeSheetView;        //左右滑动时间View
@end

@implementation HcdCacheVideoPlayer

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static HcdCacheVideoPlayer *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPauseByUser = YES;
        _loadedProgress = 0;
        _duration = 0;
        _current  = 0;
        _state = HCDPlayerStateStopped;
        _stopInBackground = YES;
        _isFullScreen = NO;
        _canFullScreen = YES;
        _playRepatCount = 1;
        _playCount = 1;
        
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                _currentOrientation = UIInterfaceOrientationPortrait;
                break;
            case UIDeviceOrientationLandscapeLeft:
                _currentOrientation = UIInterfaceOrientationLandscapeLeft;
                break;
            case UIDeviceOrientationLandscapeRight:
                _currentOrientation = UIInterfaceOrientationLandscapeRight;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                _currentOrientation = UIInterfaceOrientationPortraitUpsideDown;
                break;
            default:
                break;
        }
//        [HcdLightView sharedInstance];
    }
    return self;
}

- (HcdLoaderURLConnection *)resouerLoader {
    if (!_resouerLoader) {
        _resouerLoader = [[HcdLoaderURLConnection alloc] init];
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
        self.currentPlayerItem = [self getAVPlayItem];
        _player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
//        [self addObserverAndNotification];
    }
    return _player;
}

- (void)playWithVideoUrl:(NSString *)urlString showView:(UIView *)showView andSuperView:(UIView *)superView
{
    [superView addSubview:showView];
    self.mp4_url = [[AVCacheManager sharedInstance] isExistLocalFile:urlString];
    
//    [self.player pause];
//    [self releasePlayer];
    
    self.isPauseByUser = NO;
    self.loadedProgress = 0;
    self.duration = 0;
    self.current  = 0;
    
    _showView = showView;
    _showViewRect = showView.frame;
    _showView.backgroundColor = [UIColor blackColor];
    _playerSuperView = superView;
    
    [(AVPlayerLayer *)self.playerLayerView.layer setPlayer:self.player];
    
//    return;
    [self.currentPlayerItem addObserver:self forKeyPath:HCDVideoPlayerItemStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:HCDVideoPlayerItemLoadedTimeRangesKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [self.currentPlayerItem addObserver:self forKeyPath:HCDVideoPlayerItemPlaybackBufferEmptyKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:HCDVideoPlayerItemPlaybackLikelyToKeepUpKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:HCDVideoPlayerItemPresentationSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.currentPlayerItem];
    
    [self setVideoToolView];
    
    //    [self updateOrientation];
}

- (void)fullScreen {
    //如果全屏下
    if (_isFullScreen) {
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
    [self showToolView];
}

- (void)halfScreen {
    
}

+ (void)clearAllVideoCache {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //这里自己写需要保存数据的路径
    NSString *cachPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSArray *childFiles = [fileManager subpathsAtPath:cachPath];
    for (NSString *fileName in childFiles) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSLog(@"%@", fileName);
        if ([fileName.pathExtension isEqualToString:@"mp4"]) {
            NSString *absolutePath=[cachPath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

+ (double)allVideoCacheSize {
    
    double cacheVideoSize = 0.0f;
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //这里自己写需要保存数据的路径
    NSString *cachPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSArray *childFiles = [fileManager subpathsAtPath:cachPath];
    for (NSString *fileName in childFiles) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSLog(@"%@", fileName);
        if ([fileName.pathExtension isEqualToString:@"mp4"]) {
            NSString *path = [cachPath stringByAppendingPathComponent: fileName];
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath: path error: nil ];
            cacheVideoSize += ((double)([fileAttributes fileSize ]) / 1024.0 / 1024.0);
        }
    }
    
    return cacheVideoSize;
}

+ (void)clearVideoCache:(NSString *)url {
    
}

- (void)seekToTime:(CGFloat)seconds {
    if (self.state == HCDPlayerStateStopped) {
        return;
    }
    
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, self.duration);
    
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        self.isPauseByUser = NO;
        [self.player play];
        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            self.state = HCDPlayerStateBuffering;
            
            self.actIndicator.hidden = NO;
            [self.actIndicator startAnimating];
            //            [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:nil acitivity:YES autoHideTime:0];
        }
        
    }];
}

#pragma mark - observer

- (void)appDidEnterBackground
{
    if (self.stopInBackground) {
        [self pause];
        self.state = HCDPlayerStatePause;
        self.isPauseByUser = NO;
    }
}
- (void)appDidEnterPlayGround
{
    if (!self.isPauseByUser) {
        [self resume];
        self.state = HCDPlayerStatePlaying;
    }
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification
{
    //    [self stop];
    
    //如果当前播放次数小于重复播放次数，继续重新播放
    if (self.playCount < self.playRepatCount) {
        self.playCount++;
        [self seekToTime:0];
        [self updateCurrentTime:0];
    } else {
        
        //如果有播放下一个的需求就播放下一个
        if (self.playNextBlock) {
            self.playNextBlock();
        } else {
            //重新播放
            self.repeatBtn.hidden = NO;
            [self toolViewHidden];
            self.state = HCDPlayerStateFinish;
            [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_play")] forState:UIControlStateNormal];
            [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_play_hl")] forState:UIControlStateHighlighted];
        }
    }
}

//在监听播放器状态中处理比较准确
- (void)playerItemPlaybackStalled:(NSNotification *)notification
{
    // 这里网络不好的时候，就会进入，不做处理，会在playbackBufferEmpty里面缓存之后重新播放
    NSLog(@"buffing----buffing");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([HCDVideoPlayerItemStatusKeyPath isEqualToString:keyPath]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            _hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(toolViewHidden) userInfo:nil repeats:NO];
            [self monitoringPlayback:playerItem];// 给播放器添加计时器
            
        } else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
            [self stop];
        }
        
    } else if ([HCDVideoPlayerItemLoadedTimeRangesKeyPath isEqualToString:keyPath]) {  //监听播放器的下载进度
        
        [self calculateDownloadProgress:playerItem];
        
    } else if ([HCDVideoPlayerItemPlaybackBufferEmptyKeyPath isEqualToString:keyPath]) { //监听播放器在缓冲数据的状态
        //        [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:nil acitivity:YES autoHideTime:0];
        [self.actIndicator startAnimating];
        self.actIndicator.hidden = NO;
        if (playerItem.isPlaybackBufferEmpty) {
            self.state = HCDPlayerStateBuffering;
            [self bufferingSomeSecond];
        }
    } else if ([HCDVideoPlayerItemPlaybackLikelyToKeepUpKeyPath isEqualToString:keyPath]) {
        NSLog(@"HCDVideoPlayerItemPlaybackLikelyToKeepUpKeyPath");
    } else if ([HCDVideoPlayerItemPresentationSizeKeyPath isEqualToString:keyPath]) {
        CGSize size = self.currentPlayerItem.presentationSize;
        static float staticHeight = 0;
        staticHeight = size.height/size.width * kScreenWidth;
        NSLog(@"%f", staticHeight);
        
        //用来监测屏幕旋转
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        _canFullScreen = YES;
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    
    self.duration = playerItem.duration.value / playerItem.duration.timescale; //视频总时间
    [self.player play];
    [self updateTotolTime:self.duration];
    [self setPlaySliderValue:self.duration];
    
    __weak __typeof(self)weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGFloat current = playerItem.currentTime.value / playerItem.currentTime.timescale;
        [strongSelf updateCurrentTime:current];
        [strongSelf updateVideoSlider:current];
        if (strongSelf.isPauseByUser == NO) {
            strongSelf.state = HCDPlayerStatePlaying;
        }
        
        // 不相等的时候才更新，并发通知，否则seek时会继续跳动
        if (strongSelf.current != current) {
            strongSelf.current = current;
            if (strongSelf.current > strongSelf.duration) {
                strongSelf.duration = strongSelf.current;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kHCDPlayerProgressChangedNotification object:nil];
        }
        
    }];
    
}

- (void)unmonitoringPlayback:(AVPlayerItem *)playerItem {
    if (self.playbackTimeObserver != nil) {
        [self.player removeTimeObserver:self.playbackTimeObserver];
        self.playbackTimeObserver = nil;
    }
}

- (void)calculateDownloadProgress:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
    CMTime duration = playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    self.loadedProgress = timeInterval / totalDuration;
    [self.videoProgressView setProgress:timeInterval / totalDuration animated:YES];
}

- (void)bufferingSomeSecond
{
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self.player play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}

- (void)setLoadedProgress:(CGFloat)loadedProgress
{
    if (_loadedProgress == loadedProgress) {
        return;
    }
    
    _loadedProgress = loadedProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:kHCDPlayerLoadProgressChangedNotification object:nil];
}

- (void)setState:(HCDPlayerState)state
{
    if (state != HCDPlayerStateBuffering) {
        //        [[XCHudHelper sharedInstance] hideHud];
        [self.actIndicator stopAnimating];
        self.actIndicator.hidden = YES;
    }
    
    if (_state == state) {
        return;
    }
    
    _state = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:kHCDPlayerStateChangedNotification object:nil];
    
}

#pragma mark - 界面控件初始化

- (HcdPlayerView *)playerLayerView {
    if (!_playerLayerView) {
        _playerLayerView = [[HcdPlayerView alloc]init];
    }
    return _playerLayerView;
}

- (UIView *)statusBarBgView {
    if (!_statusBarBgView) {
        _statusBarBgView = [[UIView alloc]init];
        _statusBarBgView.backgroundColor = [UIColor blackColor];
        _statusBarBgView.hidden = YES;
    }
    return _statusBarBgView;
}

- (UIView *)toolView {
    
    if (!_toolView) {
        _toolView = [[UIView alloc]init];
        _toolView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    return _toolView;
}

- (UIView *)touchView {
    if (!_touchView) {
        _touchView = [[UIView alloc] init];
        _touchView.backgroundColor = [UIColor clearColor];
    }
    return _touchView;
}

- (UILabel *)currentTimeLbl {
    
    if (!_currentTimeLbl) {
        _currentTimeLbl = [[UILabel alloc]init];
        _currentTimeLbl.textColor = [UIColor whiteColor];
        _currentTimeLbl.font = [UIFont systemFontOfSize:10.0];
        _currentTimeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLbl;
}

- (UILabel *)totalTimeLbl {
    
    if (!_totalTimeLbl) {
        _totalTimeLbl = [[UILabel alloc]init];
        _totalTimeLbl.textColor = [UIColor whiteColor];
        _totalTimeLbl.font = [UIFont systemFontOfSize:10.0];
        _totalTimeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLbl;
}

- (UIProgressView *)videoProgressView {
    
    if (!_videoProgressView) {
        _videoProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _videoProgressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];  //填充部分颜色
        _videoProgressView.trackTintColor = [UIColor clearColor];   // 未填充部分颜色
        _videoProgressView.layer.cornerRadius = 0.5;
        _videoProgressView.layer.masksToBounds = YES;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
        _videoProgressView.transform = transform;
    }
    return _videoProgressView;
}

- (UISlider *)playSlider {
    if (!_playSlider) {
        _playSlider = [[UISlider alloc] init];
        [_playSlider setThumbImage:[UIImage imageNamed:HcdImageSrcName(@"icon_progress")] forState:UIControlStateNormal];
        _playSlider.minimumTrackTintColor = [UIColor whiteColor];
        _playSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [_playSlider addTarget:self action:@selector(playSliderChange:) forControlEvents:UIControlEventValueChanged]; //拖动滑竿更新时间
        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpInside];  //松手,滑块拖动停止
        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpOutside];
        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchCancel];
    }
    
    return _playSlider;
}

- (UIButton *)stopButton {
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton addTarget:self action:@selector(resumeOrPause) forControlEvents:UIControlEventTouchUpInside];
        [_stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause")] forState:UIControlStateNormal];
        [_stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause_hl")] forState:UIControlStateHighlighted];
    }
    return _stopButton;
}

- (UIButton *)screenButton {
    if (!_screenButton) {
        _screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenButton addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        [_screenButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_full")] forState:UIControlStateNormal];
        [_screenButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_full")] forState:UIControlStateHighlighted];
    }
    return _screenButton;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_repeat_video")] forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatPlay) forControlEvents:UIControlEventTouchUpInside];
        _repeatBtn.hidden = YES;
    }
    return _repeatBtn;
}

- (UIActivityIndicatorView *)actIndicator {
    if (!_actIndicator) {
        _actIndicator = [[UIActivityIndicatorView alloc]init];
    }
    return _actIndicator;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.showsRouteButton = NO;
        _volumeView.showsVolumeSlider = NO;
        for (UIView * view in _volumeView.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"MPVolumeSlider"]) {
                self.volumeSlider = (UISlider *)view;
                break;
            }
        }
        NSLog(@"%f %f", _volumeView.frame.size.width, _volumeView.frame.size.height);
    }
    return _volumeView;
}

- (HcdTimeSheetView *)timeSheetView {
    if (!_timeSheetView) {
        _timeSheetView = [[HcdTimeSheetView alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
        _timeSheetView.hidden = YES;
        _timeSheetView.layer.cornerRadius = 10.0;
    }
    return _timeSheetView;
}

#pragma mark - 设置进度条、暂停、全屏等组件

- (void)setVideoToolView {
    
    __weak HcdCacheVideoPlayer * weakSelf = self;
    
    _showView.userInteractionEnabled = YES;
    
    [self.playerLayerView removeFromSuperview];
    [_showView addSubview:self.playerLayerView];
    [self.playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    [self.statusBarBgView removeFromSuperview];
    [_showView addSubview:self.statusBarBgView];
    [self.statusBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    self.toolView.frame = CGRectMake(0, CGRectGetHeight(_showView.frame) - 44, CGRectGetWidth(_showView.frame), 44);
    [self.toolView removeFromSuperview];
    [_showView addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.equalTo(weakSelf.showView);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    self.stopButton.frame = CGRectMake(0, 0, 44, 44);
    [self.stopButton removeFromSuperview];
    [self.toolView addSubview:self.stopButton];
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    self.screenButton.frame = CGRectMake(CGRectGetWidth(self.toolView.frame) - 44, 0, 44, 44);
    [self.screenButton removeFromSuperview];
    [self.toolView addSubview:self.screenButton];
    [self.screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    self.currentTimeLbl.frame = CGRectMake(44, 0, 52, 44);
    [self.currentTimeLbl removeFromSuperview];
    [self.toolView addSubview:self.currentTimeLbl];
    [self.currentTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(44);
    }];
    
    self.totalTimeLbl.frame = CGRectMake(CGRectGetWidth(self.toolView.frame) - 52 - 44, 0, 52, 44);
    [self.totalTimeLbl removeFromSuperview];
    [self.toolView addSubview:self.totalTimeLbl];
    [self.totalTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.equalTo(weakSelf.screenButton.mas_left);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(44);
    }];
    
    CGFloat playSliderWidth = CGRectGetWidth(self.toolView.frame) - 2 * CGRectGetMaxX(self.currentTimeLbl.frame);
    self.videoProgressView.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLbl.frame), 21, playSliderWidth, 20);
    
    self.playSlider.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLbl.frame), 0, playSliderWidth, 44);
    [self.playSlider removeFromSuperview];
    [self.toolView addSubview:self.playSlider];
    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentTimeLbl.mas_right);
        make.top.mas_equalTo(0);
        make.right.equalTo(weakSelf.totalTimeLbl.mas_left);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.videoProgressView removeFromSuperview];
    [self.toolView addSubview:self.videoProgressView];
    [self.videoProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentTimeLbl.mas_right);
        make.right.equalTo(weakSelf.totalTimeLbl.mas_left);
        make.centerY.equalTo(weakSelf.playSlider.mas_centerY).offset(1);
        make.height.mas_equalTo(1);
    }];
    
    self.actIndicator.frame = CGRectMake((CGRectGetWidth(_showView.frame) - 37) / 2, (CGRectGetHeight(_showView.frame) - 37) / 2, 37, 37);
    [self.actIndicator removeFromSuperview];
    [_showView addSubview:self.actIndicator];
    [self.actIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.playerLayerView);
        make.centerY.equalTo(weakSelf.playerLayerView);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    self.touchView.frame = CGRectMake(0, 0, CGRectGetWidth(_showView.frame), CGRectGetHeight(_showView.frame) - 44);
    [self.touchView removeFromSuperview];
    [_showView addSubview:self.touchView];
    [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.playerLayerView);
        make.left.equalTo(weakSelf.playerLayerView);
        make.right.equalTo(weakSelf.playerLayerView);
        make.bottom.equalTo(weakSelf.playerLayerView).offset(-44);
    }];
    
    [self.volumeView removeFromSuperview];
    [_showView addSubview:self.volumeView];
    
    [self.timeSheetView removeFromSuperview];
    [_showView addSubview:self.timeSheetView];
    [self.timeSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_showView);
        make.width.equalTo(@(120));
        make.height.equalTo(@60);
    }];
    
    [self.repeatBtn removeFromSuperview];
    [_showView addSubview:self.repeatBtn];
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_showView);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self.touchView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.touchView addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTapAction:)];
    sliderTap.numberOfTapsRequired = 1;
    sliderTap.numberOfTouchesRequired = 1;
    sliderTap.delegate = self;
    [self.playSlider addGestureRecognizer:sliderTap];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (_controlJudge) {
        return NO;
    }else{
        return YES;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    //点击一次
    if (tap.numberOfTapsRequired == 1) {
        if (self.toolView.hidden) {
            [self showToolView];
        } else {
            [self toolViewHidden];
        }
    } else if(tap.numberOfTapsRequired == 2){
        [self resumeOrPause];
    }
}

- (void)sliderTapAction:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 1) {
        NSLog(@"点击了playSlider");
        CGPoint touchPoint = [tap locationInView:self.playSlider];
        NSLog(@"(%f,%f)", touchPoint.x, touchPoint.y);
        NSLog(@"%f duration:%f", self.playSlider.frame.size.width, self.duration);
        
        float value = (touchPoint.x / self.playSlider.frame.size.width) * self.playSlider.maximumValue;
        
        [self seekToTime:value];
        [self updateCurrentTime:value];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.touchView];
    NSLog(@"(%f,%f)", touchPoint.x, touchPoint.y);
    
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan) {
        //触摸开始, 初始化一些值
        _hasMoved = NO;
        _controlJudge = NO;
        _touchBeginValue = self.playSlider.value;
        _touchBeginVoiceValue = _volumeSlider.value;
        _touchBeginLightValue = [UIScreen mainScreen].brightness;
        _touchBeginPoint = touchPoint;
    }
    
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateChanged) {
        
        //如果移动的距离过于小, 就判断为没有移动
        if (fabs(touchPoint.x - _touchBeginPoint.x) < LeastMoveDistance && fabs(touchPoint.y - _touchBeginPoint.y) < LeastMoveDistance) {
            return;
        }
        
        _hasMoved = YES;
        
        //如果还没有判断出是什么手势就进行判断
        if (!_controlJudge) {
            //根据滑动角度的tan值来进行判断
            float tan = fabs(touchPoint.y - _touchBeginPoint.y) / fabs(touchPoint.x - _touchBeginPoint.x);
            
            //当滑动角度小于30度的时候, 进度手势
            if (tan < 1 / sqrt(3)) {
                self.controlType = HCDPlayerControlTypeProgress;
                _controlJudge = YES;
            }
            
            //当滑动角度大于60度的时候, 声音和亮度
            else if (tan > sqrt(3)) {
                //判断是在屏幕的左半边还是右半边滑动, 左侧控制为亮度, 右侧控制音量
                if (_touchBeginPoint.x < self.touchView.frame.size.width / 2) {
                    _controlType = HCDPlayerControlTypeLight;
                }else{
                    _controlType = HCDPlayerControlTypeVoice;
                }
                _controlJudge = YES;
            } else {
                _controlType = HCDPlayerControlTypeNone;
                return;
            }
        }
        
        if (HCDPlayerControlTypeProgress == _controlType) {
            float value = [self moveProgressControllWithTempPoint:touchPoint];
            [self timeValueChangingWithValue:value];
        } else if (HCDPlayerControlTypeVoice == _controlType) {
            //根据触摸开始时的音量和触摸开始时的点去计算出现在滑动到的音量
            float voiceValue = _touchBeginVoiceValue - ((touchPoint.y - _touchBeginPoint.y) / CGRectGetHeight(self.touchView.frame));
            //判断控制一下, 不能超出 0~1
            if (voiceValue < 0) {
                self.volumeSlider.value = 0;
            }else if(voiceValue > 1){
                self.volumeSlider.value = 1;
            }else{
                self.volumeSlider.value = voiceValue;
            }
        } else if (HCDPlayerControlTypeLight == _controlType) {
            [UIScreen mainScreen].brightness -= ((touchPoint.y - _touchBeginPoint.y) / 10000);
        } else if (HCDPlayerControlTypeNone == _controlType) {
            if (self.toolView.hidden) {
                [self showToolView];
            } else {
                [self toolViewHidden];
            }
        }
        
    }
    
    if (([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateEnded) || ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateCancelled)) {
        CGFloat x = recognizer.view.center.x;
        CGFloat y = recognizer.view.center.y;
        
        NSLog(@"%lf,%lf", x, y);
        _controlJudge = NO;
        //判断是否移动过,
        if (_hasMoved) {
            if (HCDPlayerControlTypeProgress == _controlType) {
                float value = [self moveProgressControllWithTempPoint:touchPoint];
                [self seekToTime:value];
                self.timeSheetView.hidden = YES;
            }
        }
    }
}

#pragma mark - 用来控制移动过程中计算手指划过的时间
-(float)moveProgressControllWithTempPoint:(CGPoint)tempPoint{
    float tempValue = _touchBeginValue + TotalScreenTime * ((tempPoint.x - _touchBeginPoint.x) / kScreenWidth);
    if (tempValue > self.duration) {
        tempValue = self.duration;
    }else if (tempValue < 0){
        tempValue = 0.0f;
    }
    return tempValue;
}

#pragma mark - 用来显示时间的view在时间发生变化时所作的操作
-(void)timeValueChangingWithValue:(float)value{
    if (value > _touchBeginValue) {
        _timeSheetView.sheetStateImageView.image = [UIImage imageNamed:HcdImageSrcName(@"progress_icon_r")];
    }else if(value < _touchBeginValue){
        _timeSheetView.sheetStateImageView.image = [UIImage imageNamed:HcdImageSrcName(@"progress_icon_l")];
    }
    _timeSheetView.hidden = NO;
    NSString * tempTime = [NSString calculateTimeWithTimeFormatter:value];
    if (tempTime.length > 5) {
        _timeSheetView.sheetTimeLabel.text = [NSString stringWithFormat:@"00:%@/%@", tempTime, self.totalTimeLbl.text];
    }else{
        _timeSheetView.sheetTimeLabel.text = [NSString stringWithFormat:@"%@/%@", tempTime, self.totalTimeLbl.text];
    }
}

#pragma mark - 控制条隐藏

- (void)toolViewHidden {
    self.toolView.hidden = YES;
    self.statusBarBgView.hidden = YES;
    
    if (_isFullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    [_hiddenTimer invalidate];
}

#pragma mark - 控制条退出隐藏

- (void)showToolView {
    
    if (!self.repeatBtn.hidden) {
        return;
    }
    self.toolView.hidden = NO;
    
    if (_isFullScreen) {
        self.statusBarBgView.hidden = NO;
    } else {
        self.statusBarBgView.hidden = YES;
    }
    
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    if (!_hiddenTimer.valid) {
        _hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(toolViewHidden) userInfo:nil repeats:NO];
    }else{
        [_hiddenTimer invalidate];
        _hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(toolViewHidden) userInfo:nil repeats:NO];
    }
}

#pragma mark - 事件响应

//手指结束拖动，播放器从当前点开始播放，开启滑竿的时间走动
- (void)playSliderChangeEnd:(UISlider *)slider
{
    [self seekToTime:slider.value];
    [self updateCurrentTime:slider.value];
    [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause")] forState:UIControlStateNormal];
    [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause_hl")] forState:UIControlStateHighlighted];
}

//手指正在拖动，播放器继续播放，但是停止滑竿的时间走动
- (void)playSliderChange:(UISlider *)slider
{
    [self updateCurrentTime:slider.value];
}

#pragma mark - 控件拖动
- (void)setPlaySliderValue:(CGFloat)time
{
    self.playSlider.minimumValue = 0.0;
    self.playSlider.maximumValue = (NSInteger)time;
}

/**
 *  更新当前播放时间
 *
 *  @param time 但前播放时间秒数
 */
- (void)updateCurrentTime:(CGFloat)time
{
    long videocurrent = ceil(time);
    
    NSString *str = nil;
    if (videocurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videocurrent/3600.f)),lround(floor(videocurrent%3600)/60.f),lround(floor(videocurrent/1.f))%60];
    }
    
    self.currentTimeLbl.text = str;
}

/**
 *  更新所有时间
 *
 *  @param time 时间（秒）
 */
- (void)updateTotolTime:(CGFloat)time
{
    long videoLenth = ceil(time);
    NSString *strtotol = nil;
    if (videoLenth < 3600) {
        strtotol =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videoLenth/60.f)),lround(floor(videoLenth/1.f))%60];
    } else {
        strtotol =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videoLenth/3600.f)),lround(floor(videoLenth%3600)/60.f),lround(floor(videoLenth/1.f))%60];
    }
    
    self.totalTimeLbl.text = strtotol;
}

/**
 *  更新Slider
 *
 *  @param currentSecond 但前播放时间进度
 */
- (void)updateVideoSlider:(CGFloat)currentSecond {
    [self.playSlider setValue:currentSecond animated:YES];
}

/**
 *  暂停或者播放
 */
- (void)resumeOrPause
{
    if (!self.currentPlayerItem) {
        return;
    }
    if (self.state == HCDPlayerStatePlaying) {
        [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_play")] forState:UIControlStateNormal];
        [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_play_hl")] forState:UIControlStateHighlighted];
        [self.player pause];
        self.state = HCDPlayerStatePause;
    } else if (self.state == HCDPlayerStatePause) {
        self.repeatBtn.hidden = YES;
        [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause")] forState:UIControlStateNormal];
        [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause_hl")] forState:UIControlStateHighlighted];
        [self.player play];
        self.state = HCDPlayerStatePlaying;
    } else if (self.state == HCDPlayerStateFinish) {
        self.repeatBtn.hidden = YES;
        [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause")] forState:UIControlStateNormal];
        [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause_hl")] forState:UIControlStateHighlighted];
        [self seekToTime:0.0];
        self.state = HCDPlayerStatePlaying;
    }
    self.isPauseByUser = YES;
}

/**
 *  重播
 */
- (void)repeatPlay {
    [self showToolView];
    [self resumeOrPause];
}

/**
 *  重新播放
 */
- (void)resume
{
    if (!self.currentPlayerItem) {
        return;
    }
    
    [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause")] forState:UIControlStateNormal];
    [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_pause_hl")] forState:UIControlStateHighlighted];
    self.isPauseByUser = NO;
    [self.player play];
}

/**
 *  暂停播放
 */
- (void)pause
{
    if (!self.currentPlayerItem) {
        return;
    }
    [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_play")] forState:UIControlStateNormal];
    [self.stopButton setImage:[UIImage imageNamed:HcdImageSrcName(@"icon_play_hl")] forState:UIControlStateHighlighted];
    self.isPauseByUser = YES;
    self.state = HCDPlayerStatePause;
    [self.player pause];
}

/**
 *  停止播放
 */
- (void)stop
{
    self.isPauseByUser = YES;
    self.loadedProgress = 0;
    self.duration = 0;
    self.current  = 0;
    self.state = HCDPlayerStateStopped;
    [self.player pause];
    [self releasePlayer];
    self.repeatBtn.hidden = YES;
    [self toolViewHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHCDPlayerProgressChangedNotification object:nil];
}

/**
 *  计算播放进度
 *
 *  @return 播放时间进度
 */
- (CGFloat)progress
{
    if (self.duration > 0) {
        return self.current / self.duration;
    }
    
    return 0;
}

#pragma mark - private

- (void)releasePlayer {
    if (!self.currentPlayerItem) {
        return;
    }
    
    [self.player pause];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.showView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.currentPlayerItem removeObserver:self forKeyPath:HCDVideoPlayerItemStatusKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:HCDVideoPlayerItemLoadedTimeRangesKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:HCDVideoPlayerItemPlaybackBufferEmptyKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:HCDVideoPlayerItemPlaybackLikelyToKeepUpKeyPath];
    [self.currentPlayerItem removeObserver:self forKeyPath:HCDVideoPlayerItemPresentationSizeKeyPath];
    [self.player removeTimeObserver:self.playbackTimeObserver];
    self.playbackTimeObserver = nil;
    self.currentPlayerItem = nil;
    
    if (self.resouerLoader.task) {
        [self.resouerLoader.task cancel];
        self.resouerLoader.task = nil;
        self.resouerLoader = nil;
    }
    
}

#pragma mark - HCDLoaderURLConnectionDelegate

- (void)didFinishLoadingWithTask:(HcdVideoRequestTask *)task
{
    _isFinishLoad = task.isFinishLoad;
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003

- (void)didFailLoadingWithTask:(HcdVideoRequestTask *)task withError:(NSInteger )errorCode
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
    
    NSLog(@"%@", str);
    //    [XCHudHelper showMessage:str];
    
}

#pragma mark - 通知中心检测到屏幕旋转
-(void)orientationChanged:(NSNotification *)notification{
    [self updateOrientation];
}

- (void)updateOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            [self toOrientation:UIInterfaceOrientationPortrait];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        case UIDeviceOrientationLandscapeRight:
//            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
//            [self toOrientation:UIInterfaceOrientationPortraitUpsideDown];
            break;
        default:
            break;
    }
}

#pragma mark - 全屏旋转处理

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    
    if (!_canFullScreen) {
        return;
    }
    
    //    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (_currentOrientation == orientation) {
        return;
    }
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self.showView removeFromSuperview];
        [self.playerSuperView addSubview:self.showView];
        
//        HcdLightView *lightView = [HcdLightView sharedInstance];
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:lightView];
        __weak HcdCacheVideoPlayer * weakSelf = self;
        [self.showView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetMinY(weakSelf.showViewRect));
            make.left.mas_equalTo(CGRectGetMinX(weakSelf.showViewRect));
            make.width.mas_equalTo(CGRectGetWidth(weakSelf.showViewRect));
            make.height.mas_equalTo(CGRectGetHeight(weakSelf.showViewRect));
        }];
        
//        [lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo([UIApplication sharedApplication].keyWindow);
//            make.centerY.equalTo([UIApplication sharedApplication].keyWindow).offset(-5);
//            make.width.mas_equalTo(155);
//            make.height.mas_equalTo(155);
//        }];
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self.showView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
        
        // 亮度view加到window最上层
//        HcdLightView *lightView = [HcdLightView sharedInstance];
//        [[UIApplication sharedApplication].keyWindow insertSubview:self.showView belowSubview:lightView];
        
        [self.showView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenHeight));
            make.height.equalTo(@(kScreenWidth));
            make.center.equalTo([[UIApplication sharedApplication].delegate window]);
        }];
        
//        [lightView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo([UIApplication sharedApplication].keyWindow);
//            make.centerY.equalTo([UIApplication sharedApplication].keyWindow);
//            make.width.mas_equalTo(155);
//            make.height.mas_equalTo(155);
//        }];
    }
    
    _currentOrientation = orientation;
    
    //
    //    [UIView beginAnimations:nil context:nil];
    //
    //    [UIView setAnimationDuration:0.5];
    //    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        [[UIApplication sharedApplication] setStatusBarOrientation:_currentOrientation animated:YES];
        //旋转视频播放的view和显示亮度的view
        self.showView.transform = [self getOrientation:orientation];
//        [HcdLightView sharedInstance].transform = [self getOrientation:orientation];
    } completion:^(BOOL finished) {
        
    }];
}

//根据状态条旋转的方向来旋转 avplayerView
-(CGAffineTransform)getOrientation:(UIInterfaceOrientation)orientation{
    //    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        [self toPortraitUpdate];
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        [self toLandscapeUpdate];
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        [self toLandscapeUpdate];
        return CGAffineTransformMakeRotation(M_PI_2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self toPortraitUpdate];
        return CGAffineTransformMakeRotation(M_PI);
    }
    return CGAffineTransformIdentity;
}

-(void)toPortraitUpdate{
    _isFullScreen = NO;
    self.toolView.hidden = YES;
    //处理状态条
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

-(void)toLandscapeUpdate{
    _isFullScreen = YES;
    
    //处理状态条
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (self.toolView.hidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

- (void)dealloc
{
    [self releasePlayer];
}

@end
