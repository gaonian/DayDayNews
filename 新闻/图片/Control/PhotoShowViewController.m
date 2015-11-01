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
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "MBProgressHUD+MJ.h"


@interface PhotoShowViewController ()<UIScrollViewDelegate>

@property (nonatomic , weak) UIScrollView *scrollview;
@property (nonatomic , weak) UILabel *countlabel;
@property (nonatomic , weak) UIImageView *imageV;
@property (nonatomic , weak) UIButton *backbtn;
@property (nonatomic , weak) UIButton *downbtn;

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
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    self.scrollview = scrollview;
    
    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.hidden = NO;
    backbtn.frame = CGRectMake(5, 25, 30, 30);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_white"] forState:UIControlStateNormal];
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
    
}

#pragma mark --添加
-(void)setImage
{
    NSUInteger count = self.mutaArray.count;
    for (int i = 0; i < count; i++) {
        UIImageView *imaV = [[UIImageView alloc]init];
        // 图片的显示格式为合适大小
        imaV.contentMode= UIViewContentModeCenter;
        imaV.contentMode= UIViewContentModeScaleAspectFit;
        [self.scrollview addSubview:imaV];
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
    self.imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
    [self.imageV sd_setImageWithURL:purl placeholderImage:nil];
    // 文字
    self.countlabel.text = [NSString stringWithFormat:@"%d/%d",i + 1,(int)self.mutaArray.count];
}

#pragma mark -- 滚动完毕时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = self.scrollview.contentOffset.x / self.scrollview.frame.size.width;
    // 添加图片
    [self setImgWithIndex:index];
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

#pragma mark 点击屏幕
-(void)singleTap
{
    if (self.backbtn.hidden) {
        self.backbtn.hidden = NO;
        self.countlabel.hidden = NO;
        self.downbtn.hidden = NO;
    }else{
        self.backbtn.hidden = YES;
        self.countlabel.hidden = YES;
        self.downbtn.hidden = YES;
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
