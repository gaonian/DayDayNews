//
//  ShareSDK+Extension.h
//  ShareSDKExtension
//
//  Created by fenghj on 15/7/28.
//  Copyright (c) 2015年 mob. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>

/**
 *  ShareSDK扩展类目
 */
@interface ShareSDK (Extension)

/**
 *  是否安装客户端（支持平台：微博、微信、QQ、QZone、Facebook）
 *
 *  @param platformType 平台类型
 *
 *  @return YES 已安装，NO 尚未安装
 */
+ (BOOL)isClientInstalled:(SSDKPlatformType)platformType;

/**
 *  根据API接口返回的原始数据来创建用户对象
 *
 *  @param rawData 原始数据
 *  @param platformType 平台类型
 *
 *  @return 用户信息对象
 */
+ (SSDKUser *)userByRawData:(NSDictionary *)rawData forPlatformType:(SSDKPlatformType)platformType;

@end
