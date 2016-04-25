//
//  CollectViewController.m
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CollectViewController.h"
#import "DataBase.h"
#import "CollectTableViewCell.h"
#import "CollectModel.h"
#import "DetailWebViewController.h"

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
}
@property (nonatomic , strong) NSMutableArray *totalArr;
@property (nonatomic , strong) CollectModel *collectmodel;
@end

@implementation CollectViewController

- (NSMutableArray *)totalArr
{
    if (!_totalArr) {
        _totalArr = [NSMutableArray array];
    }
    return _totalArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.totalArr = [DataBase display];
    NSLog(@"%@",_totalArr);
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectTableViewCell *cell = [[CollectTableViewCell alloc]init];
    cell.collectModel = self.totalArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
    detailVC.dataModel = self.totalArr[indexPath.row];
    detailVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
