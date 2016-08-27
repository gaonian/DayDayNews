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
#import "PullDownView.h"

@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , weak) UICollectionView *      collectionView;
@property (nonatomic , strong) NSMutableArray *      photoArray;
@property (nonatomic , assign) int                   pn;
@property (nonatomic , copy) NSString *              tag1;
@property (nonatomic , copy) NSString *              tag2;
@property (nonatomic , strong) NSArray *             classArray;

@property (nonatomic , strong) PullDownView *  pullDownView;

@end

@implementation PhotoViewController

static NSString *const ID = @"photo";

-(NSArray *)classArray
{
    if (!_classArray) {
        _classArray = @[
                        [PullDownItem itemWithTitle:@"美女" icon:[UIImage imageNamed:@"meinvchannel"]],
                        [PullDownItem itemWithTitle:@"明星" icon:[UIImage imageNamed:@"mingxing"]],
                        [PullDownItem itemWithTitle:@"汽车" icon:[UIImage imageNamed:@"qiche"]],
                        [PullDownItem itemWithTitle:@"宠物" icon:[UIImage imageNamed:@"chongwu"]],
                        [PullDownItem itemWithTitle:@"动漫" icon:[UIImage imageNamed:@"dongman"]],
                        [PullDownItem itemWithTitle:@"设计" icon:[UIImage imageNamed:@"sheji"]],
                        [PullDownItem itemWithTitle:@"家居" icon:[UIImage imageNamed:@"jiaju"]],
                        [PullDownItem itemWithTitle:@"婚嫁" icon:[UIImage imageNamed:@"hunjia"]],
                        [PullDownItem itemWithTitle:@"摄影" icon:[UIImage imageNamed:@"sheying"]],
                        [PullDownItem itemWithTitle:@"美食" icon:[UIImage imageNamed:@"meishi"]]
                        ];
    }
    return _classArray;
}

- (PullDownView *)pullDownView
{
    if (!_pullDownView) {
        _pullDownView = [[PullDownView alloc]init];
        [_pullDownView setDataWithItemAry:self.classArray];
    }
    IMP_BLOCK_SELF(PhotoViewController);
    _pullDownView.SelectBlock = ^(id sender){
        [block_self.collectionView setContentOffset:CGPointMake(0, -64) animated:NO];
        block_self.pn = 0;
        block_self.tag1 = sender;
        block_self.tag2 = @"全部";
        block_self.title = sender;
        [block_self.collectionView.header beginRefreshing];
    };
    return _pullDownView;
}


- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"美女";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithIcon:@"categories" highIcon:nil target:self action:@selector(openMenu)];

    self.tag1 = @"美女";
    self.tag2 = @"性感";
    
    [self initCollection];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:self.title object:nil];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    
}

- (void)mynotification
{
    [self.collectionView.header beginRefreshing];
}

- (void)initCollection
{
    IMP_BLOCK_SELF(PhotoViewController);
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc]init];
    layout.HeightBlock = ^CGFloat(CGFloat sender,NSIndexPath *index){
        Photo *photo = block_self.photoArray[index.item];
        return photo.small_height / photo.small_width * sender;
    };
    layout.columnsCount = 2;
    
    // 2.创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    GYHHeadeRefreshController *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        block_self.pn = 0;
        [block_self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.collectionView.header = header;
    [header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self initNetWorking];
    }];
}


- (void)openMenu
{
    if (self.pullDownView.isShow) {
        [self.pullDownView removeView];
    }else{
        [self.pullDownView show];
    }
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.photoArray.count) {
        PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.photo = self.photoArray[indexPath.item];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoShowViewController *photoShow = [[PhotoShowViewController alloc]init];
    photoShow.currentIndex = (int)indexPath.row;
    photoShow.mutaArray = self.photoArray;
    [self.navigationController pushViewController:photoShow animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    self.collectionView.backgroundColor = [defaultManager themeColor];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.collectionView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)loadData
{
    IMP_BLOCK_SELF(PhotoViewController);
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pn"] = [NSString stringWithFormat:@"%d",self.pn];
    dic[@"rn"] = @60;
    
    NSString *urlstr = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",self.tag1,self.tag2];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mgr GET:urlstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        
        NSArray *dataarray = [Photo objectArrayWithKeyValuesArray:responseObject[@"imgs"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (Photo *photo in dataarray) {
            [statusFrameArray addObject:photo];
        }
        
        if (block_self.photoArray.count > 0) {
            [block_self.photoArray removeAllObjects];
        }
        block_self.photoArray  = statusFrameArray;
        
        block_self.pn += 60;
        block_self.collectionView.footer.hidden = block_self.photoArray.count < 60;
        [block_self.collectionView reloadData];
        [block_self.collectionView.header endRefreshing];
        [block_self.collectionView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [block_self.collectionView.header endRefreshing];
        [block_self.collectionView.footer endRefreshing];
    }];
}

- (void)initNetWorking
{
    IMP_BLOCK_SELF(PhotoViewController);
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pn"] = [NSString stringWithFormat:@"%d",self.pn];
    dic[@"rn"] = @60;
    
    NSString *urlstr = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",self.tag1,self.tag2];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [mgr GET:urlstr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        
        NSArray *dataarray = [Photo objectArrayWithKeyValuesArray:responseObject[@"imgs"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (Photo *photo in dataarray) {
            [statusFrameArray addObject:photo];
        }
        
        if (block_self.photoArray.count == 0) {
            block_self.photoArray = statusFrameArray;
        }else{
            [block_self.photoArray addObjectsFromArray:statusFrameArray];
        }
        
        block_self.pn += 60;
        block_self.collectionView.footer.hidden = block_self.photoArray.count < 60;
        [block_self.collectionView reloadData];
        [block_self.collectionView.header endRefreshing];
        [block_self.collectionView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [block_self.collectionView.header endRefreshing];
        [block_self.collectionView.footer endRefreshing];
    }];
}

@end
