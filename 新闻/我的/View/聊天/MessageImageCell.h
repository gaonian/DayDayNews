//
//  MessageImageCell.h
//  浙江社交
//
//  Created by gyh on 16/3/15.
//  Copyright © 2016年 lideliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageImageCell : UITableViewCell

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  正文
 */
@property (nonatomic, weak) UIImageView *textView;

/**
 *  根据type判断是自己发的消息还是好友的消息
 */
@property (nonatomic , assign) int photoType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setMessage:(NSString *)message andType:(int)type andTime:(NSDate *)date;

@end
