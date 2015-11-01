//
//  WeatherViewController.m
//  新闻
//
//  Created by gyh on 15/10/13.
//  Copyright © 2015年 apple. All rights reserved.
//  //http://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "WeatherViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "WeatherData.h"
#import "UIImageView+WebCache.h"
#import "LocaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"

@interface WeatherViewController ()<CLLocationManagerDelegate,LocaViewControllerDelegate>
@property (nonatomic , copy) NSString *province;
@property (nonatomic , copy) NSString *city;
@property (nonatomic , copy) NSString *dt;    //当前日期
@property (nonatomic , strong) NSMutableArray *weatherArray;
@property (nonatomic , strong) WeatherData *wd;

@property (nonatomic , weak) UILabel * cityLabel;
@property (nonatomic , weak) UILabel * dateLabel;
@property (nonatomic , weak) UIImageView * todayImg;
@property (nonatomic , weak) UILabel *temLabel;
@property (nonatomic , weak) UILabel *climateLabel;
@property (nonatomic , weak) UILabel *windLabel;
@property (nonatomic , weak) UILabel *pmLabel;

/**
 *  定位管理者
 */
@property (nonatomic ,strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic , assign) int  lati;
@property (nonatomic , assign) int  longi;

@end

@implementation WeatherViewController

-(NSMutableArray *)weatherArray
{
    if(!_weatherArray){
        _weatherArray = [NSMutableArray array];
    }
    return _weatherArray;
}

- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showMessage:@"正在加载...."];
    [self setupLocation];
    
}

-(void)setupLocation
{
    // 成为CoreLocation管理者的代理监听获取到的位置
    self.mgr.delegate = self;
    // 判断是否是iOS8
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        NSLog(@"是iOS8");
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
    }else
    {
        NSLog(@"是iOS7");
        // 开始监听(开始获取位置)
        [self.mgr startUpdatingLocation];
    }

}

