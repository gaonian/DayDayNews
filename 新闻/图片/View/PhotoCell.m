//
//  PhotoCell.m
//  新闻
//
//  Created by gyh on 15/9/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PhotoCell.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"

@implementation PhotoCell

-(void)setPhoto:(Photo *)photo
{
    _photo = photo;
    
    //图片
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:photo.small_url] placeholderImage:nil];
    
    //文字
    self.titleLabel.text = photo.title;
    
    

}
@end
