//
//  HeaderView.h
//  citycontrol
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CitiesGroup,LocaHeaderView;

@protocol LocaHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(LocaHeaderView *)locaheaderview;
@end

@interface LocaHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerWithTableView:(UITableView *)tableview;
@property (nonatomic , strong) CitiesGroup *groups;

@property (nonatomic, weak) id<LocaHeaderViewDelegate> delegate;

@end
