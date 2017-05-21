
/// 这个task的功能是从网络请求数据，并把数据保存到本地的一个临时文件，网络请求结束的时候，如果数据完整，则把数据缓存到指定的路径，不完整就删除
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVVideoRequestTask;
@protocol AVVideoRequestTaskDelegate <NSObject>

- (void)task:(AVVideoRequestTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(AVVideoRequestTask *)task;
- (void)didFinishLoadingWithTask:(AVVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(AVVideoRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface AVVideoRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL                      *url;
@property (nonatomic, readonly        ) NSUInteger                 offset;

@property (nonatomic, readonly        ) NSUInteger                 videoLength;
@property (nonatomic, readonly        ) NSUInteger                 downLoadingOffset;
@property (nonatomic, strong, readonly) NSString                   * mimeType;
@property (nonatomic, assign)           BOOL                       isFinishLoad;

@property (nonatomic, weak            ) id <AVVideoRequestTaskDelegate> delegate;


- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

@property (nonatomic, copy) NSString *filePath;
@end
