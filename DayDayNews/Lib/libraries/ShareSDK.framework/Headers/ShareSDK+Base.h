//
//  ShareSDK+Base.h
//  ShareSDK
//
//  Created by 冯 鸿杰 on 15/2/6.
//  Copyright (c) 2015年 掌淘科技. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "ISSDKAuthView.h"

/**
 *  ShareSDK基础APIs
 */
@interface ShareSDK (Base)

/**
 *  获取SDK版本
 *
 *  @return 版本号
 */
+ (NSString *)sdkVer;

/**
 *  获取激活的平台列表
 *
 *  @return 平台列表
 */
+ (NSArray *)activePlatforms;

/**
 *  检测平台是否支持授权
 *
 *  @param platformType 平台类型
 *
 *  @return YES 支持，NO 不支持
 */
+ (BOOL)isSupportAuth:(SSDKPlatformType)platformType;

/**
 *  获取当前授权用户
 *
 *  @param platformType 平台类型
 *
 *  @return 用户信息
 */
+ (SSDKUser *)currentUser:(SSDKPlatformType)platformType;

/**
 *  设置当前授权用户
 *
 *  @param user         用户信息
 *  @param platformType 平台类型
 */
+ (void)setCurrentUser:(SSDKUser *)user forPlatformType:(SSDKPlatformType)platformType;

/**
 *  分享平台授权
 *
 *  @param platformType         平台类型
 *  @param settings             授权设置
 *  @param viewDisplayHandler   授权视图显示回调处理，当授权时需要在应用中显示授权时触发此回调（即SSO授权此回调不触发）
 *  @param stateChangeHandler   授权状态变更回调处理
 */
+ (void)authorize:(SSDKPlatformType)platformType
         settings:(NSDictionary *)settings
    onViewDisplay:(SSDKAuthorizeViewDisplayHandler)viewDisplayHandler
   onStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler;

/**
 *  获取授权用户信息
 *
 *  @param platformType         平台类型
 *  @param conditional          查询条件
 *  @param authorizeHandler     授权处理器
 *  @param stateChangeHandler   状态变更回调处理
 */
+ (void)getUserInfo:(SSDKPlatformType)platformType
        conditional:(SSDKUserQueryConditional *)conditional
        onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
      onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;

/**
 *  添加好友
 *
 *  @param platformType         平台类型
 *  @param user                 需要加为好友的用户信息
 *  @param authorizeHandler     授权处理器
 *  @param viewDisplayHandler   视图显示处理器
 *  @param stateChangedHandler  状态变更回调处理器
 */
+ (void)addFriend:(SSDKPlatformType)platformType
             user:(SSDKUser *)user
      onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
    onViewDisplay:(SSDKAddFriendViewDisplayHandler)viewDisplayHandler
   onStateChanged:(SSDKAddFriendStateChangedHandler)stateChangedHandler;

/**
 *  获取好友列表
 *
 *  @param platformType       平台类型
 *  @param cursor             分页游标
 *  @param size               分页大小
 *  @param authorizeHandler   授权处理器
 *  @param stateChangeHandler 状态变更回调处理
 */
+ (void)getFriends:(SSDKPlatformType)platformType
            cursor:(NSUInteger)cursor
              size:(NSUInteger)size
       onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
    onStateChanged:(SSDKGetFriendsStateChangedHandler)stateChangedHandler;

/**
 *  分享内容
 *
 *  @param platformType             平台类型
 *  @param parameters               分享参数
 *  @param authorizeHandler   授权处理器
 *  @param stateChangedHandler       状态变更回调处理
 */
+ (void)share:(SSDKPlatformType)platformType
   parameters:(NSMutableDictionary *)parameters
  onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler;

/**
 *  调用分享平台API
 *
 *  @param type                平台类型
 *  @param url                 接口请求地址
 *  @param method              请求方式：GET/POST/DELETE
 *  @param parameters          请求参数
 *  @param authorizeHandler    授权处理器
 *  @param stateChangedHandler 状态变更回调处理
 */
+ (void)callApi:(SSDKPlatformType)type
            url:(NSString *)url
         method:(NSString *)method
     parameters:(NSMutableDictionary *)parameters
    onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
 onStateChanged:(SSDKCallApiStateChangedHandler)stateChangedHandler;

/**
 *  调用分享平台API
 *
 *  @since v3.1.4
 *
 *  @param type                平台类型
 *  @param url                 接口请求地址
 *  @param method              请求方式：GET/POST/DELETE
 *  @param parameters          请求参数
 *  @param headers             请求头
 *  @param authorizeHandler    授权处理器
 *  @param stateChangedHandler 状态变更回调处理
 */
+ (void)callApi:(SSDKPlatformType)type
            url:(NSString *)url
         method:(NSString *)method
     parameters:(NSMutableDictionary *)parameters
        headers:(NSMutableDictionary *)headers
    onAuthorize:(SSDKNeedAuthorizeHandler)authorizeHandler
 onStateChanged:(SSDKCallApiStateChangedHandler)stateChangedHandler;


@end
