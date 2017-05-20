//
//  AVMediaCacheModel.h
//  新闻
//
//  Created by SL on 20/05/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVMediaCacheModel : NSObject

//标题
@property (nonatomic, copy) NSString *title;
//文件存储路径
@property (nonatomic, copy) NSString *filePath;
//文件预览图片
@property (nonatomic, copy) NSString *imgUrl;
//文件播放总时长
@property (nonatomic, assign) CGFloat totalTime;
//文件大小
@property (nonatomic, assign) CGFloat totalDataLength;

@end
