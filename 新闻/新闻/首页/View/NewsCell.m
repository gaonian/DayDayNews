//
//  NewsCell.m
//  新闻
//
//  Created by gyh on 16/3/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewsCell.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

@interface NewsCell()
@end

@implementation NewsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"newscell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(10, 10, 80, 60);
        [self addSubview:imageV];
        self.imgIcon = imageV;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, 10, SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 20)];
        if (SCREEN_WIDTH == 320) {
            label.font = [UIFont systemFontOfSize:15];
        }else{
            label.font = [UIFont systemFontOfSize:16];
        }
        [self addSubview:label];
        self.lblTitle = label;
        
        UILabel *scrL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(label.frame), SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 40)];
        scrL.numberOfLines = 0;
        scrL.font = [UIFont systemFontOfSize:14];
        scrL.textColor = [UIColor lightGrayColor];
        [self addSubview:scrL];
        self.lblSubtitle = scrL;
        
        CGFloat x = SCREEN_WIDTH-5-100;
        CGFloat y = CGRectGetMaxY(imageV.frame)-10;
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
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.lblTitle.text = self.dataModel.title;
    self.lblSubtitle.text = self.dataModel.digest;
    
    // 如果回复太多就改成几点几万
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


#pragma mark - 返回可重用ID
+ (NSString *)idForRow:(DataModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID) {
        return @"TopImageCell";
    }else if (NewsModel.hasHead){
        return @"TopTxtCell";
    }else if (NewsModel.imgType){
        return @"BigImageCell";
    }else if (NewsModel.imgextra){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}

#pragma mark - 返回行高
+ (CGFloat)heightForRow:(DataModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID){
        return 0;
    }else if(NewsModel.hasHead) {
        return 0;
    }else if(NewsModel.imgType) {
        if (SCREEN_WIDTH == 320) {
            return 180;
        }else{
            return 196;
        }
    }else if (NewsModel.imgextra){
        if (SCREEN_WIDTH == 320) {
            return 115;
        }else{
            return 130;
        }
    }else{
        return 80;
    }
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
