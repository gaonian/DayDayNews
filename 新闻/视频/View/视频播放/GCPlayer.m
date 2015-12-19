//
//  GCPlayer.m
//  封装AVPlayer
//
//  Created by 高超 on 15/6/17.
//  Copyright (c) 2015年 高超. All rights reserved.
//

#import "GCPlayer.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface GCPlayer ()
{
    BOOL  Tap;//记录隐藏操作栏
    BOOL  Play;//记录播放Btn
    NSString * _totalTime;//转换后的播放时间
     NSDateFormatter * _dateFormatter;//播放时间/总时间
    long _oldDirection;//旧方向
    long _currentDirection;//当前方向
    CGFloat hight;//记录竖屏高
}


@property(nonatomic,strong)UIImageView * playView;//操作栏
@property (nonatomic ,strong) id playbackTimeObserver;//监听播放状态
@property(nonatomic,strong)UIButton * playBtn;//播放/暂停

@property(nonatomic,assign)CGRect fremm;
@end


@implementation GCPlayer
SingleTonM(Player)
  //操作栏
-(UIImageView *)playView
{
    if (_playView==nil) {
        _playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50,self.frame.size.width, 50)];
    }
    
    return _playView;
}
 //播放/暂停
-(UIButton *)playBtn
{
    if (_playBtn ==nil) {
        _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    
    return _playBtn;
}
//缓存条
-(UIProgressView *)videoProgress
{
    if (_videoProgress ==nil) {
        _videoProgress  = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 48, self.playView.frame.size.width, 1)];
    }
    
    return _videoProgress;
}
 //当前进度条
-(UISlider *)videoSlider
{
    if (_videoSlider==nil) {
        _videoSlider = [[UISlider alloc]initWithFrame:CGRectMake(55, 15, self.playView.frame.size.width-60, 10)];
    }
    
    return _videoSlider;
}

 //当前时间/总时间
-(UILabel *)timeLabel
{
    if (_timeLabel ==nil) {
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 30, 70, 20)];
        self.timeLabel.text = @"00:00/00:00";
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
    }
    
    return _timeLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _fremm = frame;
        //操作栏
        self.playView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        self.playView.userInteractionEnabled = YES;
        [self addSubview:self.playView];
        //播放/暂停
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.playView addSubview:self.playBtn];
        //缓存条
        self.videoProgress.backgroundColor = [UIColor redColor];
        [self.playView addSubview:self.videoProgress];
        
        //当前进度条
         [self.playView addSubview:self.videoSlider];
        [self.videoSlider addTarget:self action:@selector(videoSlierChangeValue:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoSlider addTarget:self action:@selector(videoSlierChangeValueEnd:) forControlEvents:UIControlEventTouchUpInside];
        //自定义进度条滑块
        UIImage * imge =[UIImage imageNamed:@"huakuai"];
        [_videoSlider setThumbImage:imge forState:UIControlStateHighlighted];
        [_videoSlider setThumbImage:imge forState:UIControlStateNormal];
        
        
        //当前时间/总时间
        [self.playView addSubview:self.timeLabel];
        
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
        
        //屏幕旋转通知，改变Frem
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transContro:) name:UIDeviceOrientationDidChangeNotification object:nil];
           hight = self.frame.size.height;
        
           }
     
    
    
    return self;
}




//判断Play or stop
-(void)playBtnTouched
{
    if (!Play) {
        
        [self.player play];
        [self.playBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    }else{
        
        [self.player pause];
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    
    
    Play = !Play;
}

//判断隐藏操作栏方法
-(void)tap
{
    if (!Tap) {
        self.playView.hidden = NO;
        
    }else{
        self.playView.hidden = YES;
        
    }
    
    
    Tap = !Tap;
}

#pragma mark - 私有方法

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
-(void)getPlayItem:(NSString *)url
{
    NSURL * videoUrl = [NSURL URLWithString:url];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    
    [self listener:playerItem];
    [self playEnd:playerItem];
    self.playItem =playerItem;
    self.playerr = [AVPlayer playerWithPlayerItem:playerItem];
    self.player = _playerr;
     Play = !Play;
    [self.player play];
    [self.playBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
   
}

//给AVPlayerItem添加监听者
-(void)listener:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性
    
    
    
}


//播放完毕执行方法
-(void)playEnd:(AVPlayerItem *)playerItem
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
}

//当前进度条方法
- (void)videoSlierChangeValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value change:%.1f",slider.value);
    
    if (slider.value == 0.000000) {
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.player play];
        }];
    }
}

