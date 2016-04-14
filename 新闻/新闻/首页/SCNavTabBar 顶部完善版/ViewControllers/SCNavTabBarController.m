
// 顶部导航栏
// 视图




#import "SCNavTabBarController.h"
#import "CommonMacro.h"
#import "SCNavTabBar.h"
#import "WeatherViewController.h"
#import "SocietyViewController.h"
#import "OtherNewsViewController.h"


@interface SCNavTabBarController () <UIScrollViewDelegate, SCNavTabBarDelegate>
{
    NSInteger       _currentIndex;
    NSMutableArray  *_titles;
    
    SCNavTabBar     *_navTabBar;
    UIScrollView    *_mainView;
}



@end

@implementation SCNavTabBarController




- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    
    [self initControl];
    [self initConfig];
    [self viewConfig];
}


-(void)initControl
{
    
    NSArray *namearray = [NSArray array];
    namearray = @[@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"];
    NSArray *contentarray = [NSArray array];
    contentarray = @[@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health"];
    
    NSMutableArray *viewArray = [NSMutableArray array];
    
    SocietyViewController *oneViewController = [[SocietyViewController alloc] init];
    oneViewController.title = @"社会";
    [viewArray addObject:oneViewController];
    
    for(int i = 0; i < namearray.count; i++)
    {
        OtherNewsViewController *otherViewController = [[OtherNewsViewController alloc] init];
        otherViewController.title = namearray[i];
        otherViewController.content = contentarray[i];
        [viewArray addObject:otherViewController];
    }
    
    _subViewControllers = [NSArray array];
    _subViewControllers = viewArray;
    

}

- (void)initConfig
{
    _currentIndex = 1;

    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];

    for (UIViewController *viewController in _subViewControllers)
    {
        [_titles addObject:viewController.title];
    }
}


- (void)viewConfig
{
    [self viewInit];
    
    //首先加载第一个视图
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

- (void)viewInit
{
    
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 64)];
//    _navTabBar.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:247/255.0f alpha:1];
    _navTabBar.backgroundColor = [[ThemeManager sharedInstance] themeColor];
    _navTabBar.delegate = self;
    _navTabBar.lineColor = _navTabBarLineColor;
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBounces;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
    UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    linev.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];
    [self.view addSubview:linev];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 20, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(weatherClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)weatherClick
{
    WeatherViewController *vc = [[WeatherViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = _currentIndex;

    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
}




- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
       
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
        
    }else{
       
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    }
    
//    NSString *str = [NSString stringWithFormat:@"%d",index];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"偏移" object:str];
}



-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
    _navTabBar.backgroundColor = [defaultManager themeColor];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end

