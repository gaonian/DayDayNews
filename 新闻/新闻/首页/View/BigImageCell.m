//
//  BigImageCell.m
//  新闻
//
//  Created by gyh on 16/3/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BigImageCell.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"

@implementation BigImageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bigImagecell";
    BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BigImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        if (SCREEN_WIDTH == 320) {
            titleL.font = [UIFont systemFontOfSize:15];
        }else{
            titleL.font = [UIFont systemFontOfSize:16];
        }
        [self addSubview:titleL];
        self.titleL = titleL;
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleL.frame)+10, SCREEN_WIDTH-20, 0.3*(SCREEN_WIDTH-20))];
        imageview.backgroundColor = [UIColor grayColor];
        [self addSubview:imageview];
        self.image1 = imageview;
        
        UILabel *scrL = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageview.frame), SCREEN_WIDTH-20, 40)];
        scrL.numberOfLines = 0;
        scrL.font = [UIFont systemFontOfSize:14];
        scrL.textColor = [UIColor lightGrayColor];
        [self addSubview:scrL];
        self.lblSubtitle = scrL;
        
        CGFloat x = SCREEN_WIDTH-5-100;
        CGFloat y = CGRectGetMaxY(imageview.frame)+30;
        CGFloat w = 100;
        CGFloat h = 15;
        UILabel *replyL = [[UILabel alloc]init];
        replyL.frame = CGRectMake(x, y, w, h);
        replyL.textAlignment = NSTextAlignmentCenter;
        replyL.font = [UIFont systemFontOfSize:10];
        replyL.textColor = [UIColor darkGrayColor];
        [self addSubview:replyL];
        self.lblReply = replyL;
    }
    return self;
}


- (void)setDataModel:(DataModel *)dataModel
{
    _dataModel = dataModel;
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    self.titleL.text = self.dataModel.title;
    self.lblSubtitle.text = self.dataModel.digest;

    CGFloat count =  [self.dataModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
    self.lblReply.text = displayCount;
    
    self.lblReply.width = [self.lblReply.text sizeWithFont:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(200, MAXFLOAT)].width;
    self.lblReply.width += 10;
    self.lblReply.x = SCREEN_WIDTH - 10 - self.lblReply.width;
    
    [self.lblReply.layer setBorderWidth:1];
    [self.lblReply.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.lblReply.layer setCornerRadius:5];
    self.lblReply.clipsToBounds = YES;
}



#pragma mark 重画tableview的线

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

@end