//当前进度条方法
- (void)videoSlierChangeValueEnd:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value end:%.1f",slider.value);
    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:changedTime completionHandler:^(BOOL finished) {
        [weakSelf.player play];
        [weakSelf.playBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    }];
}


//添加监视者后，播放完毕执行方法
- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.videoSlider setValue:0.0 animated:YES];
        [weakSelf.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            self.playBtn.enabled = YES;
            CMTime duration = self.playItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
          _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            [self customVideoSlider:duration];// 自定义UISlider外观
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        
        CMTime duration = self.playItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self monitoringPlayback:self.playItem];// 监听播放状态
        
        [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    }
}

//计算缓存进度方法
- (NSTimeInterval)availableDuration {

        NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
        return result;
}

//监听播放状态执行方法
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    static BOOL hasAddOb = NO;
    
    if (!hasAddOb) {
        _playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
            CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
//            NSLog(@"%.2f  ==  %@",currentSecond,playerItem);
            
            
            [weakSelf.videoSlider setValue:currentSecond animated:YES];
            
            NSString *timeString = [self convertTime:currentSecond];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,_totalTime];
        }];
        //        hasAddOb = !hasAddOb;
    }
    
}

//当前时间和总时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    
    NSString *showtimeNew = [_dateFormatter stringFromDate:d];
    return showtimeNew;
}
//dateFormatter懒加载 开辟空间
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

//自定义UISlider外观
- (void)customVideoSlider:(CMTime)duration {

    if (self.videoSlider.maximumValue > self.videoSlider.minimumValue) {
        self.videoSlider.maximumValue = CMTimeGetSeconds(duration);
        UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
        
        UIImage * tiao = [UIImage imageNamed:@"tiao"];
        
        UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
        [_videoSlider setMinimumTrackImage:tiao forState:UIControlStateNormal ];
    }
   
}




+(Class)layerClass
{
    return [AVPlayerLayer class];
    
}

-(AVPlayer *)player
{
    
    return [(AVPlayerLayer *)[self layer]player];
}

-(void)setPlayer:(AVPlayer *)player
{
    
    [(AVPlayerLayer *)[self layer]setPlayer:player];
    
}


#pragma mark 屏幕旋转
- (void)transContro:(NSNotification *)notification
{
    
    _currentDirection = [[UIDevice currentDevice] orientation];
    //
    if (_oldDirection != _currentDirection) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
             //当右边旋转时改变本视图大小
                self.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
               
                //改变操作栏大小
                self.playView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
                //当前播放条改变位置
                self.videoSlider.frame =CGRectMake(0, 0, self.playView.frame.size.width, 1);
                //改变缓存条
                self.videoProgress.frame = CGRectMake(0, 48, self.playView.frame.size.width, 1);
                //显示操作栏
                self.playView.hidden = NO;
         
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
                //当左边旋转时改变本视图大小
                self.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
              
                //改变操作栏大小
                self.playView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
                //当前播放条改变位置
                self.videoSlider.frame =CGRectMake(0, 0, self.playView.frame.size.width, 1);
                //改变缓存条
                self.videoProgress.frame = CGRectMake(0, 48, self.playView.frame.size.width, 1);
                //显示操作栏
                self.playView.hidden = NO;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
                 //当恢复竖屏时改变本视图大小
                self.frame =_fremm;
                //改变操作栏大小
                self.playView.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50);
                 //当前播放条改变位置
                self.videoSlider.frame =CGRectMake(55, 15, self.playView.frame.size.width-60, 10);
                //改变缓存条
                self.videoProgress.frame = CGRectMake(0, 48, self.playView.frame.size.width, 1);
                
            }
        } completion:^(BOOL finished) {
            nil;
        }];
        
    }
}



@end
