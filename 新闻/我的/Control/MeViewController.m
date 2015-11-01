//
//  MeViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MeViewController.h"
#import "SDImageCache.h"

@interface MeViewController ()
@property (nonatomic , strong) NSString *clearCacheName;
@end

@implementation MeViewController

-(NSString *)clearCacheName
{
    if (!_clearCacheName) {
        
        float tmpSize = [[SDImageCache sharedImageCache]getSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fMB",tmpSize/(1024*1024)] : [NSString stringWithFormat:@"%.1fKB",tmpSize * 1024];
        _clearCacheName = clearCacheName;
        
    }
    return _clearCacheName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:self.clearCacheName forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)click
{
    [[SDImageCache sharedImageCache]clearDisk];
    
}

@end
