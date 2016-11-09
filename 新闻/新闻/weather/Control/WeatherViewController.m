//
//  WeatherViewController.m
//  新闻
//
//  Created by gyh on 15/10/13.
//  Copyright © 2015年 apple. All rights reserved.
//  //http://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html

#import "WeatherViewController.h"
#import "WeatherData.h"
#import "LocaViewController.h"
#import "WeatherBottomView.h"
#import "WeatherHeaderView.h"

@interface WeatherViewController ()

@property (nonatomic , strong) NSMutableArray *weatherArray;

@property (nonatomic , strong) WeatherHeaderView *      headerView;
///底部未来三天view
@property (nonatomic , strong) WeatherBottomView *      bottomView;


@end

@implementation WeatherViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString *pro = [AppConfig getProInfo];
    NSString *city = [AppConfig getCityInfo];
    
    if (pro && city) {
        [self requestNet:pro city:city];
    }
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
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - network
- (void)requestNet:(NSString *)pro city:(NSString *)city
{
    IMP_BLOCK_SELF(WeatherViewController);
    NSString *urlstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",pro,city];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[BaseEngine shareEngine] runRequestWithPara:nil path:urlstr success:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSString *str = [NSString stringWithFormat:@"%@|%@",pro,city];
        NSArray *dataArray = [WeatherData objectArrayWithKeyValuesArray:responseObject[str]];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WeatherData *weather in dataArray) {
            [tempArray addObject:weather];
        }
        block_self.weatherArray = tempArray;
        
        //pm2d5
        WeatherData *wd = [WeatherData objectWithKeyValues:responseObject[@"pm2d5"]];
        
        [block_self.headerView setHeaderDataWithAry:block_self.weatherArray dt:responseObject[@"dt"] weatherData:wd];
        //底部未来三天数据
        [block_self.bottomView setDataWithAry:block_self.weatherArray];
        
    } failure:^(id error) {
        
    }];
}

#pragma mark - lazy
- (NSMutableArray *)weatherArray
{
    if(!_weatherArray){
        _weatherArray = [NSMutableArray array];
    }
    return _weatherArray;
}

- (WeatherBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[WeatherBottomView alloc]init];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (WeatherHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WeatherHeaderView alloc]init];
        [self.view addSubview:_headerView];
    }
    IMP_BLOCK_SELF(WeatherViewController);
    _headerView.localBlock = ^{
        
        NSString *city = [AppConfig getCityInfo];
        LocaViewController *locaV = [[LocaViewController alloc]init];
        locaV.currentTitle = city;
        locaV.view.backgroundColor = [UIColor whiteColor];
        locaV.CityBlock = ^(NSString *provice,NSString *city){
            block_self.weatherArray = nil;
            [MBProgressHUD showMessage:@"正在加载..."];
            [block_self requestNet:provice city:city];
            [AppConfig saveProAndCityInfoWithPro:provice city:city];
        };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:locaV];
        [block_self.navigationController presentViewController:nav animated:YES completion:nil];
    };
    _headerView.backBlock = ^{
        [block_self back];
    };
    return _headerView;
}


@end
