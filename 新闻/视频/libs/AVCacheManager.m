//
//  AVCacheManager.m
//  新闻
//
//  Created by SL on 19/05/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AVCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

//const NSString *kComNewsAVCache = @"com.news.avcache";
#define kComNewsAVCache "com.news.avcache"

@interface AVCacheManager ()
@property (nonatomic, copy) NSString *diskCachePath;
@property (nonatomic, strong) NSFileManager *FM;
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

- (NSString *)tempPath {
    if (!_tempPath) {
        _tempPath = [[AVCacheManager sharedInstance] getPathByFileName:@"temp.mp4"];
    }
    return _tempPath;
}

- (NSString *)getPathByFileName:(NSString *)fileName {
    NSString *md5Name = [AVCacheManager getMd5Name:fileName];
    NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:md5Name];
    return filePath;
}

- (NSString *)diskCachePath {
    if (!_diskCachePath) {
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _diskCachePath =  [document stringByAppendingPathComponent:@kComNewsAVCache];
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
    __block NSUInteger size = 0;
    dispatch_queue_t queue = dispatch_queue_create(kComNewsAVCache, DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
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
    dispatch_queue_t queue = dispatch_queue_create(kComNewsAVCache, DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
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

@end
