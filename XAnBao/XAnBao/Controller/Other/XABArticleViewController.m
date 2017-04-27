//
//  XABArticleViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/9.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABArticleViewController.h"
#import "RNCachingURLProtocol.h"
#import "XABSchoolRequest.h"

@interface XABArticleViewController ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic, copy)NSString *url;
@end

@implementation XABArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SchoolVisitLog requestDataWithDelegate:self parameters:@{@"itemId":self.articleId} headers:Token];
    self.navigationController.navigationBar.hidden = NO;
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        _webView.backgroundColor = ThemeColor;
       self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _webView.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.hidden = NO;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
         self.url = url;
    }
    return self;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    }
    return _webView;
}
@end
