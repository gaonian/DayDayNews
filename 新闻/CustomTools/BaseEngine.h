//
//  BaseEngine.h
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEngine : NSObject

+ (instancetype)shareEngine;

- (void)runRequestWithPara:(NSMutableDictionary *)para
                      path:(NSString *)path
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(id error))failure;

@end
