//
//  CitiesGroup.h
//  citycontrol
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitiesGroup : NSObject

@property (nonatomic , strong) NSArray *cities;
@property (nonatomic , copy) NSString *state;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;
@end
