//
//  ShareManager.h
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject


+ (instancetype)sharedInstance;

- (void)shareWeiboWithTitle:(NSString *)title images:(UIImage *)image dismissBlock:(void(^)())dismissBlock;

@end
