//
//  NSDate+gyh.m
//  微博
//
//  Created by gyh on 15-4-18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSDate+gyh.h"

@implementation NSDate (gyh)
/**
 *  是否为今天
 */
-(BOOL)isToday
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return(selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
-(BOOL)isYesterday
{
 
    NSDate *nowDate = [[NSDate date]dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

-(NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *str = [fmt stringFromDate:self];
    return [fmt dateFromString:str];
}

/**
 *  是否为今年
 */
-(BOOL)isThisYear
{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}




@end
