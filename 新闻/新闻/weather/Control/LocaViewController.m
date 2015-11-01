//
//  LocaViewController.m
//  新闻
//
//  Created by gyh on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "LocaViewController.h"
#import "CitiesGroup.h"
#import "MJExtension.h"
#import "LocaHeaderView.h"
#import "WeatherViewController.h"
#import "UIBarButtonItem+gyh.h"

@interface LocaViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic , strong) NSMutableArray *groups;
@property (nonatomic , strong) NSMutableArray *resultsData;
@property (nonatomic , strong) NSMutableArray *proviceResults;
@property (nonatomic , strong) UITableView *tableview;

@property (nonatomic , copy) NSString * provice;
@property (nonatomic , copy) NSString * city;

@property (nonatomic , strong) UISearchBar *mysearchBar;
@property (nonatomic , strong) UISearchDisplayController *searchDisplayController;

@end

@implementation LocaViewController


- (NSMutableArray *)groups
{
    if (_groups == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
        
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            CitiesGroup *group = [CitiesGroup objectWithKeyValues:dict];
            [groupArray addObject:group];
        }
        _groups = groupArray;
       
    }
    return _groups;
}

-(NSMutableArray *)resultsData
{
    if (!_resultsData) {
        _resultsData = [NSMutableArray array];
    }
    return _resultsData;
}
-(NSMutableArray *)proviceResults
{
    if (!_proviceResults) {
        _proviceResults = [NSMutableArray array];
    }
    return _proviceResults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"当前城市－";
    self.title = [str stringByAppendingFormat:@"%@",_currentTitle];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithIcon:@"dismiss" highIcon:nil target:self action:@selector(dismissclick)];
    

    [self initTableView];
    [self initSearchBar];
}



-(void)initTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    self.tableview.sectionHeaderHeight = 30;
    self.tableview.rowHeight = 40;

}

-(void)initSearchBar
{
    self.mysearchBar = [[UISearchBar alloc]init];
    self.mysearchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.mysearchBar.placeholder = @"搜索城市";
    self.mysearchBar.delegate = self;
    
    self.tableview.tableHeaderView = self.mysearchBar;
    
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.mysearchBar contentsController:self];
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;

}

#pragma mark  -- tableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }else{
        return self.groups.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
      
        return self.resultsData.count;
    }
    else{
        
        CitiesGroup *group = self.groups[section];
        return group.cities.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = self.resultsData[indexPath.row];
        if (self.resultsData[indexPath.row] == nil) {
            NSLog(@"没结果");
        }
    }else{
        CitiesGroup *group = self.groups[indexPath.section];
        cell.textLabel.text = group.cities[indexPath.row];
    }
    
    
    return cell;
}

#pragma mark  -- 点击事件，当监听到点击以后传值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        NSLog(@" search   %@ ,%@",self.resultsData[indexPath.row],self.proviceResults[indexPath.row]);
        if ([self.proviceResults[indexPath.row] isEqualToString:@"热门城市"]) {
            self.proviceResults[indexPath.row] = self.resultsData[indexPath.row];
        }
        if ([self.delegate respondsToSelector:@selector(locaviewwithview:provice:city:)]) {
            [self.delegate locaviewwithview:self provice:self.proviceResults[indexPath.row] city:self.resultsData[indexPath.row]];
        }
    }else{
        
        CitiesGroup *group = self.groups[indexPath.section];
        if (indexPath.section == 0) {
            group.state = group.cities[indexPath.row];
        }
        
        if ([self.delegate respondsToSelector:@selector(locaviewwithview:provice:city:)]) {
            [self.delegate locaviewwithview:self provice:group.state city:group.cities[indexPath.row]];
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark  -- HeaderView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LocaHeaderView *header = [LocaHeaderView headerWithTableView:tableView];
    header.groups = self.groups[section];
    return header;
}


#pragma mark - 是否包含或等于要搜索的字符串内容
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSMutableArray *proviceResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;

    for (int i = 0; i < self.groups.count; i++) {
        CitiesGroup *group = self.groups[i];
        
        for (int j = 0; j < group.cities.count; j++) {
                    NSString *storeString = group.cities[j];
                    NSRange storeRange = NSMakeRange(0, storeString.length);
                    NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
                    if (foundRange.length) {
                        [tempResults addObject:storeString];
                        [proviceResults addObject:group.state];
                    }
           
                }
        }
        
    [self.resultsData removeAllObjects];
    [self.resultsData addObjectsFromArray:tempResults];
    [self.proviceResults addObjectsFromArray:proviceResults];
    
}


#pragma mark - searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.mysearchBar.showsCancelButton = YES;
    
    NSArray *subViews = [(self.mysearchBar.subviews[0]) subviews];

    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];

            break;
        }
    }
}

-(void)dismissclick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
