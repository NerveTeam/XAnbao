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
#import "UIButton+Extention.h"

@interface XABArticleViewController ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, strong)UIButton *receivedLogView;
@property(nonatomic, assign)BOOL isReceived;
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
    
    [self.view addSubview:self.receivedLogView];
    
    if (self.showType == ArticleTypeNone) {
        self.receivedLogView.hidden = YES;
    }else {
        [self getReceivedInfo];
    }
    
}
// 学校和班级获取通知统计
- (void)getReceivedInfo {

}

- (void)handleReceivedMessage {
    if (_isReceived) {
        return;
    }
    
    if (self.showType == ArticleTypeClass) {
        
    }else if (self.showType == ArticleTypeSchool) {
    
    }
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

- (UIButton *)receivedLogView {
    if (!_receivedLogView) {
        _receivedLogView = [UIButton buttonWithTitle:@"通知确认统计" fontSize:16 titleColor:ThemeColor];
        _receivedLogView.frame = CGRectMake(10, self.view.height - 60, self.view.width - 20, 40);
        _receivedLogView.backgroundColor = [UIColor whiteColor];
        _receivedLogView.layer.cornerRadius = 5;
        _receivedLogView.layer.borderWidth = 1;
        _receivedLogView.layer.borderColor = ThemeColor.CGColor;
        _receivedLogView.clipsToBounds = YES;
        _receivedLogView.hidden = NO;
        [_receivedLogView addTarget:self action:@selector(handleReceivedMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receivedLogView;
}
@end
