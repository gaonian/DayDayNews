//
//  NavigationController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "NavigationController.h"
#import "UIBarButtonItem+gyh.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
//       [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:246.0/255.0f green:246.0/255.0f blue:247.0/255.0f alpha:1]];
    [[UINavigationBar appearance]setBarTintColor:[[ThemeManager sharedInstance] themeColor]];
}

#pragma mark  拦截push，一旦进入下个视图，隐藏tabbar，自定义返回按钮
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithIcon:@"navigationbar_back_os7" highIcon:nil target:self action:@selector(back)];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
