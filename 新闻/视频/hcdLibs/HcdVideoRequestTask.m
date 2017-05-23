//
//  ____    ___   _        ___  _____  ____  ____  ____
// |    \  /   \ | T      /  _]/ ___/ /    T|    \|    \
// |  o  )Y     Y| |     /  [_(   \_ Y  o  ||  o  )  o  )
// |   _/ |  O  || l___ Y    _]\__  T|     ||   _/|   _/
// |  |   |     ||     T|   [_ /  \ ||  _  ||  |  |  |
// |  |   l     !|     ||     T\    ||  |  ||  |  |  |
// l__j    \___/ l_____jl_____j \___jl__j__jl__j  l__j
//
//
//	Powered by Polesapp.com
//
//
//  HcdVideoRequestTask.m
//  hcdCachePlayerDemo
//
//  Created by polesapp-hcd on 16/7/4.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdVideoRequestTask.h"
//#import "NSString+HCD.h"

@interface HcdVideoRequestTask()<NSURLConnectionDataDelegate, AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSURL           *url;
@property (nonatomic        ) NSUInteger      offset;

@property (nonatomic        ) NSUInteger      videoLength;
@property (nonatomic, strong) NSString        *mimeType;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableArray  *taskArr;

@property (nonatomic, assign) NSUInteger      downLoadingOffset;
@property (nonatomic, assign) BOOL            once;

@property (nonatomic, strong) NSFileHandle    *fileHandle;
@property (nonatomic, strong) NSString        *tempPath;

@end

@implementation HcdVideoRequestTask

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskArr = [NSMutableArray array];

        NSString *tmp = NSTemporaryDirectory();
        _tempPath = [tmp stringByAppendingPathComponent:@"temp.mp4"];
        NSFileManager *FM = [NSFileManager defaultManager];
        [FM removeItemAtPath:_tempPath error:nil];
        [FM createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    return self;
}

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset
{
    _url = url;
    _offset = offset;
    
    //如果建立第二次请求，先移除原来文件，再创建新的
    if (self.taskArr.count >= 1) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    
    _downLoadingOffset = 0;
    
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    if (offset > 0 && self.videoLength > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    }
    
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
    
}



- (void)cancel
{
    [self.connection cancel];
    
}


#pragma mark -  NSURLConnection Delegate Methods


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _isFinishLoad = NO;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    
    NSUInteger videoLength;
    
    if ([length integerValue] == 0) {
        videoLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        videoLength = [length integerValue];
    }
    
    self.videoLength = videoLength;
    self.mimeType = @"video/mp4";
    
    
    if ([self.delegate respondsToSelector:@selector(task:didReciveVideoLength:mimeType:)]) {
        [self.delegate task:self didReciveVideoLength:self.videoLength mimeType:self.mimeType];
    }
    
    [self.taskArr addObject:connection];
    
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    // 拼接文件总长度
    _downLoadingOffset += data.length;
    
    if ([self.delegate respondsToSelector:@selector(didReciveVideoDataWithTask:)]) {
        [self.delegate didReciveVideoDataWithTask:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading: %@", self.taskArr);
    
    if (self.taskArr.count < 2) {
        _isFinishLoad = YES;
        
//        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
//        components.scheme = @"http";
//        NSURL *playUrl = [components URL];
        //使用md5将请求url地址加密后作为缓存本地文件的文件名
//        NSString *md5File = [NSString stringWithFormat:@"%@.mp4", [self.filePath stringToMD5]];
        
//        NSLog(@"saveFileName:%@", md5File);
//        
//        //这里自己写需要保存数据的路径
//        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//        NSString *movePath =  [document stringByAppendingPathComponent:md5File];
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:movePath]) {
//            
//            [self movePath:_tempPath toPath:movePath];
//            
//        } else {
//            BOOL removeSuccess = [[NSFileManager defaultManager] removeItemAtPath:movePath error:nil];
//            if (removeSuccess) {
//                [self movePath:_tempPath toPath:movePath];
//            } else {
//                NSLog(@"cache failed");
//            }
//        }
        
        //这里自己写需要保存数据的路径
        NSFileManager *FM = [NSFileManager defaultManager];
        [FM removeItemAtPath:[[AVCacheManager sharedInstance] tempPath] error:nil];
        BOOL isSuccess = [FM copyItemAtPath:self.tempPath toPath:[[AVCacheManager sharedInstance] tempPath] error:nil];
        if (isSuccess) {
            NSLog(@"copyItem success");
            [FM moveItemAtPath:[[AVCacheManager sharedInstance] tempPath] toPath:self.filePath error:nil];
            NSLog(@">>>>>>>>>>>>>>>\n视频下载保存成功");
        }else{
            NSLog(@"copyItem fail");
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithTask:)]) {
        [self.delegate didFinishLoadingWithTask:self];
    }
    
}

- (void)movePath:(NSString *)path toPath:(NSString *)toPath {
    
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:nil];
    if (isSuccess) {
        [self clearData];
        NSLog(@"rename success");
    }else{
        NSLog(@"rename fail");
    }
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error.code == -1001 && !_once) {      //网络超时，重连一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self continueLoading];
        });
    }
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithTask:withError:)]) {
        [self.delegate didFailLoadingWithTask:self withError:error.code];
    }
    if (error.code == -1009) {
        NSLog(@"无网络连接");
    }
}


- (void)continueLoading
{
    _once = YES;
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)_downLoadingOffset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    
    
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
}

- (void)clearData
{
    [self.connection cancel];
    //移除文件
    [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
}

@end
