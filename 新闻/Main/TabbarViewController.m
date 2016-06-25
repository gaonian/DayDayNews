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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
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
    
    [self handleThemeChanged];
}

-(void)tabbar:(TabbarView *)tabbar didselectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}

-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
       [self.tabbar setBackgroundColor:defaultManager.themeColor];
    }else{
        self.tabbar.backgroundColor = [UIColor whiteColor];
    }
}


-(void)initControl
{
    SCNavTabBarController  *new = [[SCNavTabBarController alloc]init];
    [self setupChildViewController:new title:@"新闻" imageName:@"tabbar_news" selectedImage:@"tabbar_news_hl"];

    PhotoViewController *photo = [[PhotoViewController alloc]init];
    [self setupChildViewController:photo title:@"图片" imageName:@"tabbar_picture" selectedImage:@"tabbar_picture_hl"];
    
    VideoViewController *video = [[VideoViewController alloc]init];
    [self setupChildViewController:video title:@"视频" imageName:@"tabbar_video" selectedImage:@"tabbar_video_hl"];

    MeViewController *me = [[MeViewController alloc]init];
    [self setupChildViewController:me title:@"我的" imageName:@"tabbar_setting" selectedImage:@"tabbar_setting_hl"];

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
