//
//  PhotoCollectModel.h
//  新闻
//
//  Created by gyh on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCollectModel : NSObject
/**
 *  图片标题
 */
@property (nonatomic , copy) NSString * title;
/**
 *  图片url
 */
@property (nonatomic , copy) NSString * image_url;
/**
 *  图片宽度
 */
@property (nonatomic , assign) CGFloat  image_width;
/**
 *  图片高度
 */
@property (nonatomic , assign) CGFloat  image_height;
/**
 *  收藏时间
 */
@property (nonatomic , copy) NSString * time;

@end
