//
//  AppConfig.m
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (void)saveProAndCityInfoWithPro:(NSString *)pro city:(NSString *)city
{
    [[NSUserDefaults standardUserDefaults] setObject:pro forKey:@"kProvice"];
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"kCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getProInfo
{
    NSString *provice = [[NSUserDefaults standardUserDefaults] objectForKey:@"kProvice"];
    return provice;
}
+ (NSString *)getCityInfo
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCity"];
    return city;
}


@end
