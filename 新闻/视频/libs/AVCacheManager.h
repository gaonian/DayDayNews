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
