//
//  VideoDataFrame.m
//  新闻
//
//  Created by gyh on 15/9/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#define padding 5
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "VideoDataFrame.h"

@implementation VideoDataFrame

-(void)setVideodata:(VideoData *)videodata
{
    _videodata = videodata;
    
    //题目
    CGFloat titleX = padding;
    CGFloat titleY = padding * 2;
    CGFloat titleW = SCREEN_WIDTH;
    CGFloat titleH = 20;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    //描述
//    CGFloat descriX = padding;
//    CGFloat descriY = CGRectGetMaxY(_titleF) + 5;
//    CGFloat descriW = SCREEN_WIDTH;
//    CGFloat descriH = 20;
//    _DescriptionF = CGRectMake(descriX, descriY, descriW, descriH);
    
    //图片
    CGFloat coverX = 0;
    CGFloat coverY = CGRectGetMaxY(_titleF) + 10;
    CGFloat coverW = SCREEN_WIDTH;
    CGFloat coverH = coverW * 0.56;
    _coverF = CGRectMake(coverX, coverY, coverW, coverH);

    CGFloat playW = 60;
    CGFloat playH = 60;
    CGFloat playX = coverW/2 - 30;
    CGFloat playY = coverH/2;
    _playF = CGRectMake(playX, playY, playW, playH);
    
    
    //时长
    CGFloat lengImagX = padding;
    CGFloat lengImagY = CGRectGetMaxY(_coverF) + 10;
    CGFloat lengImagW = 20;
    CGFloat lengImagH = 20;
    _lengtImageF = CGRectMake(lengImagX, lengImagY, lengImagW, lengImagH);

    CGFloat lengthX = CGRectGetMaxX(_lengtImageF);
    CGFloat lengthY = CGRectGetMaxY(_coverF) + 10;
    CGFloat lengthW = 40;
    CGFloat lengthH = 20;
    _lengthF = CGRectMake(lengthX, lengthY, lengthW, lengthH);
    
    
    //播放数
    CGFloat playImageX = CGRectGetMaxX(_lengthF) + 10;
    CGFloat playImageY = lengImagY;
    CGFloat playImageW = 20;
    CGFloat playImageH = 20;
    _playImageF = CGRectMake(playImageX, playImageY, playImageW, playImageH);

    CGFloat playcountX = CGRectGetMaxX(_playImageF);
    CGFloat playcountY = lengthY;
    CGFloat playcountW = 40;
    CGFloat playcountH = 20;
    _playCountF = CGRectMake(playcountX, playcountY, playcountW, playcountH);
    
    //时间
    CGFloat ptimeW = 45;
    CGFloat ptimeH = 20;
    CGFloat ptimeX = SCREEN_WIDTH - ptimeW - padding;
    CGFloat ptimeY = lengthY;
    _ptimeF = CGRectMake(ptimeX, ptimeY, ptimeW, ptimeH);
    
    //灰块
    CGFloat lineW = SCREEN_WIDTH;
    CGFloat lineH = 10;
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(_ptimeF)+10;
    _lineVF = CGRectMake(lineX, lineY, lineW, lineH);
    
    _cellH = CGRectGetMaxY(_lineVF);
}

@end
