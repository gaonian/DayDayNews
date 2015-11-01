//
//  ClassViewController.m
//  新闻
//
//  Created by gyh on 15/9/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ClassViewController.h"
#import "AFNetworking.h"
#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "GCPlayer.h"
#import "DetailViewController.h"

@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *videoArray;
@property (nonatomic , weak) UITableView *tableview;
@property (nonatomic , assign)int count;

@property (nonatomic , strong) GCPlayer *player;
@end

@implementation ClassViewController

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
    [self initNetWork];
    
    [self.tableview.footer endRefreshing];
}


-(void)initNetWork
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",_url);
    NSString *getstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/%@/y/%d-10.html",_url,self.count];
    
    [mgr GET:getstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *dataarray = [VideoData objectArrayWithKeyValuesArray:responseObject[_url]];
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



@end
