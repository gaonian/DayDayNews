//
//  DataBase.h
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

/**
 *  添加数据到数据库
 */
+ (void)addNews:(NSString *)title docid:(NSString *)docid time:(NSString *)time;

/**
 *  调用数据库数据
 *
 *  @return 返回一个数组  数组内包装的是模型
 */
+ (NSMutableArray *)display;


/**
 *  删除单条数据
 */
+ (void)deletetable:(NSString *)docid;

/**
 *  删表
 */
+ (void)deletetable;

/**
 *  查询是否数据库已收藏
 */
+ (NSString *)queryWithCollect:(NSString *)docid;
@end
