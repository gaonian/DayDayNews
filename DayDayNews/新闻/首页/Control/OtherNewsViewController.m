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
#import "NewTableViewCell.h"
#import "NewData.h"
#import "TopData.h"
#import "NewDataFrame.h"
#import "TopViewController.h"
#import "TabbarView.h"

@interface OtherNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *totalArray;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *imagesArray;

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , assign) int page;

@end

@implementation OtherNewsViewController

- (NSMutableArray *)totalArray
{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:@"新闻" object:nil];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
}

- (void)mynotification
{
    [self.tableview.header beginRefreshing];
}

- (void)initTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
    tableview.backgroundColor = [[ThemeManager sharedInstance] themeColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(OtherNewsViewController);
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        block_self.page = 1;
        [block_self requestNet];
    }];
    [self.tableview.header beginRefreshing];
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self requestNet];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDataFrame *dataframe = self.totalArray[indexPath.row];
    
    return dataframe.cellH;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDataFrame *dataframe = self.totalArray[indexPath.row];
    NewData *data = dataframe.NewData;
    testViewController *detail = [[testViewController alloc]init];
    detail.url = data.url;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark 网络请求
-(void)requestNet
{
    IMP_BLOCK_SELF(OtherNewsViewController);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    NSString *urlstr = [NSString stringWithFormat:@"http://api.huceo.com/%@/other/?key=c32da470996b3fdd742fabe9a2948adb&num=20",self.content];
    
    [[BaseEngine shareEngine] runRequestWithPara:dic path:urlstr success:^(id responseObject) {
        
        NSArray *dataarray = [NewData objectArrayWithKeyValuesArray:responseObject[@"newslist"]];
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (NewData *data in dataarray) {
            NewDataFrame *dataFrame = [[NewDataFrame alloc] init];
            dataFrame.NewData = data;
            [statusFrameArray addObject:dataFrame];
        }
        [block_self.totalArray addObjectsFromArray:statusFrameArray];
        block_self.page++;
        [block_self.tableview reloadData];
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];

    } failure:^(id error) {
        
    }];
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
