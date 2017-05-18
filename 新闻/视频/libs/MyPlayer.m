//
//  MyPlayer.m
//  TBPlayer
//
//  Created by SL on 18/05/2017.
//  Copyright © 2017 SF. All rights reserved.
//

#import "MyPlayer.h"
#import "TBloaderURLConnection.h"
#import "TBVideoRequestTask.h"

@interface MyPlayer ()<TBloaderURLConnectionDelegate>
@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVAsset        *videoAsset;
@property (nonatomic, strong) TBloaderURLConnection *resouerLoader;

@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) AVPlayerLayer  *currentPlayerLayer;

@property (nonatomic, strong) NSURL *mp4URL;

@end

@implementation MyPlayer

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id _sInstance;
    dispatch_once(&onceToken, ^{
        _sInstance = [[self alloc] init];
    });
    
    return _sInstance;
}

//流媒体同步播放缓存
- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView
{
    self.mp4URL = url;
    
    NSString *str = [url absoluteString];
    if (![str hasPrefix:@"http"]) {
        self.videoAsset  = [AVURLAsset URLAssetWithURL:url options:nil];
        self.currentPlayerItem          = [AVPlayerItem playerItemWithAsset:_videoAsset];
    } else {
        self.resouerLoader          = [[TBloaderURLConnection alloc] init];
        self.resouerLoader.delegate = self;
        
        NSURL *playUrl              = [self.resouerLoader getSchemeVideoURL:url];
        self.videoURLAsset             = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        [self.videoURLAsset.resourceLoader setDelegate:self.resouerLoader queue:dispatch_get_main_queue()];
        
        self.currentPlayerItem          = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    }
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    }
    
    self.currentPlayerLayer       = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.currentPlayerLayer.frame = showView.bounds;
    
    /*
     如果视频还没准备好播放，你就把AVPlayerLayer图层添加到cell上，那么在播放器还没有准备好播放之前，负责显示的图像的图层会变成黑色，直到准备好播放，拿到数据，才会出现画面。这在列表中自动播放是应该极力避免的。所以，要等待播放器有图像输出的时候再添加显示的预览图层到cell上。
     */
    [showView.layer addSublayer:self.currentPlayerLayer];
    
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            [self.player play];

        } else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
            [self.player pause];
        }
        
    }
}

#pragma mark - TBloaderURLConnectionDelegate

- (void)didFinishLoadingWithTask:(TBVideoRequestTask *)task
{
    NSLog(@"%s",__func__);
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
    NSLog(@"%s: %@",__func__ , str);
}


@end
