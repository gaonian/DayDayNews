//
//  MessageCell.h
//  机器人
//
//  Created by gyh on 15/5/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell


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
@property (nonatomic, weak) UIButton *textView;

/**
 *  根据type判断是自己发的消息还是好友的消息
 */
@property (nonatomic , assign) int photoType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setMessage:(NSString *)message andType:(int)type andTime:(NSString *)date;

@end
