//
//  LoginView.m
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginView.h"
#import "TabbarButton.h"

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UIButton *btn = [[UIButton alloc]initWithFrame:self.bounds];
        btn.backgroundColor = RGBA(0, 0, 0, 0.8);
        [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        CGFloat w = SCREEN_WIDTH - 80;
        CGFloat h = 0.6 * w;
        CGFloat x = SCREEN_WIDTH/2 - w/2;
        CGFloat y = SCREEN_HEIGHT/2 - h/2;
        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        backV.backgroundColor = RGBA(246, 246, 246, 1);
        [self addSubview:backV];
     
        UIButton *cancelB = [[UIButton alloc]init];
        cancelB.frame = CGRectMake(backV.width - 10 - 50, 10, 50, 10);
        [cancelB setTitle:@"取消" forState:UIControlStateNormal];
        [cancelB addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [cancelB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelB.titleLabel.font = [UIFont systemFontOfSize:14];
        [backV addSubview:cancelB];

        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor grayColor];
        lineV.frame = CGRectMake(0, CGRectGetMaxY(cancelB.frame)+10, backV.width, 1);
        [backV addSubview:lineV];

        NSArray *tarray = @[@"QQ",@"微信",@"微博"];
        NSArray *imageArray = @[@"登录QQ",@"登录微信",@"登录微博"];
        CGFloat hight = 80;
        CGFloat Y = (backV.height - CGRectGetMaxY(lineV.frame))/2-10;
        for (int i = 0; i < 3; i++) {
            TabbarButton *btn = [[TabbarButton alloc]init];
            CGFloat w = (backV.width - 40)/3;
            CGFloat x = 20+i*w;
            btn.frame = CGRectMake(x, Y, w, hight);
            [btn setTitle:tarray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [backV addSubview:btn];
            [btn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return self;
}


- (void)show
{
    [theWindow addSubview:self];
}

- (void)removeView
{
    [self removeFromSuperview];
}

- (void)loginClick:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QQLogin" object:title];
    [self removeView];
}

@end
