//
//  OtherNewsViewController.m
//  新闻
//
//  Created by gyh on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "OtherNewsViewController.h"
#import "testViewController.h"
#import "AFNetworking.h"
#import "NewTableViewCell.h"
#import "MJExtension.h"
#import "NewData.h"
#import "TopData.h"
#import "NewDataFrame.h"
#import "MJRefresh.h"
#import "TopViewController.h"
#import "MBProgressHUD+MJ.h"
#import "TabbarView.h"

@interface OtherNewsViewController ()<UITableViewDelegate,UITableViewDataSource,TabbarViewDelegate>
@property (nonatomic , strong) NSMutableArray *totalArray;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *imagesArray;

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , assign) int page;

@end

@implementation OtherNewsViewController

-(NSMutableArray *)totalArray
{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self setupRefreshView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:@"新闻" object:nil];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
}

-(void)mynotification
{
    [self.tableview.header beginRefreshing];
}

-(void)initTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
    tableview.backgroundColor = [[ThemeManager sharedInstance] themeColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
}



//集成刷新控件
-(void)setupRefreshView
{
    //1.下拉刷新
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableview.header beginRefreshing];
    //2.上拉刷新
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark  下拉
-(void)loadNewData
{
    self.page = 1;
    [self requestNet];
}

#pragma mark  上拉
-(void)loadMoreData
{
    [self requestNet];
    [self.tableview.footer endRefreshing];
}

#pragma mark 网络请求
-(void)requestNet
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    NSString *urlstr = [NSString stringWithFormat:@"http://api.huceo.com/%@/other/?key=c32da470996b3fdd742fabe9a2948adb&num=20",self.content];
    [mgr GET:urlstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *dataarray = [NewData objectArrayWithKeyValuesArray:responseObject[@"newslist"]];
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (NewData *data in dataarray) {
            NewDataFrame *dataFrame = [[NewDataFrame alloc] init];
            // 传递微博模型数据
            dataFrame.NewData = data;
            [statusFrameArray addObject:dataFrame];
        }
        [self.totalArray addObjectsFromArray:statusFrameArray];
        self.page++;
        // 刷新表格
        [self.tableview reloadData];
        
        [self.tableview.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTableViewCell *cell = [NewTableViewCell cellWithTableView:tableView];
        ThemeManager *defaultManager = [ThemeManager sharedInstance];
    if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
        cell.backgroundColor = defaultManager.themeColor;
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.dataFrame = self.totalArray[indexPath.row];
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDataFrame *dataframe = self.totalArray[indexPath.row];
    
    return dataframe.cellH;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDataFrame *dataframe = self.totalArray[indexPath.row];
    NewData *data = dataframe.NewData;
    NSLog(@"%@",data.url);
    testViewController *detail = [[testViewController alloc]init];
    detail.url = data.url;
    [self.navigationController pushViewController:detail animated:YES];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"新闻" object:nil];
}


-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    self.tableview.backgroundColor = [defaultManager themeColor];
    [self.tableview reloadData];
}


@end
