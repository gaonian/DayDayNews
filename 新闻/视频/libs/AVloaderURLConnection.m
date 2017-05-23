
#import "AVloaderURLConnection.h"
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AVVideoRequestTask.h"

@interface AVloaderURLConnection ()<AVVideoRequestTaskDelegate>

@property (nonatomic, strong) NSMutableArray *pendingRequests;
@property (nonatomic, copy  ) NSString       *videoPath;

@end

@implementation AVloaderURLConnection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pendingRequests = [NSMutableArray array];
        
//        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//        _videoPath = [document stringByAppendingPathComponent:@"temp.mp4"];
        NSString *tmp = NSTemporaryDirectory();
        _videoPath = [tmp stringByAppendingPathComponent:@"temp.mp4"];

    }
    return self;
}

#pragma mark - AVAssetResourceLoaderDelegate

/**
 *  必须返回Yes，如果返回NO，则resourceLoader将会加载出现故障的数据
 *  这里会出现很多个loadingRequest请求， 需要为每一次请求作出处理
 *  @param resourceLoader 资源管理器
 *  @param loadingRequest 每一小块数据的请求
 *
 */
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.pendingRequests addObject:loadingRequest];
    [self dealWithLoadingRequest:loadingRequest];
    NSLog(@"resourceLoader: %@", loadingRequest);
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.pendingRequests removeObject:loadingRequest];
    
}

- (NSURL *)getSchemeVideoURL:(NSURL *)url
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

#pragma mark - AVVideoRequestTaskDelegate
- (void)task:(AVVideoRequestTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType
{
    NSLog(@"didReceiveVideoLength: %lu", (unsigned long)ideoLength);
}
- (void)didReceiveVideoDataWithTask:(AVVideoRequestTask *)task
{
    [self processPendingRequests];
    
}
- (void)didFinishLoadingWithTask:(AVVideoRequestTask *)task
{
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithTask:)]) {
        [self.delegate didFinishLoadingWithTask:task];
    }
}
- (void)didFailLoadingWithTask:(AVVideoRequestTask *)task WithError:(NSInteger)errorCode
{
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithTask:WithError:)]) {
        [self.delegate didFailLoadingWithTask:task WithError:errorCode];
    }
}

#pragma mark - AVURLAsset resource loader methods

- (void)dealWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSURL *interceptedURL = [loadingRequest.request URL];
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
    
    if (self.task.downLoadingOffset > 0) {
        [self processPendingRequests];
    }
    
    if (!self.task) {
        self.task = [[AVVideoRequestTask alloc] init];
        self.task.filePath = self.filePath;
        self.task.delegate = self;
        [self.task setUrl:interceptedURL offset:0];
    } else {
        // 如果新的rang的起始位置比当前缓存的位置还大300k，则重新按照range请求数据
        if (self.task.offset + self.task.downLoadingOffset + 1024 * 300 < range.location ||
            // 如果往回拖也重新请求
            range.location < self.task.offset) {
            [self.task setUrl:interceptedURL offset:range.location];
        }
    }
}

- (void)processPendingRequests
{
    NSMutableArray *requestsCompleted = [NSMutableArray array];  //请求完成的数组
    //每次下载一块数据都是一次请求，把这些请求放到数组，遍历数组
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests)
    {
        [self fillInContentInformation:loadingRequest.contentInformationRequest]; //对每次请求加上长度，文件类型等信息
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest.dataRequest]; //判断此次请求的数据是否处理完全
        
        if (didRespondCompletely) {
            [requestsCompleted addObject:loadingRequest];  //如果完整，把此次请求放进 请求完成的数组
            [loadingRequest finishLoading];
        }
    }
    [self.pendingRequests removeObjectsInArray:requestsCompleted];   //在所有请求的数组中移除已经完成的
}

- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
{
    NSString *mimeType = self.task.mimeType;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentType = CFBridgingRelease(contentType);
    contentInformationRequest.contentLength = self.task.videoLength;
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
    long long startOffset = dataRequest.requestedOffset;
    if (dataRequest.currentOffset != 0) {
        startOffset = dataRequest.currentOffset;
    }
    if ((self.task.offset + self.task.downLoadingOffset) < startOffset) {
        //NSLog(@"NO DATA FOR REQUEST");
        return NO;
    }
    if (startOffset < self.task.offset) {
        return NO;
    }
    
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.videoPath] options:NSDataReadingMappedIfSafe error:nil];
    // This is the total data we have from startOffset to whatever has been downloaded so far
    NSUInteger unreadBytes = self.task.downLoadingOffset - ((NSInteger)startOffset - self.task.offset);
    // Respond with whatever is available if we can't satisfy the request fully yet
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    //读取数据并填充到loadingRequest
    [dataRequest respondWithData:[filedata subdataWithRange:NSMakeRange((NSUInteger)startOffset- self.task.offset, (NSUInteger)numberOfBytesToRespondWith)]];
    
    long long endOffset = startOffset + dataRequest.requestedLength;
    BOOL didRespondFully = (self.task.offset + self.task.downLoadingOffset) >= endOffset;
    
    return didRespondFully;
}


@end
