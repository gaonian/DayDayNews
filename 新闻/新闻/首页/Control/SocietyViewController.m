//
//  SocietyViewController.m
//  新闻
//
//  Created by gyh on 15/9/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SocietyViewController.h"
#import "testViewController.h"
#import "NewTableViewCell.h"
#import "NewData.h"
#import "TopData.h"
#import "NewDataFrame.h"
#import "CycleBannerView.h"
#import "TopViewController.h"
#import "TabbarView.h"

#import "DataModel.h"
#import "NewsCell.h"
#import "ImagesCell.h"
#import "BigImageCell.h"
#import "TopCell.h"

#import "DetailWebViewController.h"
#import "DataBase.h"
#import "NSDate+gyh.h"

@interface SocietyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *totalArray;
@property (nonatomic , strong) CycleBannerView *bannerView;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *imagesArray;

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , assign) int page;

@end

@implementation SocietyViewController

- (NSMutableArray *)totalArray
{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
- (NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}
- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initBannerView];
    //请求滚动数据
    [self initTopNet];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:@"新闻" object:nil];
}

- (void)mynotification
{
    [self.tableview.header beginRefreshing];
}

- (void)initTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(SocietyViewController);
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        block_self.page = 0;
        [block_self requestNet:1];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    [header beginRefreshing];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self requestNet:2];
    }];
    
    ThemeManager *manager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [manager themeColor];
}


- (void)initBannerView
{
    CycleBannerView *bannerView = [[CycleBannerView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 0.55)];
    bannerView.bgImg = [UIImage imageNamed:@"shadow.png"];
    
    IMP_BLOCK_SELF(SocietyViewController);
    bannerView.clickItemBlock = ^(NSInteger index) {
        
        TopData *data = block_self.topArray[index];
        NSString *url1 = [data.url substringFromIndex:4];
        url1 = [url1 substringToIndex:4];
        NSString *url2 = [data.url substringFromIndex:9];
        
        url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
        TopViewController *topVC = [[TopViewController alloc]init];
        topVC.url = url2;
        [block_self.navigationController pushViewController:topVC animated:YES];
    };
    self.tableview.tableHeaderView = bannerView;
    self.bannerView = bannerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    
    DataModel *newsModel = self.totalArray[indexPath.row];
    
    NSString *ID = [NewsCell idForRow:newsModel];
    
    if ([ID isEqualToString:@"NewsCell"]) {
        
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
            cell.lblTitle.textColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.lblTitle.textColor = [UIColor blackColor];
        }
        cell.dataModel = newsModel;
        return cell;
        
    }else if ([ID isEqualToString:@"ImagesCell"]){
        ImagesCell *cell = [ImagesCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.dataModel = newsModel;
        return cell;
    }else if ([ID isEqualToString:@"TopImageCell"]){
        
        TopCell *cell = [TopCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
        
    }else if([ID isEqualToString:@"TopTxtCell"]){
        
        TopCell *cell = [TopCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
        
    }else{
        BigImageCell *cell = [BigImageCell cellWithTableView:tableView];
        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.dataModel = newsModel;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *newsModel = self.totalArray[indexPath.row];
    
    CGFloat rowHeight = [NewsCell heightForRow:newsModel];

    return rowHeight;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DataModel *data = self.totalArray[indexPath.row];
    
    NSString *ID = [NewsCell idForRow:data];
    
    if ([ID isEqualToString:@"NewsCell"]) {
        
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.dataModel = self.totalArray[indexPath.row];
        detailVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([ID isEqualToString:@"ImagesCell"]){
        
        NSString *url1 = [data.photosetID substringFromIndex:4];
        url1 = [url1 substringToIndex:4];
        NSString *url2 = [data.photosetID substringFromIndex:9];
        DLog(@"%@,%@",url1,url2);
        
        url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
        TopViewController *topVC = [[TopViewController alloc]init];
        topVC.url = url2;
        [self.navigationController pushViewController:topVC animated:YES];
        
    }else if ([ID isEqualToString:@"TopImageCell"]){
    }else{
        
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.dataModel = self.totalArray[indexPath.row];
        detailVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailVC animated:YES];

    }

}


- (void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [defaultManager themeColor];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.tableview reloadData];
}


#pragma mark 网络请求

- (void)initTopNet
{
    IMP_BLOCK_SELF(SocietyViewController);    
    [[BaseEngine shareEngine] runRequestWithPara:nil path:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-10.html" success:^(id responseObject) {
        
        NSArray *dataarray = [TopData objectArrayWithKeyValuesArray:responseObject[@"T1348647853363"][0][@"ads"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *topArray = [NSMutableArray array];
        for (TopData *data in dataarray) {
            [topArray addObject:data];
            [statusFrameArray addObject:data.imgsrc];
            [titleArray addObject:data.title];
        }
        [block_self.topArray addObjectsFromArray:topArray];
        [block_self.imagesArray addObjectsFromArray:statusFrameArray];
        [block_self.titleArray addObjectsFromArray:titleArray];
        
        block_self.bannerView.aryImg = [block_self.imagesArray copy];
        block_self.bannerView.aryText = [block_self.titleArray copy];
        
    } failure:^(id error) {
        
    }];
}


-(void)requestNet:(int)type
{
    IMP_BLOCK_SELF(SocietyViewController);
    NSString *urlstr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-20.html",self.page];
    
    [[BaseEngine shareEngine] runRequestWithPara:nil path:urlstr success:^(id responseObject) {
        
        NSArray *temArray = responseObject[@"T1348647853363"];
        NSArray *arrayM = [DataModel objectArrayWithKeyValuesArray:temArray];
        NSMutableArray *statusArray = [NSMutableArray array];
        for (DataModel *data in arrayM) {
            [statusArray addObject:data];
        }
        
        if (type == 1) {
            block_self.totalArray = statusArray;
        }else{
            [block_self.totalArray addObjectsFromArray:statusArray];
        }
        [block_self.tableview reloadData];
        block_self.page += 20;
        
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];

    } failure:^(id error) {
        if (error) {
            DLog(@"%@",error);
        }
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];

    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
