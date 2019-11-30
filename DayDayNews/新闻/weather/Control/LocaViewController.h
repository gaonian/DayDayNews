//
//  LocaViewController.h
//  新闻
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocaViewController : BaseViewController

@property (nonatomic , copy) void(^CityBlock)(NSString *provice , NSString *city);
@property (nonatomic , copy) NSString *currentTitle;

@end
