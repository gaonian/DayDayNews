//
//  TabbarViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TabbarViewController.h"
#import "NavigationController.h"
#import "PhotoViewController.h"
#import "VideoViewController.h"
#import "MeViewController.h"
#import "SCNavTabBarController.h"
#import "TabbarView.h"

@interface TabbarViewController ()<TabbarViewDelegate>
@property (nonatomic , strong) TabbarView *tabbar;

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabbar];
    
    [self initControl];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if([child isKindOfClass:[UIControl class]])
        {
            [child removeFromSuperview];
        }
    }
}


-(void)initTabbar
{
    TabbarView *tabbar = [[TabbarView alloc]init];
    tabbar.frame = self.tabBar.bounds;
    tabbar.delegate = self;
    [self.tabBar addSubview:tabbar];
    self.tabbar = tabbar;
}

-(void)tabbar:(TabbarView *)tabbar didselectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}

-(void)initControl
{
    SCNavTabBarController  *new = [[SCNavTabBarController alloc]init];
    [self setupChildViewController:new title:@"新闻" imageName:@"new" selectedImage:@"new_selected"];

    PhotoViewController *photo = [[PhotoViewController alloc]init];
    [self setupChildViewController:photo title:@"图片" imageName:@"me" selectedImage:@"me_selected"];
    
    VideoViewController *video = [[VideoViewController alloc]init];
    [self setupChildViewController:video title:@"视频" imageName:@"me" selectedImage:@"me_selected"];

    MeViewController *me = [[MeViewController alloc]init];
    [self setupChildViewController:me title:@"我的" imageName:@"me" selectedImage:@"me_selected"];

}


-(void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage
{
    
    //设置控制器属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //包装一个导航控制器
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    [self.tabbar addTabBarButtonWithItem:childVc.tabBarItem];
}


@end
