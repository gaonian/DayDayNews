//
//  HeaderView.h
//  新闻
//
//  Created by gyh on 15/9/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabbarButton;
@protocol ButtonClickDelegate<NSObject>

-(void)btntitle:(NSString *)btntitle url:(NSString *)url;
@end

@interface HeaderView : UIView

@property (nonatomic , weak) id<ButtonClickDelegate> delegate;


@end
