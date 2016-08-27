//
//  GYHCircleProgressView.m
//  GYHPhotoLoadingView
//
//  Created by 范英强 on 16/7/13.
//  Copyright © 2016年 gyh. All rights reserved.
//

#import "GYHCircleProgressView.h"

@interface GYHCircleProgressView()
{
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;      //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
}
@end

@implementation GYHCircleProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;
    backGroundLayer.lineWidth = 3.0f;
    backGroundLayer.strokeColor = [UIColor grayColor].CGColor;
    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    backGroundLayer.path = backGroundBezierPath.CGPath;
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = nil;
    frontFillLayer.lineWidth = 3.0f;
    frontFillLayer.strokeColor = [UIColor redColor].CGColor;
    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:frontFillLayer];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    frontFillLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressTrackColor:(UIColor *)progressTrackColor
{
    backGroundLayer.strokeColor = progressTrackColor.CGColor;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2) radius:self.frame.size.width/2 startAngle:-M_PI_2 endAngle:-M_PI_2 + progressValue * M_PI * 2 clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
}

- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth
{
    frontFillLayer.lineWidth = progressStrokeWidth;
    backGroundLayer.lineWidth = progressStrokeWidth;
}


@end
