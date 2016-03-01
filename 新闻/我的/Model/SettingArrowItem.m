//
//  SettingArrowItem.m
//  新闻
//
//  Created by gyh on 15-4-11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingArrowItem.h"

@implementation SettingArrowItem

+(instancetype)itemWithItem:(NSString *)icon title:(NSString *)title VcClass:(Class)VcClass
{
    SettingArrowItem *item = [self itemWithItem:icon title:title];
    
    item.VcClass = VcClass;
    
    return item;
}
@end
