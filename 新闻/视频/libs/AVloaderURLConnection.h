
/// 这个connenction的功能是把task缓存到本地的临时数据根据播放器需要的 offset和length去取数据并返回给播放器
/// 如果视频文件比较小，就没有必要存到本地，直接用一个变量存储即可
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVVideoRequestTask;

@protocol AVloaderURLConnectionDelegate <NSObject>

- (void)didFinishLoadingWithTask:(AVVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(AVVideoRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface AVloaderURLConnection : NSURLConnection <AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) AVVideoRequestTask *task;
@property (nonatomic, weak  ) id<AVloaderURLConnectionDelegate> delegate;
- (NSURL *)getSchemeVideoURL:(NSURL *)url;
@property (nonatomic, copy) NSString *filePath;

@end
