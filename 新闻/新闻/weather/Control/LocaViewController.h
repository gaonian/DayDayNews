//
//  LocaViewController.h
//  新闻
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocaViewController;
@protocol LocaViewControllerDelegate <NSObject>

@optional
-(void)locaviewwithview:(LocaViewController *)locaviewcontrol  provice:(NSString *)provice city:(NSString *)city;

@end

@interface LocaViewController : UIViewController
@property (nonatomic , weak) id<LocaViewControllerDelegate> delegate;

@property (nonatomic , copy) NSString *currentTitle;

@end
