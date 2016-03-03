//
//  NewsCell.h
//  新闻
//
//  Created by gyh on 16/3/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@interface NewsCell : UITableViewCell
@property (nonatomic , strong) DataModel *dataModel;

/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(DataModel *)NewsModel;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(DataModel *)NewsModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
