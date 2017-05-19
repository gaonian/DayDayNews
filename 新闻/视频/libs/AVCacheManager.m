//
//  AVCacheManager.m
//  新闻
//
//  Created by SL on 19/05/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AVCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface AVCacheManager ()
@property (nonatomic, copy) NSString *diskCachePath;
@end

@implementation AVCacheManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id _sInstance;
    dispatch_once(&onceToken, ^{
        _sInstance = [[self alloc] init];
    });
    
    return _sInstance;
}


/*
 2017-05-19 13:28:28.728 新闻[13455:1536451] /Users/liu/Library/Developer/CoreSimulator/Devices/2FA46DEB-9C0D-4515-AA4E-4988B4C3BA28/data/Containers/Data/Application/61FA33C4-6B46-47ED-969C-332D4F3855FD/Documents/ComCacheMovie/c697b9b14e6d5ae3a1c2635cca1242bb.mp4
 2017-05-19 13:28:30.711 新闻[13455:1536451] /Users/liu/Library/Developer/CoreSimulator/Devices/2FA46DEB-9C0D-4515-AA4E-4988B4C3BA28/data/Containers/Data/Application/61FA33C4-6B46-47ED-969C-332D4F3855FD/Documents/temp.mp4
 (lldb)
 */
- (NSString *)getPathByFileName:(NSString *)fileName {
    NSString *md5Name = [AVCacheManager getMd5Name:fileName];
    NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:md5Name];
    NSLog(@"%@",filePath);
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *videoPath = [document stringByAppendingPathComponent:@"temp.mp4"];
    NSLog(@"%@",videoPath);
    return videoPath;
}

- (NSString *)diskCachePath {
    if (!_diskCachePath) {
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _diskCachePath =  [document stringByAppendingPathComponent:@"ComCacheMovie"];
//        _diskCachePath = document;
        NSFileManager *FM = [NSFileManager defaultManager];
        if (![FM fileExistsAtPath:_diskCachePath]) {
            [FM createFileAtPath:_diskCachePath contents:nil attributes:nil];
        }
    }
    return _diskCachePath;
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
