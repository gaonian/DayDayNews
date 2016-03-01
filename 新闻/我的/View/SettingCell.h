//
//  SettingCell.h
//  新闻
//
//  Created by gyh on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingItem;
@interface SettingCell : UITableViewCell
@property(nonatomic,strong)SettingItem *item;

+(instancetype)cellWithTableView:(UITableView *)tableview;
@end
