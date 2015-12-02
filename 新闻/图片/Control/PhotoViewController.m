//
//  PhotoViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PhotoViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "HMWaterflowLayout.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "PhotoShowViewController.h"
#import "UIBarButtonItem+gyh.h"
#import "DOPNavbarMenu.h"


@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HMWaterflowLayoutDelegate,DOPNavbarMenuDelegate>

@property (nonatomic , weak) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *photoArray;
@property (nonatomic , assign) int pn;
@property (nonatomic , copy) NSString *tag1;
@property (nonatomic , copy) NSString *tag2;
@property (nonatomic , assign) NSInteger numberOfItemsInRow;
@property (nonatomic , strong) DOPNavbarMenu *menu;
@property (nonatomic , strong) NSArray *classArray;

@end

@implementation PhotoViewController

static NSString *const ID = @"photo";

-(NSArray *)classArray
{
    if (!_classArray) {
        _classArray = @[
                        [DOPNavbarMenuItem ItemWithTitle:@"美女" icon:[UIImage imageNamed:@"meinvchannel"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"明星" icon:[UIImage imageNamed:@"mingxing"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"汽车" icon:[UIImage imageNamed:@"qiche"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"宠物" icon:[UIImage imageNamed:@"chongwu"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"动漫" icon:[UIImage imageNamed:@"dongman"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"设计" icon:[UIImage imageNamed:@"sheji"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"家居" icon:[UIImage imageNamed:@"jiaju"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"婚嫁" icon:[UIImage imageNamed:@"hunjia"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"摄影" icon:[UIImage imageNamed:@"sheying"]],
                        [DOPNavbarMenuItem ItemWithTitle:@"美食" icon:[UIImage imageNamed:@"meishi"]]
                        ];
    }
    return _classArray;
}

- (DOPNavbarMenu *)menu {
    if (_menu == nil) {
        
        _menu = [[DOPNavbarMenu alloc] initWithItems:self.classArray width:self.view.dop_width maximumNumberInRow:_numberOfItemsInRow];
        _menu.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
        _menu.separatarColor = [UIColor clearColor];
        _menu.delegate = self;
    }
    return _menu;
}

-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOfItemsInRow = 4;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithIcon:@"categories" highIcon:nil target:self action:@selector(openMenu:)];

    self.pn = 0;
    self.tag1 = @"美女";
    self.tag2 = @"小清新";
    
    [self initCollection];
    [self setupRefreshView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:self.title object:nil];
    
}

-(void)mynotification
{
    [self.collectionView.header beginRefreshing];
}

-(void)initCollection
{
  
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc]init];
    layout.columnsCount = 2;
    layout.delegate = self;
    
    // 2.创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
   
}



//集成刷新控件
-(void)setupRefreshView
{
    //1.下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.collectionView.header beginRefreshing];
    //2.上拉刷新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark  下拉
-(void)loadNewData
{
    [self initNetWorking];
}
#pragma mark  上拉
-(void)loadMoreData
{
    [self NetWorking];
}


-(void)initNetWorking
{
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pn"] = [NSString stringWithFormat:@"%d",self.pn];
    dic[@"rn"] = @60;
    
    NSString *urlstr = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",self.tag1,self.tag2];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr GET:urlstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        
            NSArray *dataarray = [Photo objectArrayWithKeyValuesArray:responseObject[@"imgs"]];
            // 创建frame模型对象
            NSMutableArray *statusFrameArray = [NSMutableArray array];
            for (Photo *photo in dataarray) {
                [statusFrameArray addObject:photo];
            }
        
        if (dataarray.count) {
            [self.photoArray removeAllObjects];
        }
            [self.photoArray addObjectsFromArray:statusFrameArray];
            
            self.pn += 60;
        
        // 刷新表格
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 加载更多数据
-(void)NetWorking
{
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pn"] = [NSString stringWithFormat:@"%d",self.pn];
    dic[@"rn"] = @60;
    
    NSString *urlstr = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",self.tag1,self.tag2];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr GET:urlstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        
        NSArray *dataarray = [Photo objectArrayWithKeyValuesArray:responseObject[@"imgs"]];
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (Photo *photo in dataarray) {
            [statusFrameArray addObject:photo];
        }

        [self.photoArray addObjectsFromArray:statusFrameArray];
        
        self.pn += 60;
        
        // 刷新表格
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - <HMWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = self.photoArray[indexPath.item];
    return photo.small_height / photo.small_width * width;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.photo = self.photoArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoShowViewController *photoShow = [[PhotoShowViewController alloc]init];
    photoShow.currentIndex = (int)indexPath.row;
    photoShow.mutaArray = self.photoArray;
    [self.navigationController pushViewController:photoShow animated:YES];
}


- (void)openMenu:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
}

- (void)didShowMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"dismiss"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"menu"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    
    NSArray *array = @[@"美女",@"明星",@"汽车",@"宠物",@"动漫",@"设计",@"家居",@"婚嫁",@"摄影",@"美食"];
    [self.collectionView setContentOffset:CGPointMake(0, -64) animated:NO];

        self.pn = 0;
        self.tag1 = array[index];
        self.tag2 = @"全部";
        [self.collectionView.header beginRefreshing];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.menu = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.menu) {
        [self.menu dismissWithAnimation:NO];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:self.title object:nil];
}



@end
