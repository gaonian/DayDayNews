//
//  TabbarButton.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

// 定义图片占据得尺寸
#define tabbarButtonRatio 0.6
//默认文字得颜色， ios6 ios7
#define tabbarButtonTitleColor [UIColor blackColor]
//按钮选中文字得颜色
#define tabbarButtonTitleSelectedColor [UIColor colorWithRed:219/255.0f green:86/255.0f blue:85/255.0f alpha:1]

#import "TabbarButton.h"

@implementation TabbarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片 文字居中
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor: tabbarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:tabbarButtonTitleSelectedColor forState:UIControlStateSelected];
    }
    
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}

// 设置图片和文字在按钮中得位置。
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imagew = contentRect.size.width;
    CGFloat imageH = contentRect.size.height *tabbarButtonRatio;
    return CGRectMake(0, 0, imagew, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *tabbarButtonRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}


-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    
}



@end
