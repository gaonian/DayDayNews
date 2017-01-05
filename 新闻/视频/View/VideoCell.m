//
//  VideoCell.m
//  新闻
//
//  Created by gyh on 15/9/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "UIImageView+WebCache.h"

@implementation VideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        UIImageView *imageview = [[UIImageView alloc]init];
        [self.contentView addSubview:imageview];
        self.imageview = imageview;
        
        //题目背景
        UIImageView *imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        imgBgTop.image = [UIImage imageNamed:@"top_shadow.png"];
        [self.contentView addSubview:imgBgTop];
        
        //题目
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = HEXColor(@"ffffff");
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *playcoverImage = [[UIImageView alloc]init];
        [self.contentView addSubview:playcoverImage];
        self.playcoverImage = playcoverImage;
        
        //时长
        UILabel *lengthLabel = [[UILabel alloc]init];
        lengthLabel.textColor = HEXColor(@"ffffff");
        lengthLabel.backgroundColor = RGBA(1, 1, 1, 0.3);
        lengthLabel.textAlignment = NSTextAlignmentCenter;
        lengthLabel.layer.cornerRadius = 10;
        lengthLabel.layer.masksToBounds = YES;
        lengthLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:lengthLabel];
        self.lengthLabel = lengthLabel;
        
        //来源图标
        UIImageView *playImage = [[UIImageView alloc] init];
        playImage.layer.cornerRadius = 12;
        playImage.layer.masksToBounds = YES;
        [self.contentView addSubview:playImage];
        self.playImage = playImage;
        
        //来源文字
        UILabel *lbSource = [[UILabel alloc] init];
        lbSource.font = [UIFont systemFontOfSize:13];
        lbSource.textColor = HEXColor(@"333333");
        [self.contentView addSubview:lbSource];
        self.playcountLabel = lbSource;
        
        //时间
        UILabel *ptimeLabel = [[UILabel alloc]init];
        ptimeLabel.textColor = HEXColor(@"797979");
        ptimeLabel.font = [UIFont systemFontOfSize:13];
        ptimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:ptimeLabel];
        self.ptimeLabel = ptimeLabel;
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = RGBA(239, 239, 244, 1);
        [self.contentView addSubview:lineV];
        self.lineV = lineV;

        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


-(void)setVideodataframe:(VideoDataFrame *)videodataframe
{
    _videodataframe = videodataframe;
    VideoData *videodata = _videodataframe.videodata;
    
    //图片
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:videodata.cover] placeholderImage:[UIImage imageNamed:@"sc_video_play_fs_loading_bg.png"]];
    self.imageview.frame = _videodataframe.coverF;
    
    //题目
    NSString *str = [videodata.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    self.titleLabel.text = str;
    self.titleLabel.frame = _videodataframe.titleF;
    
    self.playcoverImage.image = [UIImage imageNamed:@"play_btn"];
    self.playcoverImage.frame = _videodataframe.playF;
    
    self.lengthLabel.text = [self convertTime:videodata.length];
    self.lengthLabel.frame = _videodataframe.lengthF;
    
    [self.playImage sd_setImageWithURL:[NSURL URLWithString:videodata.topicImg]];
    self.playImage.frame = _videodataframe.playImageF;
    
    self.playcountLabel.text = videodata.topicName;
    self.playcountLabel.frame = _videodataframe.playCountF;
    
    //时间
    self.ptimeLabel.text = videodata.ptime;
    self.ptimeLabel.frame = _videodataframe.ptimeF;
    
    self.lineV.frame = _videodataframe.lineVF;
    
}

//时间转换
- (NSString *)convertTime:(CGFloat)second{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [fmt setDateFormat:@"HH:mm:ss"];
    } else {
        [fmt setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [fmt stringFromDate:d];
    return showtimeNew;
}



@end