/**
 *  授权状态发生改变时调用
 *
 *  @param manager 触发事件的对象
 *  @param status  当前授权的状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {
        NSLog(@"授权成功");
        // 开始定位
        [self.mgr startUpdatingLocation];
        
    }else
    {
        NSLog(@"授权失败");
    }
}

#pragma mark - CLLocationManagerDelegate
/**
 *  获取到位置信息之后就会调用(调用频率非常高)
 *
 *  @param manager   触发事件的对象
 *  @param locations 获取到的位置
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 如果只需要获取一次, 可以获取到位置之后就停止
    [self.mgr stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    self.lati = (int)location.coordinate.latitude;
    self.longi = (int)location.coordinate.longitude;
    NSLog(@"%d  %d",self.lati , self.longi);
    
    [self setupCity];
}

-(void)setupCity
{
    CLLocationDegrees lati = self.lati;
    CLLocationDegrees longi = self.longi;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lati longitude:longi];
    
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            CLPlacemark *pm = [placemarks firstObject];
            
            NSLog(@"%@",pm.name);
            NSLog(@"%@ ,%@ ,%@",pm.locality,pm.country ,pm.subLocality);
            
            if ([pm.name rangeOfString:@"市"].location != NSNotFound) {
                
                if ([pm.locality isEqualToString:@"上海市"]||[pm.locality isEqualToString:@"天津市"]||[pm.locality isEqualToString:@"北京市"]||[pm.locality isEqualToString:@"重庆市"])
                {
                    NSRange range = [pm.locality rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *citystr = [pm.locality substringToIndex:loc];
                    
                    self.city = self.province = citystr;
                    
                }else{
                    NSRange range = [pm.name rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *str = [pm.name substringToIndex:loc];
                    str = [str substringFromIndex:2];   //河南省南阳
                    
                    NSRange range1 = [str rangeOfString:@"省"];
                    int loc1 = (int)range1.location;
                    
                    NSLog(@"%@",str);
                    self.province = [str substringToIndex:loc1];
                    self.city = [str substringFromIndex:loc1+1];
                    
                    NSLog(@"%@,%@",[str substringToIndex:loc1],[str substringFromIndex:loc1]);
                }
                
            }else{
                NSLog(@"－－－%@",pm.locality);
                 NSRange range = [pm.locality rangeOfString:@"市"];
                int loc = (int)range.location;
                NSString *citystr = [pm.locality substringToIndex:loc];
                
                self.city = self.province = citystr;
                
            }
           
            [self requestNet];
        }
    }];

}

#pragma mark  请求网络
-(void)requestNet
{
    NSString *urlstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",self.province,self.city];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:urlstr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [MBProgressHUD hideHUD];
        
            self.dt = responseObject[@"dt"];
            NSString *str = [NSString stringWithFormat:@"%@|%@",self.province,self.city];
            NSArray *dataArray = [WeatherData objectArrayWithKeyValuesArray:responseObject[str]];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (WeatherData *weather in dataArray) {
                [tempArray addObject:weather];
            }
            [self.weatherArray addObjectsFromArray:tempArray];
            
            //pm2d5
            WeatherData *wd = [WeatherData objectWithKeyValues:responseObject[@"pm2d5"]];
            self.wd = wd;
            [self initAll];
       
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

-(void)initAll
{
    [self setupUI];        //设置顶部UI
    [self setupData];      //设置顶部UI数据
    [self bottomView];     //加载底部数据
}

#pragma mark  顶部UI
-(void)setupUI
{
    //背景
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.frame];
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.wd.nbg2] placeholderImage:[UIImage imageNamed:@"MoRen"]];
    [self.view addSubview:imageV];
    
    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, 25, 50, 50);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    //城市名
    CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
    CGSize textRealSize = [self.city sizeWithFont:[UIFont systemFontOfSize:17] maxSize:textMaxSize];
    CGFloat cityLabelW = textRealSize.width;
    CGFloat cityLabelH = 20;
    CGFloat cityLabelX = (SCREEN_WIDTH - cityLabelW)/2;
    CGFloat cityLabelY = 30;
    UILabel *cityLabel = [[UILabel alloc]init];
    [self setupWithLabel:cityLabel frame:CGRectMake(cityLabelX, cityLabelY, cityLabelW, cityLabelH) FontSize:17 view:self.view textAlignment:NSTextAlignmentCenter];
    self.cityLabel = cityLabel;
    
    //定位图标
    UIButton *locB = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityLabel.frame)+5, 30, 20, 20)];
    [locB setImage:[UIImage imageNamed:@"weather_location"] forState:UIControlStateNormal];
    [locB addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locB];
    
    //日期
    CGFloat dateLW = 110;
    CGFloat dateLH = 20;
    CGFloat dateLX = (SCREEN_WIDTH - dateLW)/2;
    CGFloat dateLY = CGRectGetMaxY(locB.frame) + 10;
    UILabel *dateLabel = [[UILabel alloc]init];
    [self setupWithLabel:dateLabel frame:CGRectMake(dateLX, dateLY, dateLW, dateLH) FontSize:14 view:self.view textAlignment:NSTextAlignmentCenter];
    self.dateLabel = dateLabel;
    
    //天气图片
    CGFloat todayImgW = 100;
    CGFloat todayImgH = todayImgW * 1.35;
    CGFloat todayImgX = SCREEN_WIDTH/2 - todayImgW - 10;
    CGFloat todayImgY = (SCREEN_HEIGHT - todayImgH)/2 - todayImgH/2;
    UIImageView *todayImg = [[UIImageView alloc]initWithFrame:CGRectMake(todayImgX, todayImgY, todayImgW, todayImgH)];
    [self.view addSubview:todayImg];
    self.todayImg = todayImg;
    
    //温度
    CGFloat temLabelW = 200;
    CGFloat temLabelH = 30;
    CGFloat temLabelX = SCREEN_WIDTH/2;
    CGFloat temLabelY = todayImgY;
    UILabel *temLabel = [[UILabel alloc]init];
    [self setupWithLabel:temLabel frame:CGRectMake(temLabelX, temLabelY, temLabelW, temLabelH) FontSize:30 view:self.view textAlignment:NSTextAlignmentLeft];
    self.temLabel = temLabel;
    
    //天气
    UILabel *climateLabel = [[UILabel alloc]init];
    [self setupWithLabel:climateLabel frame: CGRectMake(temLabelX, CGRectGetMaxY(temLabel.frame), temLabelW, 20) FontSize:14 view:self.view textAlignment:NSTextAlignmentLeft];
    self.climateLabel = climateLabel;
    
    //风
    UILabel *windLabel = [[UILabel alloc]init];
    [self setupWithLabel:windLabel frame:CGRectMake(temLabelX, CGRectGetMaxY(climateLabel.frame), temLabelW, 20) FontSize:14 view:self.view textAlignment:NSTextAlignmentLeft];
    self.windLabel = windLabel;
    
    //PM2.5
    UILabel *pmLabel = [[UILabel alloc]init];
    [self setupWithLabel:pmLabel frame:CGRectMake(temLabelX, CGRectGetMaxY(windLabel.frame), temLabelW, 20) FontSize:14 view:self.view textAlignment:NSTextAlignmentLeft];
    self.pmLabel = pmLabel;
}


#pragma mark 设置数据
-(void)setupData
{
    /**  加载数据  */
    //城市
    self.cityLabel.text = self.city;
    //日期
    WeatherData *weatherdata = self.weatherArray[0];
    NSString *dtstr = [self.dt substringFromIndex:5];
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
    int pm = self.wd.pm2_5.intValue;
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


#pragma mark  底部view
-(void)bottomView
{
    for (int i = 1; i < 4; i++) {
        CGFloat vcW = SCREEN_WIDTH/3;
        CGFloat vcH = vcW * 1.8;
        CGFloat vcX = (i-1) * vcW;
        CGFloat vcY = SCREEN_HEIGHT - vcH;
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(vcX, vcY, vcW, vcH)];
        vc.backgroundColor = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:0.2];
        [self.view addSubview:vc];
        
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
        
        /**  加载数据  */
        WeatherData *weatherdata = self.weatherArray[i];
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

}


-(void)locClick
{
    LocaViewController *locaV = [[LocaViewController alloc]init];
    locaV.currentTitle = self.city;
    locaV.delegate = self;
    locaV.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:locaV];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


#pragma mark 设置label属性
-(void)setupWithLabel:(UILabel *)label frame:(CGRect)frame FontSize:(CGFloat)fontSize view:(UIView *)view textAlignment:(NSTextAlignment)textAlignment
{
    label.frame = frame;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    [view addSubview:label];
}


-(void)locaviewwithview:(LocaViewController *)locaviewcontrol provice:(NSString *)provice city:(NSString *)city
{
    self.weatherArray = nil;
    self.province = provice;
    self.city = city;
    NSLog(@"点击了  %@  %@",self.province,self.city);
    [MBProgressHUD showMessage:@"正在加载..."];
    [self requestNet];
}


#pragma mark 返回按钮
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}



@end
