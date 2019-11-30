//
//  UIImage+Extension.h
//  
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)resizableImage:(NSString *)name;
/* 裁剪圆形图片 */
+ (UIImage *)clipImage:(UIImage *)image;
@end