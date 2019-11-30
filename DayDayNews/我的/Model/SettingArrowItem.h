//
//  SettingArrowItem.h
//  新闻
//
//  Created by gyh on 15-4-11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingItem.h"

@interface SettingArrowItem : SettingItem
//要跳转的视图
@property(nonatomic,assign)Class VcClass;

/**
 *  普通的箭头
 */
+(instancetype)itemWithItem:(NSString *)icon title:(NSString *)title VcClass:(Class)VcClass;

/**
 *  带描述信息
 */
+(instancetype)itemWithItem:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle VcClass:(Class)VcClass;
@end
