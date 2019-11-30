//
//  CollectModel.h
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

/**
 *  新闻标题
 */
@property (nonatomic , copy) NSString * title;

/**
 *  新闻ID
 */
@property (nonatomic , copy) NSString * docid;

/**
 *  收藏的时间
 */
@property (nonatomic , copy) NSString * time;

@end
