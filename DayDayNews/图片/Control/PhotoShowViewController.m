//
//  PhotoShowViewController.m
//  新闻
//
//  Created by gyh on 15/9/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "PhotoShowViewController.h"
#import "Photo.h"
#import "DataBase.h"
#import "NSDate+gyh.h"
#import "ShareManager.h"


@interface PhotoShowViewController ()<UIScrollViewDelegate>

@property (nonatomic , weak) UIScrollView *scrollview;
@property (nonatomic , weak) UIScrollView *frontScrollV;
@property (nonatomic , weak) UILabel *countlabel;    //数目按钮
@property (nonatomic , weak) UIImageView *imageV;
@property (nonatomic , weak) UIButton *backbtn;      //返回按钮
@property (nonatomic , weak) UIButton *downbtn;      //下载按钮
@property (nonatomic , weak) UIButton *collectbtn;   //收藏按钮
@property (nonatomic , weak) UIButton *sharebtn;     //分享按钮
@property (nonatomic , assign) int index;            //当前滚动的是第几个
@end

@implementation PhotoShowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initUI];
    
    [self setImage];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)initUI
{
    self.index = _currentIndex;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    self.scrollview = scrollview;
    
    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.hidden = NO;
    backbtn.frame = CGRectMake(5, 25, 40, 40);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    self.backbtn = backbtn;
    
    //数量
    UILabel *countlabel = [[UILabel alloc]init];
    CGFloat countlabelW = 80;
    CGFloat countlabelH = 30;
    CGFloat countlabelX = (SCREEN_WIDTH - countlabelW)/2;
    CGFloat countlabelY = 25;
    countlabel.frame = CGRectMake(countlabelX, countlabelY, countlabelW, countlabelH);
    countlabel.font = [UIFont systemFontOfSize:18];
    countlabel.textColor = [UIColor whiteColor];
    countlabel.textAlignment = NSTextAlignmentCenter;
    countlabel.hidden = NO;
    [self.view addSubview:countlabel];
    self.countlabel = countlabel;
    
    //下载按钮
    UIButton *downbtn = [[UIButton alloc]init];
    downbtn.hidden = NO;
    downbtn.frame = CGRectMake(SCREEN_WIDTH - 5 - 40, backbtn.frame.origin.y, 40, 40);
    [downbtn setBackgroundImage:[UIImage imageNamed:@"arrow237"] forState:UIControlStateNormal];
    [downbtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downbtn];
    self.downbtn = downbtn;
    
    //分享按钮
    UIButton *sharebtn = [[UIButton alloc]init];
    sharebtn.hidden = NO;
    sharebtn.frame = CGRectMake(SCREEN_WIDTH - 5 - 40, SCREEN_HEIGHT-10-40, 40, 40);
    [sharebtn setTitle:@"分享" forState:UIControlStateNormal];
    sharebtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sharebtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sharebtn];
    self.sharebtn = sharebtn;
    
    //收藏按钮
    UIButton *collectbtn = [[UIButton alloc]init];
    collectbtn.hidden = NO;
    collectbtn.frame = CGRectMake(sharebtn.originX-10-70, sharebtn.originY, 70, 40);
    [collectbtn setTitle:@"收藏" forState:UIControlStateNormal];
    collectbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [collectbtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectbtn];
    self.collectbtn = collectbtn;
    
    if ([[DataBase queryWithCollectPhoto:[self.mutaArray[_currentIndex] image_url]] isEqualToString:@"1"]) {
        collectbtn.selected = YES;
        [collectbtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [collectbtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }else{
        collectbtn.selected = NO;
        [collectbtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}

#pragma mark --添加
-(void)setImage
{
    NSUInteger count = self.mutaArray.count;
    for (int i = 0; i < count; i++) {
        
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        scrollView.userInteractionEnabled = YES;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.bouncesZoom = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        self.frontScrollV = scrollView;
        
        UIImageView *imaV = [[UIImageView alloc]init];
        [self.frontScrollV addSubview:imaV];
        [self.scrollview addSubview:scrollView];
        self.imageV = imaV;
    }
    
    self.scrollview.contentOffset = CGPointMake(_currentIndex * SCREEN_WIDTH, 0);
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * count, 0);
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.pagingEnabled = YES;
    
    [self setImgWithIndex:_currentIndex];

}

#pragma mark -- 根据i添加图片，设置每个图片的尺寸
- (void)setImgWithIndex:(int)i
{
    //图片
    NSURL *purl = [NSURL URLWithString:[self.mutaArray[i] image_url]];
    CGFloat imageW = SCREEN_WIDTH;
    CGFloat imageH = [self.mutaArray[i] image_height] /[self.mutaArray[i] image_width] * imageW;
    CGFloat imageY = (SCREEN_HEIGHT-imageH)/2 - 20;
    CGFloat imageX = i * imageW;
    self.frontScrollV.frame = CGRectMake(imageX, imageY, imageW, imageH);
    self.imageV.frame = CGRectMake(0, 0, imageW, imageH);
    if (self.imageV.image == nil) {
        [self.imageV sd_setImageWithURL:purl placeholderImage:nil];
    }
    // 文字
    if (self.mutaArray.count > 1) {
        self.countlabel.text = [NSString stringWithFormat:@"%d/%d",i + 1,(int)self.mutaArray.count];
    }
    
    if ([[DataBase queryWithCollectPhoto:[self.mutaArray[i] image_url]] isEqualToString:@"1"]) {
        self.collectbtn.selected = YES;
        [self.collectbtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [self.collectbtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }else{
        self.collectbtn.selected = NO;
        [self.collectbtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark -- 滚动完毕时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.index = index;
    if (scrollView == self.scrollview) {
        [self setImgWithIndex:index];
    }
}

#pragma mark 保存图片
-(void)downClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(self.imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error != NULL){
        [MBProgressHUD showError:@"下载失败"];
    }else{
        [MBProgressHUD showSuccess:@"保存成功"];
    }
}

#pragma mark - 收藏方法
- (void)collectClick:(UIButton *)btn
{

    NSString *width = [NSString stringWithFormat:@"%f",[self.mutaArray[self.index] image_width]];
    NSString *height = [NSString stringWithFormat:@"%f",[self.mutaArray[self.index] image_height]];
    
    
    btn.selected = !btn.selected;
    if(btn.selected){
        [btn setTitle:@"已收藏" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [DataBase addPhotosWithTitle:[self.mutaArray[self.index] title] image_url:[self.mutaArray[self.index] image_url] image_width:width image_height:height time:[NSDate currentTime]];
    }else{
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [DataBase deletetableWithPhoto:[self.mutaArray[self.index] image_url]];
    }
}


#pragma mark - 分享方法
- (void)shareClick
{
    [[ShareManager sharedInstance] shareWeiboWithTitle:@"性感不" images:self.imageV.image dismissBlock:nil];
}


#pragma mark 点击屏幕
-(void)singleTap
{
    if (self.backbtn.hidden) {
        self.backbtn.hidden = NO;
        self.countlabel.hidden = NO;
        self.downbtn.hidden = NO;
        self.sharebtn.hidden = NO;
        self.collectbtn.hidden = NO;
    }else{
        self.backbtn.hidden = YES;
        self.countlabel.hidden = YES;
        self.downbtn.hidden = YES;
        self.sharebtn.hidden = YES;
        self.collectbtn.hidden = YES;
    }
}

#pragma mark 返回按钮
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



@end
