//
//  PullDownCell.m
//  新闻
//
//  Created by gyh on 16/8/27.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "PullDownCell.h"

@interface PullDownCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbtitle;

@end

@implementation PullDownCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.img.layer.cornerRadius = self.img.width/2;
    self.img.layer.masksToBounds = YES;
}

- (void)setDataWithItem:(PullDownItem *)item
{
    self.img.image = item.icon;
    self.lbtitle.text = item.title;
}

@end
