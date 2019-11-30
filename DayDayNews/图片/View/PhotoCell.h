//
//  PhotoCell.h
//  新闻
//
//  Created by gyh on 15/9/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Photo;
@interface PhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic , strong) Photo *photo;

@end
