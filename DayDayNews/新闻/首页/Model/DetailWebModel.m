//
//  DetailWebModel.m
//  新闻
//
//  Created by gyh on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DetailWebModel.h"
#import "DetailImageWebModel.h"

@implementation DetailWebModel

+ (instancetype)detailWithDict:(NSDictionary *)dict
{
    DetailWebModel *detail = [[self alloc]init];
    detail.title = dict[@"title"];
    detail.ptime = dict[@"ptime"];
    detail.body = dict[@"body"];
    
    NSArray *imgArray = dict[@"img"];
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:imgArray.count];
    
    for (NSDictionary *dict in imgArray) {
        DetailImageWebModel *imgModel = [DetailImageWebModel detailImgWithDict:dict];
        [temArray addObject:imgModel];
    }
    detail.img = temArray;
    
    return detail;
}

@end
