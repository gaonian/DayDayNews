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
//  HcdAudioPlayer.h
//  hcdCachePlayerDemo
//
//  播放的网络音频文件缓存为caf格式的文件
//
//  Created by polesapp-hcd on 16/7/1.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>//需要添加AVFoundation.framework

typedef NS_ENUM (NSUInteger, HCDAudioFileType) {
    HCDAudioFileType_Network = 0,
    HCDAudioFileType_Local,
};

@protocol HcdAudioPlayerDelegate <NSObject>

@optional

/**
 *  开始播放
 *
 *  @param audioPlayer 音频播放器
 */
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer *)audioPlayer;

/**
 *  停止播放
 *
 *  @param audioPlayer 音频播放器
 */
- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer;

/**
 *  暂停播放
 *
 *  @param audioPlayer 音频播放器
 */
- (void)didAudioPlayerPausePlay:(AVAudioPlayer *)audioPlayer;

/**
 *  播放完成
 *
 *  @param audioPlayer 音频播放器
 */
- (void)didAudioPlayerFinishPlay:(AVAudioPlayer *)audioPlayer;

@end

@interface HcdAudioPlayer : NSObject<AVAudioPlayerDelegate>

+ (HcdAudioPlayer *)sharedInstance;

@property (nonatomic, assign) BOOL                  stopBool;
@property (nonatomic, strong) AVAudioPlayer         *audioPlayer;
@property (nonatomic, copy  ) NSString              *pathName;
@property (nonatomic, assign) BOOL                  isRepeat;//是否重复播放

//声明协议代理
@property (nonatomic, retain) id<HcdAudioPlayerDelegate> delegate;

/**
 *  播放网络上的音频文件
 *
 *  @param urlPath   音频网络地址
 *  @param isPlaying 是否播放
 */
- (void)manageAudioWithUrlPath:(NSString *)urlPath
                   playOrPause:(BOOL)isPlaying;

/**
 *  播放本地的音频文件
 *
 *  @param localPath 本地音频文件
 *  @param isPlaying 是否播放
 */
- (void)manageAudioWithLocalPath:(NSString *)localPath
                     playOrPause:(BOOL)isPlaying;

/**
 *  暂停播放
 */
- (void)pausePlayingAudio;

/**
 *  停止播放
 */
- (void)stopAudio;

/**
 *  静音
 */
- (void)noVoice;

/**
 *  重置音量
 */
- (void)resetVoice;

@end
