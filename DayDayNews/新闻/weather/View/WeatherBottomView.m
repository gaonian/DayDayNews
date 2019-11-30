//
//  WeatherBottomView.m
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeatherBottomView.h"
#import "WeatherData.h"

@implementation WeatherBottomView

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setDataWithAry:(NSMutableArray *)ary
{
    [ary enumerateObjectsUsingBlock:^(WeatherData *weatherdata, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > 0) {
            
            CGFloat vcW = SCREEN_WIDTH/3;
            CGFloat vcH = vcW * 1.8;
            CGFloat vcX = (idx-1) * vcW;
            CGFloat vcY = SCREEN_HEIGHT - vcH;
            UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(vcX, 0, vcW, vcH)];
            [self addSubview:vc];
            self.frame = CGRectMake(0, vcY, SCREEN_WIDTH, vcH);
            self.backgroundColor = RGBA(1, 1, 1, 0.2);
            
            //星期
            UILabel *weekLabel = [[UILabel alloc]init];
            [self setupWithLabel:weekLabel frame:CGRectMake(0, 20, vcW, 20) FontSize:14 view:vc textAlignment:NSTextAlignmentCenter];
            //图片
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((vcW-60)/2, CGRectGetMaxY(weekLabel.frame) + 5, 60, 60*1.35)];
            [vc addSubview:img];
            //温度
            UILabel *temLabel = [[UILabel alloc]init];
            [self setupWithLabel:temLabel frame:CGRectMake(0, CGRectGetMaxY(img.frame), vcW, 20) FontSize:20 view:vc textAlignment:NSTextAlignmentCenter];
            //风，天气
            UILabel *cliwindLabel = [[UILabel alloc]init];
            cliwindLabel.numberOfLines = 0;
            [self setupWithLabel:cliwindLabel frame:CGRectMake(0, CGRectGetMaxY(temLabel.frame), vcW, 50) FontSize:12 view:vc textAlignment:NSTextAlignmentCenter];
            
            //星期
            weekLabel.text = weatherdata.week;
            //图片
            if ([weatherdata.climate isEqualToString:@"雷阵雨"]) {
                img.image = [UIImage imageNamed:@"thunder"];
            }else if ([weatherdata.climate isEqualToString:@"晴"]){
                img.image = [UIImage imageNamed:@"sun"];
            }else if ([weatherdata.climate isEqualToString:@"多云"]){
                img.image = [UIImage imageNamed:@"sunandcloud"];
            }else if ([weatherdata.climate isEqualToString:@"阴"]){
                img.image = [UIImage imageNamed:@"cloud"];
            }else if ([weatherdata.climate hasSuffix:@"雨"]){
                img.image = [UIImage imageNamed:@"rain"];
            }else if ([weatherdata.climate hasSuffix:@"雪"]){
                img.image = [UIImage imageNamed:@"snow"];
            }else{
                img.image = [UIImage imageNamed:@"sandfloat"];
            }
            //温度
            NSString *tem = [weatherdata.temperature stringByReplacingOccurrencesOfString:@"C" withString:@""];
            temLabel.text = tem;
            //风，天气
            cliwindLabel.text = [weatherdata.climate stringByAppendingFormat:@"\n%@",weatherdata.wind];
            
        }
    }];
}

- (void)setupWithLabel:(UILabel *)label frame:(CGRect)frame FontSize:(CGFloat)fontSize view:(UIView *)view textAlignment:(NSTextAlignment)textAlignment
{
    label.frame = frame;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    [view addSubview:label];
}

@end
