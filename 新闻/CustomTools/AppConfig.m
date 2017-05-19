//
//  AppConfig.m
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppConfig.h"
#import <CommonCrypto/CommonDigest.h>

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


+ (NSString *) md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}

@end
