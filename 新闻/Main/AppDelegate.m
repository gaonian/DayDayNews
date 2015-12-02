//
//  AppDelegate.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    TabbarViewController *main = [[TabbarViewController alloc]init];
    self.window.rootViewController = main;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

@end
