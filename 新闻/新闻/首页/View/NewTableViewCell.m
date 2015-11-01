//
//  PhotoTableViewCell.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "NewTableViewCell.h"
#import "NewDataFrame.h"
#import "NewData.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

@implementation NewTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[NewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        UIImageView *imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:imageV];
        self.imageV = imageV;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont fontWithName:@"Avenir" size:15];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

-(void)setDataFrame:(NewDataFrame *)dataFrame
{
    _dataFrame = dataFrame;
    NewData *data = _dataFrame.NewData;
    
    //图片
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:data.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.imageV.frame = _dataFrame.picUrlF;
    
    //title
    self.titleLabel.text = data.title;
    self.titleLabel.frame = _dataFrame.titleF;
    
    //时间
    self.timeLabel.text = data.ctime;
    
    CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
    CGSize textRealSize = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:textMaxSize];
    CGFloat ctimeX = SCREEN_WIDTH - textRealSize.width - 10;
    CGFloat ctimeY = CGRectGetMaxY(_dataFrame.titleF) + 10;
    self.timeLabel.frame = (CGRect){{ctimeX,ctimeY},textRealSize};
    
    

    
}


#pragma mark 重画tableview的线

- (void)drawRect:(CGRect)rect

{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);

    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
    
}

@end
