//
//  AVCacheManager.h
//  新闻
//
//  Created by SL on 19/05/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVCacheManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getPathByFileName:(NSString *)fileName;

@property (nonatomic, copy) NSString *tempPath;


- (NSString *)isExistLocalFile:(NSString *)file;

- (NSUInteger)getSize;

- (void)clearDisk;
@end

/*
Xcode8出现AQDefaultDevice (173): skipping input stream 0 0 0x0
 1.选择 Product -->Scheme-->Edit Scheme
 2.选择 Arguments
 3.在Environment Variables添加一个环境变量 OS_ACTIVITY_MODE 设置值为"disable"

 */
