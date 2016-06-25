//
//  VideoData.h
//  新闻
//
//  Created by gyh on 15/9/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoData : NSObject

/**
 *  题目
 */
@property (nonatomic , copy) NSString * title;
/**
 *  描述
 */
@property (nonatomic , copy) NSString * Description;
/**
 *  图片
 */
@property (nonatomic , copy) NSString * cover;
/**
 *  时长
 */
@property (nonatomic , assign) CGFloat length;
/**
 *  播放数
 */
@property (nonatomic , copy) NSString * playCount;
/**
 *  时间
 */
@property (nonatomic , copy) NSString * ptime;
/**
 *  视频地址
 */
@property (nonatomic , copy) NSString * mp4_url;

@end
