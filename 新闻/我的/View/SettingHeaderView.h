//
//  SettingHeaderView.h
//  新闻
//
//  Created by gyh on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate <NSObject>

- (void)LoginBtnClck:(NSString *)str;

@end

@interface SettingHeaderView : UIView

@property (nonatomic , weak) UIImageView *photoimageV;   //头像
@property (nonatomic , weak) UILabel *nameL;         //昵称

@property (nonatomic , weak) id<HeaderViewDelegate> delegate;

@end
