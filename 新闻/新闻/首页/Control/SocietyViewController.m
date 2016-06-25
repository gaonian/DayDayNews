//
//  SocietyViewController.m
//  新闻
//
//  Created by gyh on 15/9/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)


#import "SocietyViewController.h"
#import "testViewController.h"
#import "AFNetworking.h"
#import "NewTableViewCell.h"
#import "MJExtension.h"
#import "NewData.h"
#import "TopData.h"
#import "NewDataFrame.h"
#import "MJRefresh.h"
#import "SDCycleScrollView.h"
#import "TopViewController.h"
#import "MBProgressHUD+MJ.h"
#import "TabbarView.h"

#import "DataModel.h"
#import "NewsCell.h"
#import "ImagesCell.h"
#import "BigImageCell.h"
#import "TopCell.h"

#import "DetailWebViewController.h"
#import "DataBase.h"    //数据库
#import "NSDate+gyh.h"

@interface SocietyViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TabbarViewDelegate>
@property (nonatomic , strong) NSMutableArray *totalArray;
@property (nonatomic , strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *imagesArray;

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , assign) int page;

@end

@implementation SocietyViewController

-(NSMutableArray *)totalArray
{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
-(NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
-(NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    //请求滚动数据
    [self initTopNet];
    
    [self setupRefreshView];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:@"新闻" object:nil];
}



-(void)mynotification
{
    [self.tableview.header beginRefreshing];
}

-(void)initTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    ThemeManager *manager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [manager themeColor];
}


-(void)initTopNet
{
    //网易顶部滚动
    //   http://c.m.163.com/nc/article/headline/T1348647853363/0-1.html
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-10.html" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSArray *dataarray = [TopData objectArrayWithKeyValuesArray:responseObject[@"T1348647853363"][0][@"ads"]];
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *topArray = [NSMutableArray array];
        for (TopData *data in dataarray) {
            [topArray addObject:data];
            [statusFrameArray addObject:data.imgsrc];
            [titleArray addObject:data.title];
        }
        [self.topArray addObjectsFromArray:topArray];
        [self.imagesArray addObjectsFromArray:statusFrameArray];
        [self.titleArray addObjectsFromArray:titleArray];
        
        [self initScrollView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

-(void)initScrollView
{
        // 网络加载 --- 创建不带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.55) imageURLStringsGroup:self.imagesArray];
        cycleScrollView.delegate = self;
//        cycleScrollView.dotColor = [UIColor  ];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.titlesGroup = self.titleArray;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.autoScrollTimeInterval = 6.0;
        self.tableview.tableHeaderView = cycleScrollView;
}


//集成刷新控件
-(void)setupRefreshView
{
    //1.下拉刷新
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    [header beginRefreshing];
    
    //2.上拉刷新
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}
#pragma mark  下拉
-(void)loadNewData
{
    self.page = 0;
    [self requestNet:1];
    [self.tableview.header endRefreshing];
}

#pragma mark  上拉
-(void)loadMoreData
{
    [self requestNet:2];
    [self.tableview.footer endRefreshing];
}

#pragma mark 网络请求
-(void)requestNet:(int)type
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlstr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-20.html",self.page];
    [mgr GET:urlstr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSArray *temArray = responseObject[@"T1348647853363"];
        
        NSArray *arrayM = [DataModel objectArrayWithKeyValuesArray:temArray];
        NSMutableArray *statusArray = [NSMutableArray array];
        for (DataModel *data in arrayM) {
            [statusArray addObject:data];
        }
        
        if (type == 1) {
            self.totalArray = statusArray;
        }else{
            [self.totalArray addObjectsFromArray:statusArray];
        }
        [self.tableview reloadData];
        self.page += 20;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DataModel *data = self.totalArray[indexPath.row];
    NSLog(@"%@",data.title);
    
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
        NSLog(@"%@,%@",url1,url2);
        
        url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
        TopViewController *topVC = [[TopViewController alloc]init];
        topVC.url = url2;
        [self.navigationController pushViewController:topVC animated:YES];
        
    }else if ([ID isEqualToString:@"TopImageCell"]){
        NSLog(@"");
    }else{
        
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.dataModel = self.totalArray[indexPath.row];
        detailVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailVC animated:YES];

    }

}


#pragma mark 图片轮播 delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //  http://c.3g.163.com/photo/api/set/0096/77789.json
    TopData *data = self.topArray[index];
    
    NSString *url1 = [data.url substringFromIndex:4];
    url1 = [url1 substringToIndex:4];
    NSString *url2 = [data.url substringFromIndex:9];
    NSLog(@"%@,%@",url1,url2);
    
    url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
    TopViewController *topVC = [[TopViewController alloc]init];
    topVC.url = url2;
    [self.navigationController pushViewController:topVC animated:YES];
    
}


-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [defaultManager themeColor];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.tableview reloadData];
}

@end
