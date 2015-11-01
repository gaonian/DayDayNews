//
//  HeaderView.m
//  citycontrol
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LocaHeaderView.h"
#import "CitiesGroup.h"

@interface LocaHeaderView()
@property (nonatomic , weak) UIButton *namebtn;


@end

@implementation LocaHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"header";
    LocaHeaderView *header = [tableview dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[LocaHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIButton *namebtn = [[UIButton alloc]init];

        [namebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        namebtn.titleLabel.font = [UIFont systemFontOfSize:15];
        // 设置按钮的内容左对齐
        namebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        namebtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);

        [self.contentView addSubview:namebtn];
        self.namebtn = namebtn;
        
        
    }
    return self;
}



-(void)setGroups:(CitiesGroup *)groups
{
    _groups = groups;
    
    [self.namebtn setTitle:groups.state forState:UIControlStateNormal];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.namebtn.frame = self.bounds;
    
}



@end
