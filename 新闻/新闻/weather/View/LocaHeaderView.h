//
//  HeaderView.h
//  citycontrol
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CitiesGroup;
@interface LocaHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerWithTableView:(UITableView *)tableview;
@property (nonatomic , strong) CitiesGroup *groups;

@end
