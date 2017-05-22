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
//  HcdVideoRequestTask.h
//  hcdCachePlayerDemo
//
//  Created by polesapp-hcd on 16/7/4.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class HcdVideoRequestTask;

@protocol HcdVideoRequestTaskDelegate <NSObject>

- (void)task:(HcdVideoRequestTask *)task didReciveVideoLength:(NSUInteger)videoLength mimeType:(NSString *)mimeType;
- (void)didReciveVideoDataWithTask:(HcdVideoRequestTask *)task;
- (void)didFinishLoadingWithTask:(HcdVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(HcdVideoRequestTask *)task withError:(NSInteger)errorCode;

@end

@interface HcdVideoRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL         *url;
@property (nonatomic, readonly)         NSUInteger    offset;

@property (nonatomic, readonly)         NSUInteger    videoLength;
@property (nonatomic, readonly)         NSUInteger    downLoadingOffset;
@property (nonatomic, readonly)         NSString      *mimeType;
@property (nonatomic, assign)           BOOL          isFinishLoad;

@property (nonatomic, weak)             id<HcdVideoRequestTaskDelegate> delegate;

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;

@property (nonatomic, copy) NSString *filePath;

@end
