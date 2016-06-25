//
//  SettingItem.h
//  新闻
//
//  Created by gyh on 15-4-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SettingItemOption)();

@interface SettingItem : NSObject
//图标
@property(nonatomic,copy)NSString *icon;
//标题
@property(nonatomic,copy)NSString *title;
//
@property(nonatomic,copy)NSString *subtitle;

@property(nonatomic,copy)SettingItemOption option;

+ (instancetype)itemWithItem:(NSString *)icon title:(NSString *)title;

+ (instancetype)itemWithItem:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle;

@end
