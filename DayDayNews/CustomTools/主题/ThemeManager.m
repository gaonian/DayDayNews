//
//  ThemeManager.m
//  机器人
//
//  Created by gyh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

static ThemeManager * defaultManager;
+(ThemeManager*)sharedInstance
{
    if(defaultManager == nil)
    {
        defaultManager = [[ThemeManager alloc] init];
        [defaultManager initTheme];
    }
    return defaultManager;
    
}

-(void)initTheme
{
    self.themeName = [self currentTheme];
    self.themePath = [Bundle_Path_Of_ThemeResource stringByAppendingPathComponent:self.themeName];
    self.themeColor = [UIColor colorWithPatternImage:[self themedImageWithName:@"navigationBar"]];
    self.oldColor = [UIColor whiteColor];
}

//当前的主题
-(NSString *)currentTheme{
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"theme"] == nil){
        [[NSUserDefaults standardUserDefaults]setObject:@"系统默认" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return @"系统默认";
    }else
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    }
}

//改变主题
-(void)changeThemeWithName:(NSString*)themeName
{
    [[NSUserDefaults standardUserDefaults]setObject:themeName forKey:@"theme"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self initTheme];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notice_Theme_Changed object:nil];
}


//主题背景图片
- (UIImage*)themedImageWithName:(NSString*)imgName
{
    
    NSString *newImagePath = [self.themePath stringByAppendingPathComponent:imgName];
    return [UIImage imageWithContentsOfFile:newImagePath];
}


-(NSArray *)listOfAllTheme
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *listArray = [manager contentsOfDirectoryAtPath:Bundle_Path_Of_ThemeResource error:nil];
    return listArray;
}

@end
