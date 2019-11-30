//
//  SSDKImage.h
//  ShareSDK
//
//  Created by 冯 鸿杰 on 15/2/25.
//  Copyright (c) 2015年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  JPG图片格式
 */
extern NSString *const SSDKImageFormatJpeg;

/**
 *  PNG图片格式
 */
extern NSString *const SSDKImageFormatPng;

/**
 *  图片质量键，当图片为JPG时有效
 */
extern NSString *const SSDKImageSettingQualityKey;

/**
 *  图片
 */
@interface SSDKImage : NSObject

/**
 *  初始化图片
 *
 *  @param URL 图片路径
 *
 *  @return 图片对象
 */
- (id)initWithURL:(NSURL *)URL;

/**
 *  初始化图片
 *
 *  @param image 原始的图片对象
 *  @param format   图片格式，由SSDKImageFormatJpeg和SSDKImageFormatPng来指定分享出去的是JPG还是PNG图片，如果传入其他值则默认为JPG
 *
 *  @return 图片对象
 */
- (id)initWithImage:(UIImage *)image format:(NSString *)format settings:(NSDictionary *)settings;

/**
 *  获取原生图片对象
 *
 *  @param handler 处理器
 */
- (void)getNativeImage:(void(^)(UIImage *image))handler;

@end
