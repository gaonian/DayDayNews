//
//  PullDownView.h
//  新闻
//
//  Created by gyh on 16/8/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownItem : NSObject
///文字，图标
@property (nonatomic , copy) NSString *     title;
@property (nonatomic , strong) UIImage *    icon;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;
+ (PullDownItem *)itemWithTitle:(NSString *)title icon:(UIImage *)icon;
@end

@interface PullDownView : UIView

@property (nonatomic , copy) void(^SelectBlock)(id sender);
@property (nonatomic , copy) void(^removeBlock)();

@property (nonatomic , getter=isShow) BOOL isShow;


- (void)show;
- (void)removeView;
- (void)setDataWithItemAry:(NSArray *)ary;

@end
