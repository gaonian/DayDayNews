//
//  DOPNavbarMenu.h
//  DOPNavbarMenu
//
//  Created by weizhou on 5/14/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIView+DOPExtension.h"

@interface UITouchGestureRecognizer : UIGestureRecognizer
@end

@interface DOPNavbarMenuItem : NSObject

@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) UIImage *icon;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;
+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon;

@end

@class DOPNavbarMenu;
@protocol DOPNavbarMenuDelegate <NSObject>

- (void)didShowMenu:(DOPNavbarMenu *)menu;
- (void)didDismissMenu:(DOPNavbarMenu *)menu;
- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index;

@end

//iOS7+
@interface DOPNavbarMenu : UIView

@property (copy, nonatomic, readonly) NSArray *items;
@property (assign, nonatomic, readonly) NSInteger maximumNumberInRow;
@property (assign, nonatomic, getter=isOpen) BOOL open;
@property (weak, nonatomic) id <DOPNavbarMenuDelegate> delegate;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *separatarColor;

- (instancetype)initWithItems:(NSArray *)items
                        width:(CGFloat)width
           maximumNumberInRow:(NSInteger)max;

- (void)showInNavigationController:(UINavigationController *)nvc;
- (void)dismissWithAnimation:(BOOL)animation;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com