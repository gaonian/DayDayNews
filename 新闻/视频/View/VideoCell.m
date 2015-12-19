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
        
        //题目
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //描述
//        UILabel *descLabel = [[UILabel alloc]init];
//        descLabel.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:descLabel];
//        self.descLabel = descLabel;
        
        //图片
        UIImageView *imageview = [[UIImageView alloc]init];
        [self.contentView addSubview:imageview];
        self.imageview = imageview;
        
        UIImageView *playcoverImage = [[UIImageView alloc]init];
        [self.contentView addSubview:playcoverImage];
        self.playcoverImage = playcoverImage;
        
        //时长图标
        UIImageView *lengthImage = [[UIImageView alloc]init];
        [self.contentView addSubview:lengthImage];
        self.lengthImage = lengthImage;
        
        //时长
        UILabel *lengthLabel = [[UILabel alloc]init];
        lengthLabel.textColor = [UIColor grayColor];
        lengthLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:lengthLabel];
        self.lengthLabel = lengthLabel;
        
        //播放图标
        UIImageView *playImage = [[UIImageView alloc]init];
        [self.contentView addSubview:playImage];
        self.playImage = playImage;
        
        //播放数
        UILabel *playcountLabel = [[UILabel alloc]init];
        playcountLabel.textColor = [UIColor grayColor];
         playcountLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:playcountLabel];
        self.playcountLabel = playcountLabel;
        
        //时间
        UILabel *ptimeLabel = [[UILabel alloc]init];
        ptimeLabel.textColor = [UIColor grayColor];
        ptimeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:ptimeLabel];
        self.ptimeLabel = ptimeLabel;
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
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
    
    //题目
    NSString *str = [videodata.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    self.titleLabel.text = str;
    self.titleLabel.frame = _videodataframe.titleF;
    
    //描述
//    self.descLabel.text = videodata.Description;
//    self.descLabel.frame = _videodataframe.DescriptionF;

    //图片
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:videodata.cover] placeholderImage:nil];
    self.imageview.frame = _videodataframe.coverF;
    
    self.playcoverImage.image = [UIImage imageNamed:@"play120-1"];
    self.playcoverImage.frame = _videodataframe.playF;
    
    //时长
    self.lengthImage.image = [UIImage imageNamed:@"play"];
    self.lengthImage.frame = _videodataframe.lengtImageF;
    
    self.lengthLabel.text = [self convertTime:videodata.length];
    self.lengthLabel.frame = _videodataframe.lengthF;
    
    //播放数
    self.playImage.image = [UIImage imageNamed:@"play"];
    self.playImage.frame = _videodataframe.playImageF;
    
    self.playcountLabel.text = videodata.playCount;
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
