//
//  CategoryView.h
//  新闻
//
//  Created by 范英强 on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIView
@property (nonatomic , copy) void(^SelectBlock)(NSString *tag, NSString *title);
@end
