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
#import "PhotoCollectTableViewCell.h"
#import "CollectModel.h"
#import "PhotoCollectModel.h"
#import "DetailWebViewController.h"
#import "PhotoShowViewController.h"
#import "AppDelegate.h"

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    int column;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_totalArr) {
        _totalArr = nil;
    }
    NSString *segment = [[NSUserDefaults standardUserDefaults]objectForKey:@"Segment"];
    if ([segment isEqualToString:@"2"]) {
        
    }else if ([segment isEqualToString:@"1"]){
        self.totalArr = [DataBase basePhotoDisplay];
    }else{
        self.totalArr = [DataBase display];
    }
    [tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.tableFooterView = [[UIView alloc]init];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"新闻收藏",@"图片收藏",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:1 green:0.584 blue:0 alpha:1];
    [segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [self segmentClick:segmentedControl];
}

- (void)segmentClick:(UISegmentedControl *)seg
{
    if ([seg selectedSegmentIndex] == 0) {
        column = 0;
        
        self.totalArr = nil;
        self.totalArr = [DataBase display];
        [tableview reloadData];
        
    }else if ([seg selectedSegmentIndex] == 1) {
        column = 1;
        
        self.totalArr = nil;
        self.totalArr = [DataBase basePhotoDisplay];
        [tableview reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (column == 0) {
        CollectTableViewCell *cell = [[CollectTableViewCell alloc]init];
        cell.collectModel = self.totalArr[indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",column] forKey:@"Segment"];
        return cell;
    }else if (column == 1){
        PhotoCollectTableViewCell *cell = [PhotoCollectTableViewCell cellWithTableView:tableview];
        cell.photoModel = self.totalArr[indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",column] forKey:@"Segment"];
        return cell;
    }else{
        PhotoCollectTableViewCell *cell = [PhotoCollectTableViewCell cellWithTableView:tableview];
        cell.photoModel = self.totalArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (column == 0) {
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.dataModel = self.totalArr[indexPath.row];
        detailVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (column == 1){
        PhotoShowViewController *photoShow = [[PhotoShowViewController alloc]init];
        photoShow.currentIndex = (int)indexPath.row;
        photoShow.mutaArray = self.totalArr;
        [self.navigationController pushViewController:photoShow animated:YES];
    }else{
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(column == 0){
        DataModel *dataModel = self.totalArr[indexPath.row];
        [DataBase deletetable:dataModel.docid];
        self.totalArr = [DataBase display];
    }else if (column == 1){
        PhotoCollectModel *photoModel = self.totalArr[indexPath.row];
        [DataBase deletetableWithPhoto:photoModel.image_url];
        self.totalArr = [DataBase basePhotoDisplay];
    }
    [tableview reloadData];
    [tableview setEditing:NO animated:YES];
}


//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"Segment"];
}


@end
