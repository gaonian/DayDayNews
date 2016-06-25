//
//  VideoCell.h
//  新闻
//
//  Created by gyh on 15/9/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoDataFrame;
@interface VideoCell : UITableViewCell
@property (nonatomic , strong) VideoDataFrame *videodataframe;


@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *descLabel;
@property (nonatomic , weak) UIImageView *imageview;
@property (nonatomic , weak) UIImageView *playcoverImage;

@property (nonatomic , weak) UIImageView *lengthImage;
@property (nonatomic , weak) UILabel *lengthLabel;
@property (nonatomic , weak) UIImageView *playImage;
@property (nonatomic , weak) UILabel *playcountLabel;
@property (nonatomic , weak) UILabel *ptimeLabel;
@property (nonatomic , weak) UIView *lineV;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
