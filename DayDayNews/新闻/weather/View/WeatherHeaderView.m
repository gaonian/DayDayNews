//
//  WeatherHeaderView.m
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeatherHeaderView.h"
#import "WeatherData.h"

@interface WeatherHeaderView()

@property (nonatomic , weak) UIImageView *imageV;
@property (nonatomic , weak) UILabel * cityLabel;
@property (nonatomic , weak) UILabel * dateLabel;
@property (nonatomic , weak) UIImageView * todayImg;
@property (nonatomic , weak) UILabel *temLabel;
@property (nonatomic , weak) UILabel *climateLabel;
@property (nonatomic , weak) UILabel *windLabel;
@property (nonatomic , weak) UILabel *pmLabel;

@end

@implementation WeatherHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        //背景
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        imageV.image = [UIImage imageNamed:@"MoRen"];
        [self addSubview:imageV];
        self.imageV = imageV;
        
        //返回按钮
        UIButton *backbtn = [[UIButton alloc]init];
        backbtn.frame = CGRectMake(5, 25, 50, 50);
        [backbtn setBackgroundImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backbtn];
        
        //城市名
        CGFloat cityLabelW = 50;
        CGFloat cityLabelH = 20;
        CGFloat cityLabelX = (SCREEN_WIDTH - cityLabelW)/2;
        CGFloat cityLabelY = 30;
        UILabel *cityLabel = [[UILabel alloc]init];
        [self setupWithLabel:cityLabel frame:CGRectMake(cityLabelX, cityLabelY, cityLabelW, cityLabelH) FontSize:17 view:self textAlignment:NSTextAlignmentCenter];
        self.cityLabel = cityLabel;
        
        //定位图标
        UIButton *locB = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityLabel.frame)+5, 30, 20, 20)];
        [locB setImage:[UIImage imageNamed:@"weather_location"] forState:UIControlStateNormal];
        [locB addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:locB];
        
        //日期
        CGFloat dateLW = 110;
        CGFloat dateLH = 20;
        CGFloat dateLX = (SCREEN_WIDTH - dateLW)/2;
        CGFloat dateLY = CGRectGetMaxY(locB.frame) + 10;
        UILabel *dateLabel = [[UILabel alloc]init];
        [self setupWithLabel:dateLabel frame:CGRectMake(dateLX, dateLY, dateLW, dateLH) FontSize:14 view:self textAlignment:NSTextAlignmentCenter];
        self.dateLabel = dateLabel;
        
        //天气图片
        CGFloat todayImgW = 100;
        CGFloat todayImgH = todayImgW * 1.35;
        CGFloat todayImgX = SCREEN_WIDTH/2 - todayImgW - 10;
        CGFloat todayImgY = (SCREEN_HEIGHT - todayImgH)/2 - todayImgH/2;
        UIImageView *todayImg = [[UIImageView alloc]initWithFrame:CGRectMake(todayImgX, todayImgY, todayImgW, todayImgH)];
        [self addSubview:todayImg];
        self.todayImg = todayImg;
        
        //温度
        CGFloat temLabelW = 200;
        CGFloat temLabelH = 30;
        CGFloat temLabelX = SCREEN_WIDTH/2;
        CGFloat temLabelY = todayImgY;
        UILabel *temLabel = [[UILabel alloc]init];
        [self setupWithLabel:temLabel frame:CGRectMake(temLabelX, temLabelY, temLabelW, temLabelH) FontSize:30 view:self textAlignment:NSTextAlignmentLeft];
        self.temLabel = temLabel;
        
        //天气
        UILabel *climateLabel = [[UILabel alloc]init];
        [self setupWithLabel:climateLabel frame: CGRectMake(temLabelX, CGRectGetMaxY(temLabel.frame), temLabelW, 20) FontSize:14 view:self textAlignment:NSTextAlignmentLeft];
        self.climateLabel = climateLabel;
        
        //风
        UILabel *windLabel = [[UILabel alloc]init];
        [self setupWithLabel:windLabel frame:CGRectMake(temLabelX, CGRectGetMaxY(climateLabel.frame), temLabelW, 20) FontSize:14 view:self textAlignment:NSTextAlignmentLeft];
        self.windLabel = windLabel;
        
        //PM2.5
        UILabel *pmLabel = [[UILabel alloc]init];
        [self setupWithLabel:pmLabel frame:CGRectMake(temLabelX, CGRectGetMaxY(windLabel.frame), temLabelW, 20) FontSize:14 view:self textAlignment:NSTextAlignmentLeft];
        self.pmLabel = pmLabel;

        
    }
    return self;
}

- (void)setHeaderDataWithAry:(NSMutableArray *)weatherArray dt:(NSString *)dt weatherData:(WeatherData *)wd
{
    NSString *city = [AppConfig getCityInfo];
    
    /**  加载数据  */
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:wd.nbg2] placeholderImage:[UIImage imageNamed:@"MoRen"]];
    //城市
    self.cityLabel.text = city;
    //日期
    WeatherData *weatherdata = weatherArray[0];
    NSString *dtstr = [dt substringFromIndex:5];
    NSString *datestr = [dtstr stringByAppendingFormat:@"日 %@",weatherdata.week];
    datestr = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    self.dateLabel.text = datestr;
    //天气图片
    if ([weatherdata.climate isEqualToString:@"雷阵雨"]) {
        self.todayImg.image = [UIImage imageNamed:@"thunder"];
    }else if ([weatherdata.climate isEqualToString:@"晴"]){
        self.todayImg.image = [UIImage imageNamed:@"sun"];
    }else if ([weatherdata.climate isEqualToString:@"多云"]){
        self.todayImg.image = [UIImage imageNamed:@"sunandcloud"];
    }else if ([weatherdata.climate isEqualToString:@"阴"]){
        self.todayImg.image = [UIImage imageNamed:@"cloud"];
    }else if ([weatherdata.climate hasSuffix:@"雨"]){
        self.todayImg.image = [UIImage imageNamed:@"rain"];
    }else if ([weatherdata.climate hasSuffix:@"雪"]){
        self.todayImg.image = [UIImage imageNamed:@"snow"];
    }else{
        self.todayImg.image = [UIImage imageNamed:@"sandfloat"];
    }
    
    //图片动画效果
    [UIView animateKeyframesWithDuration:0.9 delay:0.5 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.todayImg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.9 animations:^{
            self.todayImg.transform = CGAffineTransformIdentity;
        }];
    }];

    //温度
    weatherdata.temperature = [weatherdata.temperature stringByReplacingOccurrencesOfString:@"C" withString:@""];
    self.temLabel.text = weatherdata.temperature;
    //天气
    self.climateLabel.text = weatherdata.climate;
    //风
    self.windLabel.text = weatherdata.wind;
    //pm
    NSString *aqi;
    int pm = wd.pm2_5.intValue;
    if (pm < 50) {
        aqi = @"优";
    }else if (pm < 100){
        aqi = @"良";
    }else{
        aqi = @"差";
    }
    NSString *pmstr = @"PM2.5";
    pmstr = [pmstr stringByAppendingFormat:@"   %d   %@",pm,aqi];
    self.pmLabel.text = pmstr;
}

- (void)locClick
{
    if (self.localBlock) {
        self.localBlock();
    }
}

- (void)back
{
    if (self.backBlock) {
        self.backBlock();
    }
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
