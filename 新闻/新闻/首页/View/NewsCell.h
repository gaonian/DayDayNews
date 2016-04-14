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
 *  图片
 */
@property (weak, nonatomic) UIImageView *imgIcon;
/**
 *  标题
 */
@property (weak, nonatomic) UILabel *lblTitle;
/**
 *  回复数
 */
@property (weak, nonatomic) UILabel *lblReply;
/**
 *  描述
 */
@property (weak, nonatomic) UILabel *lblSubtitle;
/**
 *  第二张图片（如果有的话）
 */
@property (weak, nonatomic) UIImageView *imgOther1;
/**
 *  第三张图片（如果有的话）
 */
@property (weak, nonatomic) UIImageView *imgOther2;



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
