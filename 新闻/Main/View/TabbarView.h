//
//  TabbarView.h
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabbarView;
@protocol TabbarViewDelegate <NSObject>

@optional
-(void)tabbar:(TabbarView *)tabbar didselectedButtonFrom:(int)from to:(int)to;

@end


@interface TabbarView : UIView

-(void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property(nonatomic,weak) id<TabbarViewDelegate> delegate;

@end
