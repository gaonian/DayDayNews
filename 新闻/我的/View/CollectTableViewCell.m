//
//  CollectTableViewCell.m
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CollectTableViewCell.h"
#import "CollectModel.h"

@implementation CollectTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"collectCell";
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CollectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titlL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
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


- (void)setCollectModel:(CollectModel *)collectModel
{
    _collectModel = collectModel;
    
    _titleL.text = collectModel.title;
    _timeL.text = collectModel.time;
}

@end
