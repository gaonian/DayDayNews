//
//  CollectTableViewCell.h
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectModel;
@interface CollectTableViewCell : UITableViewCell
@property (nonatomic , strong) CollectModel *collectModel;

@property (nonatomic , weak) UILabel *titleL;
@property (nonatomic , weak) UILabel *timeL;


@end
