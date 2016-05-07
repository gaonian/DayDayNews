//
//  MessageCell.m
//  
//
//  Created by gyh on 15/5/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//



// 正文的内边距
#define TextPadding 20


#import "MessageCell.h"

#import "UIImage+Extension.h"
#import "HyperlinksButton.h"

#import "NSString+Extension.h"



@interface MessageCell()

@end

@implementation MessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"message";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //初始化子控件
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
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = [UIFont systemFontOfSize:15];
        textView.contentEdgeInsets = UIEdgeInsetsMake(TextPadding, TextPadding, TextPadding, TextPadding);
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        //清除cell的背景色
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setMessage:(NSString *)message andType:(int)type andTime:(NSString *)date
{
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = SCREEN_WIDTH;
    CGFloat timeH = 40;
    self.timeView.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 1.时间
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *currentTime = [df stringFromDate:date];
    self.timeView.text = date;
    
    //头像
    CGFloat iconY = CGRectGetMaxY(self.timeView.frame);
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX;
    if (type == 1) {// 别人发的
        iconX = 10;
    } else { // 自己的发的
        iconX = SCREEN_WIDTH - 10 - iconW;
    }
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    //正文的尺寸
    CGSize textBtnSize;
    CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
    CGSize textRealSize = [message sizeWithFont:[UIFont systemFontOfSize:15] maxSize:textMaxSize];
    // 按钮最终的真实尺寸
    textBtnSize = CGSizeMake(textRealSize.width+TextPadding*2, textRealSize.height+TextPadding*2);
    CGFloat textY = iconY;
    CGFloat textX;
    if (type == 1) {// 别人发的
       textX = CGRectGetMaxX(self.iconView.frame) + 10;
    } else {// 自己的发的
        textX = iconX - 10 - textBtnSize.width;
    }
    self.textView.frame = (CGRect){{textX, textY}, textBtnSize};
    
    if (type == 1) { // 别人发的,白色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    } else { // 自己发的,蓝色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    }
}


@end
