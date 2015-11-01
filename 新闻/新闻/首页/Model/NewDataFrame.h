
//  PhotoDataFrame.h
//  新闻
//
//  Created by gyh on 15/9/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NewData;
@interface NewDataFrame : NSObject
@property (nonatomic , strong) NewData *NewData;

@property (nonatomic , assign) CGRect descriptionF;
@property (nonatomic , assign) CGRect picUrlF;
@property (nonatomic , assign) CGRect titleF;
@property (nonatomic , assign) CGRect urlF;
@property (nonatomic , assign) CGRect ctimeF;

@property (nonatomic , assign) CGFloat cellH;

@end
