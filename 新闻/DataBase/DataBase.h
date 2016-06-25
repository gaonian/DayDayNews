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
 *  添加新闻数据到数据库
 */
+ (void)addNews:(NSString *)title docid:(NSString *)docid time:(NSString *)time;

/**
 *  添加图片数据到数据库
 */
+ (void)addPhotosWithTitle:(NSString *)title image_url:(NSString *)image_url image_width:(NSString *)image_width image_height:(NSString *)image_height time:(NSString *)time;

/**
 *  调用数据库数据
 *
 *  @return 返回一个数组  数组内包装的是模型
 */
+ (NSMutableArray *)display;

/**
 *  调用收藏的图片的数据库数据
 *
 *  @return 返回一个数组  数组内包装的是图片的模型
 */
+ (NSMutableArray *)basePhotoDisplay;

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


/**
 *  查询数据库是否收藏对应的图片
 *
 *  @param photourl 图片的url  根据图片的url判断
 */
+ (NSString *)queryWithCollectPhoto:(NSString *)photourl;

/**
 *  删除图片收藏的某一条数据
 *
 *  @param photourl 传入图片的url
 */
+ (void)deletetableWithPhoto:(NSString *)photourl;
@end
