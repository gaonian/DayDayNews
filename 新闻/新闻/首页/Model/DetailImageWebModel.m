//
//  DetailImageWebModel.m
//  新闻
//
//  Created by gyh on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DetailImageWebModel.h"


@implementation DetailImageWebModel

+ (instancetype)detailImgWithDict:(NSDictionary *)dict
{
    DetailImageWebModel *imgModel = [[self alloc]init];
    imgModel.ref = dict[@"ref"];
    imgModel.pixel = dict[@"pixel"];
    imgModel.src = dict[@"src"];
    
    return imgModel;
}

@end
