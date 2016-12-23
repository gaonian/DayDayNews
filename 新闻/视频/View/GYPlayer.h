//
//  GYPlayer.h
//  新闻
//
//  Created by 范英强 on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPlayer : UIView

///url
@property (nonatomic , strong) NSString *mp4_url;

- (void)removePlayer;
@end
