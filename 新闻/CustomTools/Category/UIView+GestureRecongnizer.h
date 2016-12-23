//
//  UIView+GestureRecongnizer.h
//  Guru
//
//  Created by wtj on 16/7/19.
//  Copyright © 2016年 com.techwolf.guru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapActionBlock)(id obj);
@interface UIView (GestureRecongnizer)

@property (nonatomic, copy)TapActionBlock tapActionBlock;

- (void)addTapBlock:(TapActionBlock)tapAction;

@end
