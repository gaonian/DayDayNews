//
//  PullDownView.m
//  新闻
//
//  Created by gyh on 16/8/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PullDownView.h"
#import "PullDownCell.h"

@implementation PullDownItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    self = [super init];
    if (self == nil) return nil;
    _title = title;
    _icon = icon;
    return self;
}

+ (PullDownItem *)itemWithTitle:(NSString *)title icon:(UIImage *)icon {
    return [[self alloc] initWithTitle:title icon:icon];
}

@end



@interface PullDownView()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) NSArray *            aryData;
@property (nonatomic , strong) UICollectionView *   collection;
@end


@implementation PullDownView

static NSString *ID = @"PullDownCell";

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(50, 75);
        layout.minimumInteritemSpacing = (SCREEN_WIDTH - 200)/5.f;
        layout.minimumLineSpacing = 20.f;
        layout.sectionInset = UIEdgeInsetsMake(20, (SCREEN_WIDTH - 250)/5.f, 0, (SCREEN_WIDTH - 250)/5.f);
        
        UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        collection.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
        collection.dataSource = self;
        collection.delegate = self;
        [self addSubview:collection];
        self.collection = collection;
        
        [self.collection registerNib:[UINib nibWithNibName:@"PullDownCell" bundle:nil] forCellWithReuseIdentifier:ID];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(0, 300, SCREEN_WIDTH, SCREEN_HEIGHT - 300 - 64);
        [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    return self;
}

- (void)setDataWithItemAry:(NSArray *)ary
{
    self.aryData = ary;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.aryData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.aryData.count) {
        PullDownItem *item = self.aryData[indexPath.row];
        PullDownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        [cell setDataWithItem:item];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PullDownItem *item = self.aryData[indexPath.row];
    if (self.SelectBlock) {
        self.SelectBlock(item.title);
    }
    [self removeView];
}

- (void)show
{
    if (!self.superview) {
        [theWindow addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            self.collection.height = 300;
        } completion:^(BOOL finished) {
            self.isShow = YES;
        }];
    }
}

- (void)removeView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.collection.height = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isShow = NO;
        if (self.removeBlock) {
            self.removeBlock();
        }
    }];
}


@end
