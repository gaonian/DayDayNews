//
//  SettingItem.m
//  新闻
//
//  Created by gyh on 15-4-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem


+ (instancetype)itemWithItem:(NSString *)icon title:(NSString *)title
{
    SettingItem *item = [[self alloc]init];
    item.icon = icon;
    item.title = title;
    
    return item;
}

+ (instancetype)itemWithItem:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle
{
    SettingItem *item = [[self alloc]init];
    item.icon = icon;
    item.title = title;
    item.subtitle = subtitle;
    return item;
}
@end
