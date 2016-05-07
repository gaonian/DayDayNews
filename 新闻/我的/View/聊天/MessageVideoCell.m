//
//  MessageVideoCell.m
//  浙江社交
//
//  Created by gyh on 16/3/17.
//  Copyright © 2016年 lideliang. All rights reserved.
//


#import "MessageVideoCell.h"

@implementation MessageVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"messageVideo";
    MessageVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //时间
        UILabel *timeView = [[UILabel alloc]init];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.textColor = [UIColor grayColor];
        timeView.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        
        //头像
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        //正文
        UIButton *textView = [[UIButton alloc] init];
        textView.backgroundColor = [UIColor colorWithRed:185/255.0f green:237/255.0f blue:120/255.0f alpha:1];
        textView.userInteractionEnabled = NO;
        [textView setImage:[UIImage imageNamed:@"音频效果"] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        [textView.layer setCornerRadius:10];
        textView.clipsToBounds = YES;
        
        //清除cell的背景色
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
    
}

- (void)setMessage:(NSString *)message andType:(int)type andTime:(NSDate *)date
{
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = SCREEN_WIDTH;
    CGFloat timeH = 40;
    self.timeView.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 1.时间
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentTime = [df stringFromDate:date];
    self.timeView.text = currentTime;
    
    //头像
    CGFloat iconY = CGRectGetMaxY(self.timeView.frame);
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX;
    NSLog(@"type----%d",type);
    if (type == 1) {// 别人发的
        iconX = 10;
    } else { // 自己的发的
        iconX = SCREEN_WIDTH - 10 - iconW;
    }
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    //正文的尺寸
    CGFloat textW = 80;
    CGFloat textH = 30;
    CGFloat textY = iconY+10;
    CGFloat textX;
    if (type == 1) {// 别人发的
        textX = CGRectGetMaxX(self.iconView.frame) + 10;
    } else {// 自己的发的
        textX = iconX - 10 - textW;
    }
    self.textView.frame = CGRectMake(textX, textY, textW, textH);

}



@end
