//
//  VideoData.m
//  新闻
//
//  Created by gyh on 15/9/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "VideoData.h"
#import "NSDate+gyh.h"

@implementation VideoData
//2015-09-29 09:56:49
-(NSString *)ptime
{
    NSString *str1 = [_ptime substringToIndex:10];
    str1 = [str1 substringFromIndex:5];

    return str1;
}


@end
