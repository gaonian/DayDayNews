
//
//  AddViewButton.m
//  机器人
//
//  Created by gyh on 15/5/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddViewButton.h"

@implementation AddViewButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置图片 文字居中
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

//设置自定义tabbar图片的尺寸
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imagew = contentRect.size.width;
    CGFloat imageH = contentRect.size.height *0.6;
    return CGRectMake(0, 0, imagew, imageH);
}

//设置自定义tabbar文字的尺寸
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}


@end
