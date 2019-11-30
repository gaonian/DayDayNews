//
//  AppConfig.h
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+ (instancetype)sharedInstance;

+ (void)saveProAndCityInfoWithPro:(NSString *)pro city:(NSString *)city;
+ (NSString *)getProInfo;
+ (NSString *)getCityInfo;

@end
