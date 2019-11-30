//
//  GYHCircleLoadingView.h
//  GYHPhotoLoadingView
//
//  Created by 范英强 on 16/7/13.
//  Copyright © 2016年 gyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHCircleLoadingView : UIView

/**
 *  初始化设置 默认size为40，线宽为3,如果不需要修改，则调用
 *  第一个方法，直接设置view的frame即可。如果需要修改，则调用第二个方法，设置颜色，宽度，尺寸
 */
- (id)initWithViewFrame:(CGRect)frame;
- (id)initWithViewFrame:(CGRect)frame tintColor:(UIColor *)tintColor size:(CGFloat)size lineWidth:(CGFloat)lineWidth;

/**
 *  进度
 */
@property (nonatomic) CGFloat                 progress;
@property (nonatomic) BOOL                    isShowProgress;   //是否展示进度

/**
 *  开始动画，初始化完成之后就可以调用start
 */
- (void)startAnimating;
/**
 *  结束动画，内部已经隐藏视图，移除动画了，不需要外部再次设置
 */
- (void)stopAnimating;

@end
