//
//  CycleBannerView.h
//
//  Created by 范英强 on 2016/11/17.
//  Copyright © 2016年 gyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CycleScrollViewPageContolAlimentLeft,     //pageControl的控件
    CycleScrollViewPageContolAlimentCenter,
    CycleScrollViewPageContolAlimentRight
} CycleScrollViewPageContolAliment;


@interface CycleBannerView : UIView

///点击回调 0.1.2.3.4
@property (nonatomic, copy) void (^clickItemBlock)(NSInteger currentIndex);

///图片数组
@property (nonatomic, strong) NSArray *         aryImg;
///文字数组
@property (nonatomic, strong) NSArray *         aryText;

///是否自动滚动,默认Yes
@property (nonatomic) BOOL                      autoScroll;
///是否显示分页控件 默认Yes
@property (nonatomic) BOOL                      showPageControl;
///自动滚动间隔时间,默认5s
@property (nonatomic) CGFloat                   autoScrollTimeInterval;
///分页控件位置 默认居右
@property (nonatomic) CycleScrollViewPageContolAliment pageControlAliment;
///当前分页控件的颜色
@property (nonatomic, strong) UIColor *         currentColor;
///其他未选中分页控件的颜色
@property (nonatomic, strong) UIColor *         otherColor;
///分页控件背景颜色
@property (nonatomic, strong) UIColor *         bgColor;
///分页控件背景,如果为图片，则用此方法
@property (nonatomic, strong) UIImage *         bgImg;




@end
