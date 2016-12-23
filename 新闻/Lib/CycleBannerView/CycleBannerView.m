//
//  CycleBannerView.m
//
//  Created by 范英强 on 2016/11/17.
//  Copyright © 2016年 gyh. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define pagePadding 9   //分页控件边距

#import "CycleBannerView.h"
#import "CycleBannerCell.h"

@interface CycleBannerView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic , strong) UICollectionViewFlowLayout * flowlayout;
@property (nonatomic , strong) UICollectionView *           cvMain;
@property (nonatomic , strong) NSTimer *                    timer;
@property (nonatomic , strong) UIPageControl *              pageControl;
@property (nonatomic , strong) UIImageView *                bgView;
@property (nonatomic , strong) UILabel *                    lbText;
@property (nonatomic , strong) UIView *                     viewBg;
@property (nonatomic)          NSInteger                    totalItemsCount;

@end

@implementation CycleBannerView

static NSString *k_cellId = @"CycleBannerCell";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupCollectionView];
        [self initialization];
    }
    return self;
}

- (void)setupCollectionView {
    
    self.flowlayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowlayout.minimumLineSpacing = 0;
    self.flowlayout.itemSize = CGSizeMake(ScreenWidth, self.bounds.size.height);
    self.flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.cvMain = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowlayout];
    self.cvMain.backgroundColor = [UIColor whiteColor];
    self.cvMain.pagingEnabled = YES;
    self.cvMain.showsVerticalScrollIndicator = NO;
    self.cvMain.showsHorizontalScrollIndicator = NO;
    self.cvMain.delegate = self;
    self.cvMain.dataSource = self;
    [self.cvMain registerClass:[CycleBannerCell class] forCellWithReuseIdentifier:k_cellId];
    [self addSubview:self.cvMain];
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview];
    
    if (self.aryImg.count == 0 || self.aryImg.count == 1) return;
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 34, ScreenWidth, 34)];
    self.bgView.backgroundColor = self.bgColor;
    self.bgView.image = self.bgImg;
    [self addSubview:self.bgView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.aryImg.count;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = indexOnPageControl;
    self.pageControl.currentPageIndicatorTintColor = self.currentColor;
    self.pageControl.pageIndicatorTintColor = self.otherColor;
    [self addSubview:self.pageControl];
    self.pageControl.hidden = !self.showPageControl;
    
    CGFloat pageControlWidth = self.aryImg.count * 10 * 1.5;
    CGFloat pagecontrolHeight = 20.0f;
    switch (_pageControlAliment) {
        case CycleScrollViewPageContolAlimentLeft:
            self.pageControl.frame = CGRectMake(pagePadding, self.bounds.size.height - 27, pageControlWidth, pagecontrolHeight);
            break;
        case CycleScrollViewPageContolAlimentCenter:
            self.pageControl.frame = CGRectMake((ScreenWidth - pageControlWidth)/2, self.bounds.size.height - 27, pageControlWidth, pagecontrolHeight);
            break;
        case CycleScrollViewPageContolAlimentRight:
            self.pageControl.frame = CGRectMake(ScreenWidth - pageControlWidth - pagePadding, self.bounds.size.height - 27, pageControlWidth, pagecontrolHeight);
            break;
            
        default:
            break;
    }
}

- (void)setupTextView {
    
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    int indexOfText = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    
    self.lbText = [[UILabel alloc] initWithFrame:CGRectMake(9, self.bgView.frame.origin.y, ScreenWidth - 9 - self.pageControl.frame.size.width - 9, 34)];
    self.lbText.font = [UIFont systemFontOfSize:14];
    self.lbText.textColor = [UIColor whiteColor];
    [self addSubview:self.lbText];
    
    self.lbText.text = self.aryText[indexOfText];
}

- (void)initialization {
    
    _autoScroll = YES;
    _showPageControl = YES;
    _autoScrollTimeInterval = 5.f;
    _pageControlAliment = CycleScrollViewPageContolAlimentRight;
    _bgColor = [UIColor clearColor];
    _bgImg = nil;
}


#pragma mark - setter
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}

- (void)setPageControlAliment:(CycleScrollViewPageContolAliment)pageControlAliment {
    _pageControlAliment = pageControlAliment;
    [self setupPageControl];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _bgColor = _bgImg?[UIColor clearColor]:_bgColor;
    self.bgView.backgroundColor = _bgColor;
}

- (void)setBgImg:(UIImage *)bgImg {
    _bgImg = bgImg;
    _bgColor = [UIColor clearColor];
    self.bgView.backgroundColor = _bgColor;
    self.bgView.image = _bgImg;
}

#pragma mark - action
- (void)setAryImg:(NSArray *)aryImg {
    _aryImg = aryImg;
    [self invalidateTimer];
    
    _totalItemsCount = _aryImg.count * 100;
        
    if (_aryImg.count != 1) {
        self.cvMain.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.cvMain.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.cvMain reloadData];
}

- (void)setAryText:(NSArray *)aryText {
    _aryText = aryText;
    [self setupTextView];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll
{
    if (!self.totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= self.totalItemsCount) {
        targetIndex = self.totalItemsCount * 0.5;
        [self.cvMain scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.cvMain scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex
{
    if (self.cvMain.frame.size.width == 0 || self.cvMain.frame.size.height == 0) return 0;

    int index = 0;
    index = (self.cvMain.contentOffset.x + self.flowlayout.itemSize.width * 0.5) / self.flowlayout.itemSize.width;
    
    return MAX(0, index);
}


- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.aryImg.count;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:k_cellId forIndexPath:indexPath];
    int itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if (itemIndex < self.aryImg.count) {
        NSString *imgUrl = self.aryImg[itemIndex];
        [cell setCellDataWithUrl:imgUrl];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickItemBlock) {
        self.clickItemBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.aryImg.count) return;
    int page = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:page];
    self.pageControl.currentPage = indexOnPageControl;
    if (self.aryText.count > 0 && indexOnPageControl < self.aryText.count) {
        self.lbText.text = self.aryText[indexOnPageControl];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cvMain.contentOffset.x == 0 && self.totalItemsCount) {
        int targetIndex = 0;
        targetIndex = self.totalItemsCount * 0.5;
        [self.cvMain scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)dealloc {
    self.cvMain.delegate = nil;
    self.cvMain.dataSource = nil;
    [self invalidateTimer];
}


@end
