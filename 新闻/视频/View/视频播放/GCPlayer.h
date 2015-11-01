//
//  GCPlayer.h
//  封装AVPlayer
//
//  Created by 高超 on 15/6/17.
//  Copyright (c) 2015年 高超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SingleTon.h"
@interface GCPlayer : UIView


@property(nonatomic,strong)AVPlayerItem * playItem;
@property(nonatomic,strong)AVPlayer * playerr;
@property(nonatomic,strong)UIProgressView * videoProgress;//缓存条
@property(nonatomic,strong)UISlider *videoSlider;//当前进度条

@property(nonatomic,strong)UILabel * timeLabel;//当前时间/总时间
SingleTonH(Player)

-(void)getPlayItem:(NSString *)url;




@end
