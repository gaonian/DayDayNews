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
//  HcdAudioPlayer.m
//  hcdCachePlayerDemo
//
//  Created by polesapp-hcd on 16/7/1.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdAudioPlayer.h"
#import <UIKit/UIKit.h>

@implementation HcdAudioPlayer

+ (HcdAudioPlayer *)sharedInstance {
    static HcdAudioPlayer *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HcdAudioPlayer alloc]init];
    });
    
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self changeProximityMonitorEnableState:NO];
    }
    return self;
}

- (void)dealloc {
    [self changeProximityMonitorEnableState:NO];
}

#pragma mark - 近距离传感器

- (void)changeProximityMonitorEnableState:(BOOL)enable {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        if (enable) {
            //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
        } else {
            //删除近距离事件监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

/**
 *  传感器状态改变时，接受到通知响应方法
 *
 *  @param notification 通知中心
 */
- (void)sensorStateChange:(NSNotificationCenter *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //黑屏 NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    } else {
        //没黑屏幕  NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_audioPlayer || !_audioPlayer.isPlaying) {
            //没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

- (void)manageAudioWithUrlPath:(NSString *)urlPath playOrPause:(BOOL)isPlaying {
    
    //这里自己写需要保存数据的路径
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@", dirPath, [urlPath lastPathComponent]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        if (isPlaying) {
            [self playAudioWithPath:cachePath whiteType:HCDAudioFileType_Local];
        } else {
            [self pausePlayingAudio];
        }
    } else {
        if (isPlaying) {
            [self playAudioWithPath:urlPath whiteType:HCDAudioFileType_Network];
        } else {
            [self pausePlayingAudio];
        }
    }
}

- (void)manageAudioWithLocalPath:(NSString *)localPath playOrPause:(BOOL)isPlaying {
    if (isPlaying) {
        [self playAudioWithPath:localPath whiteType:HCDAudioFileType_Local];
    } else {
        [self pausePlayingAudio];
    }
}

- (void)pausePlayingAudio {
    if (_audioPlayer) {
        [_audioPlayer pause];
        if ([self.delegate respondsToSelector:@selector(didAudioPlayerPausePlay:)]) {
            [self.delegate didAudioPlayerPausePlay:_audioPlayer];
        }
    }
}

- (void)resetVoice {
    _audioPlayer.volume = 0.4;
}

- (void)noVoice {
    _audioPlayer.volume = 0.0;
}

- (void)stopAudio {
    self.pathName = @"";
    if (_audioPlayer && _audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(didAudioPlayerStopPlay:)]) {
        [self.delegate didAudioPlayerStopPlay:_audioPlayer];
    }
}

#pragma mark - AVAudioPlayer播放结束代理方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(flag){
        
        if (_isRepeat) {
            _stopBool = NO;
            [self playAudio];
            return;
        }
        
        //响应播放结束方法
        if ([self.delegate respondsToSelector:@selector(didAudioPlayerFinishPlay:)]) {
            [self.delegate didAudioPlayerFinishPlay:_audioPlayer];
        }
    }
}

#pragma mark - Setter Getter方法

- (AVAudioPlayer *)getAudioPlayer:(NSString *)path witeType:(HCDAudioFileType)type {
    NSURL *fileUrl;
    
    switch (type) {
        case HCDAudioFileType_Network: {
            NSURL *url = [[NSURL alloc]initWithString:path];
            NSData *audioData = [NSData dataWithContentsOfURL:url];
            
            NSString *fileName = [path lastPathComponent];
            
            //将数据保存在本地指定位置Cache中
            NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, fileName];
            [audioData writeToFile:filePath atomically:YES];
            
            fileUrl = [NSURL fileURLWithPath:filePath];
        }
            break;
        case HCDAudioFileType_Local: {
            fileUrl = [NSURL fileURLWithPath:path];
        }
            break;
        default: {
            fileUrl = [NSURL fileURLWithPath:path];
        }
            break;
    }
    
    //初始化播放器并播放
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    player.delegate = self;
    [player prepareToPlay];
    if(error){
        NSLog(@"file error %@",error.description);
    }
    return player;
}

#pragma mark - private

- (void)playAudioWithPath:(NSString *)path whiteType:(HCDAudioFileType)type {
    if (path && path.length > 0) {
        //不随着静音键和屏幕关闭而静音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //上次播放的录音
        if (_pathName && [path isEqualToString:_pathName]) {
            if (_audioPlayer.isPlaying) {
                [self pausePlayingAudio];
            } else {
                [self playAudio];
            }
        } else {
            _pathName = path;
            
            if (_audioPlayer) {
                [_audioPlayer stop];
                _audioPlayer = nil;
            }
            
            //初始化播放器
            self.audioPlayer = [self getAudioPlayer:path witeType:type];
            self.audioPlayer.volume = 0.4;
            [self playAudio];
        }
    }
}

- (void)playAudio {
    if (_audioPlayer) {
        if (_stopBool == YES) {
            [_audioPlayer stop];
            self.audioPlayer = nil;
            
        } else {
            [_audioPlayer play];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
                [self.delegate didAudioPlayerBeginPlay:_audioPlayer];
            }
        }
    }
}

@end
