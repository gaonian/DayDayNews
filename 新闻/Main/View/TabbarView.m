//
//  TabbarView.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TabbarView.h"
#import "TabbarButton.h"

@interface TabbarView()
@property(nonatomic,weak)TabbarButton *selectedButton;
@property (nonatomic , weak) TabbarButton *tabarbutton;

@end

@implementation TabbarView

static int i = 0;


-(void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    
    //创建按钮
    TabbarButton *button = [[TabbarButton alloc]init];
    [self addSubview:button];
    self.tabarbutton = button;
    
    //设置
    button.item = item;
    
    //监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    //默认选中第一个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

-(void)buttonClick:(TabbarButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(tabbar:didselectedButtonFrom:to:)]) {
        [self.delegate tabbar:self didselectedButtonFrom:(int)self.selectedButton.tag to:(int)btn.tag];
    }
    
    if (btn.tag == self.selectedButton.tag) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:btn.titleLabel.text object:nil];
    }

    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //自定义按钮得大小
    CGFloat  buttonW = self.frame.size.width/self.subviews.count;
    CGFloat  buttonY = 0;
    CGFloat  buttonH = self.frame.size.height;
    
    for (int index = 0; index<self.subviews.count; index++) {
        
        //取出系统原来tabbar上面得按钮
        TabbarButton *button = self.subviews[index];
        
        CGFloat  buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //设置按钮得tag值
        button.tag = index;
    }
}


@end
