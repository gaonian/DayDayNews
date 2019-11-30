//
//  GYHCircleLoadingView.m
//  GYHPhotoLoadingView
//
//  Created by 范英强 on 16/7/13.
//  Copyright © 2016年 gyh. All rights reserved.
//

#import "GYHCircleLoadingView.h"

static const CGFloat kSize = 40.0f;
static const CGFloat kLineWidth = 3.0f;

@interface GYHCircleLoadingView ()
@property (nonatomic,assign) CGFloat          size;
@property (nonatomic,assign) CGFloat          lineWidth;
@property (nonatomic,strong) UIColor          *tintColor;
@property (nonatomic, weak) UILabel           *progressLabel;
@end

@implementation GYHCircleLoadingView

- (id)initWithViewFrame:(CGRect)frame
{
    return [self initWithViewFrame:frame tintColor:[UIColor whiteColor] size:kSize lineWidth:kLineWidth];
}

- (id)initWithViewFrame:(CGRect)frame tintColor:(UIColor *)tintColor size:(CGFloat)size lineWidth:(CGFloat)lineWidth{
    self = [super init];
    if (self) {
        self.frame = frame;
        _size = size;
        _lineWidth = lineWidth;
        _tintColor = tintColor;
    }
    return self;
}

#pragma mark - 设置动画效果
- (void)setupAnimation {
    self.layer.sublayers = nil;
    
    CGSize size = CGSizeMake(_size, _size);
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
    rotateAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    rotateAnimation.duration = 1.0f;
    rotateAnimation.repeatCount = HUGE_VALF;
    rotateAnimation.removedOnCompletion = NO;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width/2, size.height/2) radius:size.width/2 startAngle:2*M_PI endAngle:M_PI clockwise:YES];
    circle.path = circlePath.CGPath;
    circle.lineWidth = _lineWidth;
    circle.fillColor = nil;
    circle.strokeColor = _tintColor.CGColor;
    
    CAShapeLayer *circle1 = [CAShapeLayer layer];
    UIBezierPath *circlePath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width/2, size.height/2) radius:size.width/2 startAngle:M_PI endAngle:2*M_PI clockwise:YES];
    circle1.path = circlePath1.CGPath;
    circle1.lineWidth = _lineWidth;
    circle1.fillColor = nil;
    circle1.strokeColor = [UIColor grayColor].CGColor;
    
    CAShapeLayer *totalCircle = [CAShapeLayer layer];
    [totalCircle addSublayer:circle];
    [totalCircle addSublayer:circle1];
    
    totalCircle.frame = CGRectMake((self.layer.bounds.size.width - size.width)/2, (self.layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [totalCircle addAnimation:rotateAnimation forKey:@"animation"];
    [self.layer addSublayer:totalCircle];

    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(5, 10, 30, 20);
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.progressLabel = label;
}

- (void)setProgress:(CGFloat)progress
{
    if (_isShowProgress) {
        self.progressLabel.text = [NSString stringWithFormat:@"%.f%%",progress*100];
    }
}

- (void)setIsShowProgress:(BOOL)isShowProgress
{
    _isShowProgress = isShowProgress;
    self.progressLabel.hidden = !isShowProgress;
}


- (void)startAnimating {
    self.hidden = NO;
    if (!self.layer.sublayers) {
        [self setupAnimation];
    }
}

- (void)stopAnimating {
    [self.layer removeAllAnimations];
    self.hidden = YES;
    [self removeFromSuperview];
}


@end
