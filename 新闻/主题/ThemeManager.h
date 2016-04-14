//
//  ThemeManager.h
//  机器人
//
//  Created by gyh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#define Bundle_Of_ThemeResource @"ThemeResource"
#define Bundle_Path_Of_ThemeResource [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:Bundle_Of_ThemeResource]


#define Notice_Theme_Changed @"Notice_Theme_Changed"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

@property(nonatomic,copy)NSString *themeName;
@property(nonatomic,copy)NSString *themePath;
@property(nonatomic,strong)UIColor *themeColor;
@property (nonatomic , strong) UIColor *oldColor;


+ (ThemeManager*)sharedInstance;

-(void)changeThemeWithName:(NSString*)themeName;

- (UIImage*)themedImageWithName:(NSString*)imgName;

-(NSArray *)listOfAllTheme;


@end
