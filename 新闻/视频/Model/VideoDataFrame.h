//
//  VideoDataFrame.h
//  新闻
//
//  Created by gyh on 15/9/25.
//  assignright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VideoData;
@interface VideoDataFrame : NSObject
@property (nonatomic , strong)VideoData *videodata;

/**
 *  题目
 */
@property (nonatomic , assign) CGRect titleF;
/**
 *  描述
 */
@property (nonatomic , assign) CGRect DescriptionF;
/**
 *  播放图标
 */
@property (nonatomic , assign) CGRect playF;
/**
 *  图片
 */
@property (nonatomic , assign) CGRect coverF;
/**
 *  时长图标
 */
@property (nonatomic , assign) CGRect lengtImageF;
/**
 *  时长
 */
@property (nonatomic , assign) CGRect lengthF;
/**
 *  播放数图标
 */
@property (nonatomic , assign) CGRect playImageF;
/**
 *  播放数
 */
@property (nonatomic , assign) CGRect playCountF;
/**
 *  时间
 */
@property (nonatomic , assign) CGRect ptimeF;

@property (nonatomic , assign) CGRect lineVF;

@property (nonatomic , assign) CGFloat cellH;


@end
