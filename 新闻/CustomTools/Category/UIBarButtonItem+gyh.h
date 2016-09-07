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
+(UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
