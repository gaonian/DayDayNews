//
//  StartManager.m
//  新闻
//
//  Created by 范英强 on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StartManager.h"
#import "INTULocationManager.h"

@interface StartManager()
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation StartManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initManager];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)initManager
{
    if (self = [super init]) {
        [self locationData];
    }
    return self;
}

- (void)locationData
{
    [AppConfig saveProAndCityInfoWithPro:@"北京" city:@"北京"];
    
    INTULocationManager *mgr = [INTULocationManager sharedInstance];
    IMP_BLOCK_SELF(StartManager);
    [mgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        [block_self setupCityWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        
        if(status == 1){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求超时"];
            return;
        }
    }];
}

- (void)setupCityWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocationDegrees lati = latitude;
    CLLocationDegrees longi = longitude;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lati longitude:longi];
    
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error) {
            
            CLPlacemark *pm = [placemarks firstObject];
            
            if ([pm.name rangeOfString:@"市"].location != NSNotFound) {
                
                if ([pm.locality isEqualToString:@"上海市"]||[pm.locality isEqualToString:@"天津市"]||[pm.locality isEqualToString:@"北京市"]||[pm.locality isEqualToString:@"重庆市"])
                {
                    NSRange range = [pm.locality rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *citystr = [pm.locality substringToIndex:loc];

                    [AppConfig saveProAndCityInfoWithPro:citystr city:citystr];
                    
                }else{
                    
                    NSRange range = [pm.name rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *str = [pm.name substringToIndex:loc];
                    str = [str substringFromIndex:2];
                    
                    NSRange range1 = [str rangeOfString:@"省"];
                    int loc1 = (int)range1.location;
                    
                    if (range1.location != NSNotFound) {
                        NSString *pro = [str substringToIndex:loc1];
                        NSString *city = [str substringFromIndex:loc1+1];
                        
                        [AppConfig saveProAndCityInfoWithPro:pro city:city];
                        
                    }else if([str isEqualToString:@"广西壮族自治区桂林"]){
                        NSString * province = @"广西";
                        NSString *city = @"桂林";
                        
                        [AppConfig saveProAndCityInfoWithPro:province city:city];
                    }
                }
                
            }else{
                
                if ([pm.locality rangeOfString:@"市"].location != NSNotFound) {
                    NSRange range = [pm.locality rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *citystr = [pm.locality substringToIndex:loc];

                    [AppConfig saveProAndCityInfoWithPro:citystr city:citystr];
                    
                }else{
                    
                    [AppConfig saveProAndCityInfoWithPro:@"北京" city:@"北京"];

                }
            }
        }
    }];
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

@end
