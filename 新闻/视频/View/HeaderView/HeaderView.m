//
//  HeaderView.m
//  新闻
//
//  Created by gyh on 15/9/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HeaderView.h"
#import "TabbarButton.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        TabbarButton *btn = [[TabbarButton alloc]init];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(10, 10, 50, 100);
//        [btn setImage:[UIImage imageNamed:@"qipa"] forState:UIControlStateNormal];
//        [btn setTitle:@"奇葩" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
    }
    return self;
}

-(void)btnClick:(TabbarButton *)btn
{
   // NSLog(@"%@",btn.titleLabel.text);
    if ([self.delegate respondsToSelector:@selector(btntitle:url:)]) {
        [self.delegate btntitle:btn.titleLabel.text url:btn.titleLabel.text];
        NSLog(@"%@",btn.titleLabel.text);
    }
}

@end
