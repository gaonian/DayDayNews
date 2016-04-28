//
//  DetailViewController.m
//  新闻
//
//  Created by gyh on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DetailWebViewController.h"
#import "DetailWebModel.h"
#import "DetailImageWebModel.h"
#import "DataBase.h"
#import "NSDate+gyh.h"


@interface DetailWebViewController ()<UIWebViewDelegate>
@property (nonatomic , strong) DetailWebModel *detailModel;
@property (nonatomic , weak) UIWebView *webView;
@property (nonatomic , copy) NSString *url;
@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
}

- (void)setupUI
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 54, 44)];
    [btn setImage:[UIImage imageNamed:@"night_icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineV];
    
    //收藏
    UIButton *shoucangB = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44-10, 20, 44, 44)];
    shoucangB.titleLabel.font = [UIFont systemFontOfSize:13];
    [shoucangB addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoucangB];
    
    if ([[DataBase queryWithCollect:self.dataModel.docid] isEqualToString:@"1"]) {
        shoucangB.selected = YES;
        [shoucangB setTitle:@"已收藏" forState:UIControlStateNormal];
        [shoucangB setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }else{
        [shoucangB setTitle:@"收藏" forState:UIControlStateNormal];
        [shoucangB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    //分享
    UIButton *fenxiangB = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-88, 20, 44, 44)];
    [fenxiangB setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:fenxiangB];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.backgroundColor = [UIColor whiteColor];
    webView.y = 64;
    webView.height = SCREEN_HEIGHT - 64;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)setupData
{
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.dataModel.docid];
    NSLog(@"%@",url);
    self.url = url;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.detailModel = [DetailWebModel detailWithDict:responseObject[self.dataModel.docid]];
        [self showInWebView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"Detail.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    // 遍历img
    for (DetailImageWebModel *detailImgModel in self.detailModel.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

#pragma mark - 将发出通知时调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        NSInteger begin = range.location + range.length;
        NSString *src = [url substringFromIndex:begin];
        [self savePictureToAlbum:src];
        return NO;
    }
    return YES;
}


- (void)savePictureToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 收藏
- (void)shoucang:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected){
        [btn setTitle:@"已收藏" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [DataBase addNews:self.dataModel.title docid:self.dataModel.docid time:[NSDate currentTime]];
    }else{
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [DataBase deletetable:self.dataModel.docid];
    }
}



- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
