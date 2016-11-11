//
//  UIBarButtonItem+gyh.h
//  微博
//
//  Created by gyh on 15-3-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (gyh)

+(UIBarButtonItem *)ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 返回程序能用的导航条按钮,文字与图片共存，图片居右
 @param image : 图标
 @param title : 标题
 @param target : 点击按钮接受者
 @param sel : 点击事件
 @return 返回导航条按钮
 */
+ (UIBarButtonItem*)navigationBarRightButtonItemWithTitleAndImage:(UIImage *)image Title:(NSString *)title Target:(id)target Selector:(SEL)sel titleColor:(UIColor *)titleColor;
@end
