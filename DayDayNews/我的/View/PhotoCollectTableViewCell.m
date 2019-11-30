//
//  PhotoCollectTableViewCell.m
//  新闻
//
//  Created by gyh on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PhotoCollectTableViewCell.h"
#import "PhotoCollectModel.h"

@implementation PhotoCollectTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"collectPhotoCell";
    PhotoCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PhotoCollectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *tagL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 55, 20)];
        tagL.text = @"【图】";
        tagL.textColor = [UIColor redColor];
        [self.contentView addSubview:tagL];
        
        UILabel *titlL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tagL.frame), 10, SCREEN_WIDTH-50, 20)];
        [self.contentView addSubview:titlL];
        titlL.font = [UIFont systemFontOfSize:16];
        _titleL = titlL;
        
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 10)];
        timeL.textColor = [UIColor grayColor];
        timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeL];
        _timeL = timeL;
    }
    return self;
}

- (void)setPhotoModel:(PhotoCollectModel *)photoModel
{
    _photoModel = photoModel;
    _titleL.text = photoModel.title;
    _timeL.text = photoModel.time;
}


@end
