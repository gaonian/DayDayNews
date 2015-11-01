//
//  VideoViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "VideoViewController.h"
#import "testViewController.h"
#import "AFNetworking.h"
#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "GCPlayer.h"
#import "DetailViewController.h"
#import "TabbarButton.h"
#import "ClassViewController.h"
#import "MBProgressHUD+MJ.h"


@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *videoArray;
@property (nonatomic , weak) UITableView *tableview;
@property (nonatomic , assign)int count;
@property (nonatomic , strong) TabbarButton *btn;
@property (nonatomic , strong) GCPlayer *player;
@end

@implementation VideoViewController

-(NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
    [self initUI];

    [self setupRefreshView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:self.title object:nil];
    
}
-(void)mynotification
{
    [self.tableview.header beginRefreshing];
}

-(void)initUI
{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.frame = self.view.frame;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_WIDTH * 0.25);
    self.tableview.tableHeaderView = view;
    
    NSArray *array = @[@"奇葩",@"萌物",@"美女",@"精品"];
    NSArray *images = @[[UIImage imageNamed:@"qipa"],
                        [UIImage imageNamed:@"mengchong"],
                        [UIImage imageNamed:@"meinv"],
                        [UIImage imageNamed:@"jingpin"]
                        ];
    
    for (int index = 0; index < 4; index++) {
        TabbarButton *btn = [[TabbarButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnW = SCREEN_WIDTH/4;
        CGFloat btnH = view.frame.size.height - 5;
        CGFloat btnX = btnW * index - 1;
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setImage:images[index] forState:UIControlStateNormal];
        [btn setTitle:array[index] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = index;
        [view addSubview:btn];
        self.btn = btn;
    }
    for (int i = 1; i < 4; i++) {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
        CGFloat lineW = 1;
        CGFloat lineH = self.btn.frame.size.height;
        CGFloat lineX = self.btn.frame.size.width * i;
        CGFloat lineY = self.btn.frame.origin.y;
        lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
        [view addSubview:lineView];
    }
    
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
    self.count = 0;
    [self initNetWork];
    [self.tableview.header endRefreshing];
}
#pragma mark  上拉
-(void)loadMoreData
{
    NSLog(@"%d",self.count);
    [self initNetWork];
    
    [self.tableview.footer endRefreshing];
}


-(void)initNetWork
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *getstr = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-10.html",self.count];
    
    [mgr GET:getstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *dataarray = [VideoData objectArrayWithKeyValuesArray:responseObject[@"videoList"]];
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (VideoData *videodata in dataarray) {
            VideoDataFrame *videodataFrame = [[VideoDataFrame alloc] init];
            // 传递微博模型数据
            videodataFrame.videodata = videodata;
            [statusFrameArray addObject:videodataFrame];
        }
        
        [self.videoArray addObjectsFromArray:statusFrameArray];
        
        self.count += 10;
        // 刷新表格
        [self.tableview reloadData];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    cell.videodataframe = self.videoArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoframe = self.videoArray[indexPath.row];
    VideoData *videodata = videoframe.videodata;
    NSLog(@"%@",videodata.mp4_url);
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.mp4url = videodata.mp4_url;
    [self.navigationController pushViewController:detail animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoFrame = self.videoArray[indexPath.row];
    return videoFrame.cellH;
}

-(void)btnClick:(TabbarButton *)btn
{
    NSArray *arr = @[@"VAP4BFE3U",
                     @"VAP4BFR16",
                     @"VAP4BG6DL",
                     @"VAP4BGTVD"];
    for (int i = 0; i < 4; i++) {
        if (btn.tag == i) {
            ClassViewController *classVC = [[ClassViewController alloc]init];
            classVC.url = arr[i];
            classVC.title = btn.titleLabel.text;
            [self.navigationController pushViewController:classVC animated:YES];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:self.title object:nil];
}

@end
