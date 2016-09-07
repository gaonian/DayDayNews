//
//  UIBarButtonItem+gyh.m
//  微博
//
//  Created by gyh on 15-3-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIBarButtonItem+gyh.h"


@implementation UIBarButtonItem (gyh)



//快速创建一个显示图片的item
+(UIBarButtonItem *)ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


+(UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero,40,30};
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}





@end
