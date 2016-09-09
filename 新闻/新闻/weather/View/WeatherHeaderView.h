//
//  WeatherHeaderView.h
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherData;
@interface WeatherHeaderView : UIView

@property (nonatomic , copy) void(^localBlock)();
@property (nonatomic , copy) void(^backBlock)();

- (void)setHeaderDataWithAry:(NSMutableArray *)weatherArray dt:(NSString *)dt weatherData:(WeatherData *)wd;

@end
