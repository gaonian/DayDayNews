//
//  AVCacheManager.m
//  新闻
//
//  Created by SL on 19/05/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AVCacheManager.h"
#import <CommonCrypto/CommonDigest.h>
//#include <sys/param.h>
#include <sys/mount.h>

#define kComNewsAVCache "com.media.cache"

@interface AVCacheManager ()
@property (nonatomic, copy) NSString *diskCachePath;
@property (nonatomic, strong) NSFileManager *FM;
@property (nonatomic, copy) NSString *curType;
@property (nonatomic, strong, nonnull) dispatch_queue_t ioQueue;
@end

@implementation AVCacheManager {
    NSFileManager *_fileManager;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id _sInstance;
    dispatch_once(&onceToken, ^{
        _sInstance = [[self alloc] init];
    });
    return _sInstance;
}

- (id)init {
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
        //串行队列
        _ioQueue = dispatch_queue_create(kComNewsAVCache, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSString *)isExistLocalFile:(NSString *)file {
    NSString *localPath = [self getPathByFileName:file];
    if ([_fileManager fileExistsAtPath:localPath]) {
        return localPath;
    }
    return file;
}

/*
 此参数作用，视频下载完以后，移动到指定管理目录，为预防copy过程异常，设置中间对象，确认copy成功后，再次move更名为最终对象
 */
- (NSString *)tempPath {
    //文件类型不唯一
//    NSString *tmp = NSTemporaryDirectory();
    NSString *tempName = [NSString stringWithFormat:@"temp.%@",self.curType];
    _tempPath = [[AVCacheManager sharedInstance] getPathByFileName:tempName];
    
    return _tempPath;
}

- (NSString *)getPathByFileName:(NSString *)fileName {
    NSString *md5Name = [AVCacheManager getMd5Name:fileName];
    NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:md5Name];
    return filePath;
}

/*
 三个目录：
 Documents
 Library [Caches]
 tmp
 
 NSString *Documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
 
 NSString *Caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
 
 NSString *tmp = NSTemporaryDirectory();
 */
- (NSString *)diskCachePath {
    //cache目录唯一
    if (!_diskCachePath) {
        NSString *Caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        _diskCachePath =  [Caches stringByAppendingPathComponent:@kComNewsAVCache];
        if (![_fileManager fileExistsAtPath:_diskCachePath]) {
            [_fileManager createDirectoryAtPath:self.diskCachePath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:NULL];
        }
    }
    return _diskCachePath;
}

- (NSUInteger)getSize {
    NSLog(@"%@",self.diskCachePath);
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (void)clearDisk {
    //串行队列，异步执行
    dispatch_async(self.ioQueue, ^{
        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskCachePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:NULL];
    });
}

#pragma mark - tools

+ (NSString *)getMd5Name:(NSString *)fileName {
    NSString *md5 = [AVCacheManager md5:fileName];
    NSString *type = [AVCacheManager getFileType:fileName];
    NSString *md5Name = [NSString stringWithFormat:@"%@.%@",md5,type];
    return md5Name;
}

+ (NSString *)getFileType:(NSString *)fileName {
    NSArray *textArray = [fileName componentsSeparatedByString:@"."];
    NSString *type = [textArray lastObject];
    [AVCacheManager sharedInstance].curType = type;
    return type;
}

+ (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result copy];
}

- (unsigned long long)getDiskFreeSize{
    struct statfs buf;
    unsigned long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
}

@end
