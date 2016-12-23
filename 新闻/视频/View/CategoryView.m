//
//  CategoryView.m
//  新闻
//
//  Created by 范英强 on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CategoryView.h"
#import "TabbarButton.h"

@implementation CategoryView
{
    TabbarButton *btn;
}

- (instancetype)init {
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_WIDTH * 0.25);

        NSArray *array = @[@"奇葩",@"萌物",@"美女",@"精品"];
        NSArray *images = @[[UIImage imageNamed:@"qipa"],
                            [UIImage imageNamed:@"mengchong"],
                            [UIImage imageNamed:@"meinv"],
                            [UIImage imageNamed:@"jingpin"]
                            ];
        
        for (int index = 0; index < 4; index++) {
            btn = [[TabbarButton alloc]init];
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat btnW = SCREEN_WIDTH/4;
            CGFloat btnH = self.height - 5;
            CGFloat btnX = btnW * index - 1;
            CGFloat btnY = 0;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [btn setImage:images[index] forState:UIControlStateNormal];
            [btn setTitle:array[index] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = index;
            [self addSubview:btn];
        }
        for (int i = 1; i < 4; i++) {
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
            CGFloat lineW = 1;
            CGFloat lineH = btn.frame.size.height;
            CGFloat lineX = btn.frame.size.width * i;
            CGFloat lineY = btn.frame.origin.y;
            lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
            [self addSubview:lineView];
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    if (self.SelectBlock) {
        self.SelectBlock([NSString stringWithFormat:@"%ld",(long)btn.tag],title);
    }
}

@end
