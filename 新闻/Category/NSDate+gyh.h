//
//  NSDate+gyh.h
//  微博
//
//  Created by gyh on 15-4-18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (gyh)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

-(NSDate *)dateWithYMD;


@end
