//
//  AddView.m
//  机器人
//
//  Created by gyh on 15/5/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//


#define reuseIdentifier @"cell";

#import "AddView.h"
#import "AddViewButton.h"


@interface AddView()
@property(nonatomic,weak)AddViewButton *btn1;

@end

@implementation AddView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        [self setupButton];
        
    }
    return self;
}

/**
 *  设置按钮
 */
-(void)setupButton
{
    NSArray *titleArr = @[@"图片",@"拍照",@"小视频"];
    NSArray *imageArr = @[@"聊天图片",@"聊天拍照",@"聊天小视频"];
    for (int i = 0 ; i < 3; i ++) {
        CGFloat w = (SCREEN_WIDTH-40)/3;
        CGFloat x = 10 + i*(w+10);
        AddViewButton *btn1 = [[AddViewButton alloc]initWithFrame:CGRectMake(x, 20, w, w)];
        [btn1 setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btn1click:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn1];
        self.btn1 = btn1;
    }
}


-(void)btn1click:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Photo" object:btn.titleLabel.text];
}

@end
