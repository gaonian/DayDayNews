//
//  PhotoCollectTableViewCell.h
//  新闻
//
//  Created by gyh on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCollectModel;
@interface PhotoCollectTableViewCell : UITableViewCell
@property (nonatomic , strong) PhotoCollectModel *photoModel;

/**
 *  标题
 */
@property (nonatomic , weak) UILabel *titleL;
/**
 *  收藏的时间
 */
@property (nonatomic , weak) UILabel *timeL;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
