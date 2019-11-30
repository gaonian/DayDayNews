//
//  UIView+Corner.m
//  正确圆角设置方式
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UIView+Corner.h"

static NSString *DRCornerLayerName = @"DRCornerShapeLayer";

typedef NS_OPTIONS(NSUInteger, DRRoundCorner) {
    DRRoundCornerTop = (UIRectCornerTopLeft | UIRectCornerTopRight),
    DRRoundCornerBottom = (UIRectCornerBottomLeft | UIRectCornerBottomRight),
    DRRoundCornerAll = UIRectCornerAllCorners
};

@implementation UIView (Corner)

- (void)dr_roundingCorner:(DRRoundCorner)roundCorner radius:(CGFloat)radius backgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor {
    [self removeDRCorner];

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.name = DRCornerLayerName;
    UIRectCorner sysCorner = (UIRectCorner)roundCorner;
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:sysCorner cornerRadii:CGSizeMake(radius, radius)];
    [path  appendPath:cornerPath];
    //[path setUsesEvenOddFillRule:YES];
    shapeLayer.path = path.CGPath;
    /*
     字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部
     */
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = bgColor.CGColor;
    shapeLayer.strokeColor = bgColor.CGColor;
    if (borderColor) {
        //CGPathApply
        CGFloat cornerPathLength = lengthOfCGPath(roundCorner,radius,self.bounds.size);
        CGFloat totolPathLength = 2*(CGRectGetHeight(self.bounds)+CGRectGetWidth(self.bounds))+cornerPathLength;
        shapeLayer.strokeStart = (totolPathLength-cornerPathLength)/totolPathLength;
        shapeLayer.strokeEnd = 1.0;
        shapeLayer.strokeColor = borderColor.CGColor;
    }
    if ([self isKindOfClass:[UILabel class]]) {
        //UILabel 机制不一样的  UILabel 设置 text 为 中文 也会造成图层混合 (iOS8 之后UILabel的layer层改成了 _UILabelLayer 具体可阅读 http://www.jianshu.com/p/db6602413fa3 )
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.layer addSublayer:shapeLayer];
        });
        return;
    }
    [self.layer addSublayer:shapeLayer];
}

- (void)dr_roundingCorner:(DRRoundCorner)roundCorner radius:(CGFloat)radius backgroundColor:(UIColor *)bgColor {
    [self dr_roundingCorner:roundCorner radius:radius backgroundColor:bgColor borderColor:nil];
}

/**
 关于 CGPath 的 length 的计算请参看 http://www.mlsite.net/blog/?p=1312 与 http://stackoverflow.com/questions/6515158/get-info-about-a-cgpath-uibezierpath 在这里简单的计算就能满足要求因此不做过多讨论
 */
float lengthOfCGPath (DRRoundCorner roundingCorner,CGFloat radius,CGSize size) {
    CGFloat totolLength = 0.0;
    switch (roundingCorner) {
        case DRRoundCornerTop:
        case DRRoundCornerBottom:
            totolLength = 2*(size.width + size.height) - 4*radius + (M_PI * radius);
            break;
        case DRRoundCornerAll:
            totolLength = 2*(size.width + size.height) - 8*radius + (M_PI * radius)*2;
        default:
            break;
    }
    return totolLength;
}

- (void)dr_cornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor {
    [self dr_roundingCorner:DRRoundCornerAll radius:radius backgroundColor:bgColor];
}

- (void)dr_topCornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor {
    [self dr_roundingCorner:DRRoundCornerTop radius:radius backgroundColor:bgColor];
}

- (void)dr_bottomCornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor {
    [self dr_roundingCorner:DRRoundCornerBottom radius:radius backgroundColor:bgColor];
}
- (void)dr_cornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor {
    [self dr_roundingCorner:DRRoundCornerAll radius:radius backgroundColor:bgColor borderColor:borderColor];
}

-(void)removeDRCorner {
    if ([self hasDRCornered]) {
        CALayer *layer = nil;
        for (CALayer *subLayer in self.layer.sublayers) {
            if ([subLayer.name isEqualToString:DRCornerLayerName]) {
                layer = subLayer;
            }
        }
        [layer removeFromSuperlayer];
    }
}

- (BOOL)hasDRCornered {
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAShapeLayer class]] && [subLayer.name isEqualToString:DRCornerLayerName]) {
            return YES;
        }
    }
    return NO;
}

@end
