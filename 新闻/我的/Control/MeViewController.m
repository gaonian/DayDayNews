//
//  MeViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MeViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SettingHeaderView.h"

#import "SettingGroup.h"
#import "SettingCell.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "SettingLabelItem.h"

#import "TabbarButton.h"


@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderViewDelegate,UIScrollViewDelegate>

@property (nonatomic , strong) NSString *clearCacheName;

@property (nonatomic , strong) NSMutableArray *arrays;

@property (nonatomic , strong) UIView *fenxiangview;

@property (nonatomic , weak) UIView *headerview;
@property (nonatomic , weak) UITableView *tableview;

@end

@implementation MeViewController

- (NSMutableArray *)arrays
{
    if (!_arrays) {
        _arrays = [NSMutableArray array];
    }
    return _arrays;
}

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
    
    SettingHeaderView *headerview = [[SettingHeaderView alloc]init];
    headerview.delegate = self;
    self.headerview = headerview;

    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.tableHeaderView = headerview;
    self.tableview = tableview;

    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}

-(void)setupGroup0
{
    SettingItem *shoucang = [SettingArrowItem itemWithItem:@"MorePush" title:@"收藏" VcClass:nil];
    SettingItem *MorePush = [SettingArrowItem itemWithItem:@"MorePush" title:@"推送和提醒" VcClass:nil];
    SettingItem *handShake = [SettingSwitchItem itemWithItem:@"handShake" title:@"摇一摇机选"];
    SettingItem *soundEffect = [SettingSwitchItem itemWithItem:@"sound_Effect" title:@"声音效果"];
    
    SettingGroup *group0 = [[SettingGroup alloc]init];
    
    group0.items = @[shoucang,MorePush,handShake,soundEffect];
    [self.arrays addObject:group0];
}

-(void)setupGroup1
{
    SettingItem *MoreUpdate = [SettingArrowItem itemWithItem:@"MoreUpdate" title:@"检查新版本"];
    
    MoreUpdate.option = ^{
        
    };
    
    SettingItem *MoreHelp = [SettingArrowItem itemWithItem:@"MoreHelp" title:@"帮助" VcClass:nil];
    SettingItem *MoreShare = [SettingArrowItem itemWithItem:@"MoreShare" title:@"分享" VcClass:nil];
    
    SettingGroup *group1 = [[SettingGroup alloc]init];
    group1.items = @[MoreUpdate,MoreHelp,MoreShare];
    [self.arrays addObject:group1];
}

-(void)setupGroup2
{
    SettingItem *MoreHelp = [SettingArrowItem itemWithItem:@"MoreHelp" title:@"帮助与反馈" VcClass:nil];
    SettingItem *MoreShare = [SettingArrowItem itemWithItem:@"MoreShare" title:@"分享给好友" VcClass:nil];
    SettingItem *pingfen = [SettingArrowItem itemWithItem:@"MoreHelp" title:@"给我打分" VcClass:nil];
    SettingItem *MoreAbout = [SettingArrowItem itemWithItem:@"MoreAbout" title:@"关于" VcClass:nil];
    
    SettingGroup *group1 = [[SettingGroup alloc]init];
    group1.items = @[MoreHelp,MoreShare,pingfen,MoreAbout];
    [self.arrays addObject:group1];
}



#pragma mark - tableview代理数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingGroup *group = self.arrays[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    SettingCell *cell = [SettingCell cellWithTableView:tableView];
    
    SettingGroup *group = self.arrays[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //2.模型数据
    SettingGroup *group = self.arrays[indexPath.section];
    SettingItem *item = group.items[indexPath.row];
    
    if ([item isKindOfClass:[SettingArrowItem class]]) {
        SettingArrowItem *arrowItem = (SettingArrowItem *)item;
        if (arrowItem.VcClass == nil) return;
        
        UIViewController *vc = [[arrowItem.VcClass alloc]init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}





#pragma mark - 登陆
- (void)LoginBtnClck:(NSString *)str
{
        if (self.fenxiangview != nil) {
            [self cancelClick];
        }
        CGFloat w = SCREEN_WIDTH - 80;
        CGFloat h = 0.6 * w;
        CGFloat x = SCREEN_WIDTH/2 - w/2;
        CGFloat y = SCREEN_HEIGHT/2 - h/2;
        UIView *fenxiangview = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        fenxiangview.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        [self.view addSubview:fenxiangview];
        self.fenxiangview = fenxiangview;
        [fenxiangview.layer setBorderWidth:2];
        [fenxiangview.layer setBorderColor:[UIColor redColor].CGColor];
        
        UIButton *cancelB = [[UIButton alloc]init];
        cancelB.frame = CGRectMake(fenxiangview.frame.size.width - 10 - 50, 10, 50, 10);
        [cancelB setTitle:@"取消" forState:UIControlStateNormal];
        [cancelB addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelB.titleLabel.font = [UIFont systemFontOfSize:14];
        [fenxiangview addSubview:cancelB];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor grayColor];
        lineV.frame = CGRectMake(0, CGRectGetMaxY(cancelB.frame)+10, fenxiangview.frame.size.width, 1);
        [fenxiangview addSubview:lineV];
        
        NSArray *tarray = @[@"QQ",@"微信",@"微博"];
        NSArray *imageArray = @[@"登录QQ",@"登录微信",@"登录微博"];
        CGFloat hight = 80;
        CGFloat Y = (fenxiangview.frame.size.height - CGRectGetMaxY(lineV.frame))/2-10;
        for (int i = 0; i < 3; i++) {
            TabbarButton *btn = [[TabbarButton alloc]init];
            CGFloat w = (fenxiangview.frame.size.width - 40)/3;
            CGFloat x = 20+i*w;
            btn.frame = CGRectMake(x, Y, w, hight);
            [btn setTitle:tarray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [fenxiangview addSubview:btn];
            [btn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        }
}

- (void)loginClick:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QQLogin" object:title];
    [self cancelClick];
}

- (void)cancelClick
{
    [self.fenxiangview removeFromSuperview];
    self.fenxiangview = nil;
}


#pragma mark - 计算偏移量控制状态栏的颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat hey = CGRectGetMaxY(self.headerview.frame);
    if (y <= -30 || y >= hey-40) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}





























- (void)click
{
    [[SDImageCache sharedImageCache]clearDisk];
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableview.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableview.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
