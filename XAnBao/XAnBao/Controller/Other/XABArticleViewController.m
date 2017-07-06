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
#import "XABSchoolRequest.h"
#import "XABClassRequest.h"
#import "NSArray+Safe.h"
#import "XABSchoolNoticeStatisViewController.h"
#import "XABClassNoticeStatisViewController.h"
#import "SNJSBridge.h"
#import "NSDictionary+Safe.h"

@interface XABArticleViewController ()<SNJSBridgeDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, strong)UIButton *statisLogView;
@property(nonatomic, strong)UIButton *receivedLogView;
@property(nonatomic, strong)SNJSBridge *jsBridge;
@property (nonatomic, strong) NSMutableDictionary *jsBridgeListeners;
@end

@implementation XABArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initJSBridge];
    NSMutableDictionary *pa = [NSMutableDictionary dictionary];
    [pa setSafeObject:self.articleId forKey:@"itemId"];
    [SchoolVisitLog requestDataWithDelegate:self parameters:pa headers:Token];
    self.navigationController.navigationBar.hidden = NO;
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
//    self.webView.delegate = self.jsBridge;
    [self.webView loadRequest:request];
    [self notificationInit];
    
}
//初始化JS桥接
- (void)initJSBridge
{
    self.jsBridge = [[SNJSBridge alloc] init];
    self.jsBridge.delegate = self;
    self.jsBridgeListeners = [[NSMutableDictionary alloc] init];
}

-(void)jsBridge_addEventListener:(NSDictionary *)userInfo
{
    if(userInfo)
    {
        NSString *jsBridgeEvent = [userInfo objectForKeySafely:@"event"];
        
        [self.jsBridgeListeners setSafeObject:userInfo forKey:jsBridgeEvent];
    }
}
- (BOOL)jsBridgeOfHandleEvent:(SNJSBridge   *)jsBridge
           jsNotificationName:(NSString     *)jsNotificationName
                     userInfo:(NSDictionary *)userInfo
                  fromWebView:(UIWebView    *)webView
                callBackParam:(NSMutableDictionary *)paramDic
{
    NSString *jsBridgeMethod = [userInfo objectForKeySafely:@"method"];
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"jsBridge_%@:", jsBridgeMethod]);
    
    if ([self respondsToSelector:selector]) {
//        SN_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:selector withObject:userInfo]);
    }
    return NO;
}

- (void)notificationInit {
    
    if (!self.isReturn) {
        return;
    }
    // 通知发布者
    if (self.isCatStatis) {
        [self.view addSubview:self.statisLogView];
        
    }else {
    
        [self.view addSubview:self.receivedLogView];
        [self getReceivedInfo];
    }
}

// 家长或老师确认
- (void)receivedMessage {
    if (_isReceived) {
        return;
    }
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    if (self.showType == ArticleTypeClass) {
        [pargam setSafeObject:self.roleId forKey:@"patriarchId"];
        [pargam setSafeObject:self.articleId forKey:@"messageId"];
        [ClassReceivedNoticeRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                weakSelf.isReceived = YES;
                [weakSelf.receivedLogView setTitle:@"已确认" forState:UIControlStateNormal];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
    }else if (self.showType == ArticleTypeSchool) {
        [pargam setSafeObject:UserInfo.id forKey:@"userId"];
        [pargam setSafeObject:self.articleId forKey:@"noticeId"];
        [SchoolReceivedNoticeRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                weakSelf.isReceived = YES;
                [weakSelf.receivedLogView setTitle:@"已确认" forState:UIControlStateNormal];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
    }
}

// 统计点击
- (void)statisClick {
    if (self.showType == ArticleTypeSchool) {
        XABSchoolNoticeStatisViewController *statis = [XABSchoolNoticeStatisViewController new];
        statis.noticeId = self.articleId;
        [self pushToController:statis animated:YES];
    }else if (self.showType == ArticleTypeClass) {
        XABClassNoticeStatisViewController *statis = [XABClassNoticeStatisViewController new];
        statis.noticeId = self.articleId;
        [self pushToController:statis animated:YES];
    }
}

// 学校获取通知
- (void)getReceivedInfo {
    if (self.showType == ArticleTypeSchool) {
        WeakSelf;
        NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
            [pargam setSafeObject:UserInfo.id forKey:@"userId"];
            [pargam setSafeObject:self.articleId forKey:@"noticeId"];
        [SchoolQueryReceivedNoticeRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                weakSelf.isReceived = [[request.json objectForKeySafely:@"data"] boolValue];
                if (weakSelf.isReceived) {
                     [weakSelf.receivedLogView setTitle:@"已确认" forState:UIControlStateNormal];   
                }
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
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

- (UIButton *)statisLogView {
    if (!_statisLogView) {
        _statisLogView = [UIButton buttonWithTitle:@"通知确认统计" fontSize:16 titleColor:ThemeColor];
        _statisLogView.frame = CGRectMake(10, self.view.height - 60, self.view.width - 20, 40);
        _statisLogView.backgroundColor = [UIColor whiteColor];
        _statisLogView.layer.cornerRadius = 5;
        _statisLogView.layer.borderWidth = 1;
        _statisLogView.layer.borderColor = ThemeColor.CGColor;
        _statisLogView.clipsToBounds = YES;
        _statisLogView.hidden = NO;
        [_statisLogView addTarget:self action:@selector(statisClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statisLogView;
}
- (UIButton *)receivedLogView {
    if (!_receivedLogView) {
        _receivedLogView = [UIButton buttonWithTitle:@"确认" fontSize:15 titleColor:[UIColor whiteColor]];
        _receivedLogView.frame = CGRectMake(10, self.view.height - 60, self.view.width - 20, 40);
        _receivedLogView.backgroundColor = ThemeColor;
        _receivedLogView.layer.cornerRadius = 5;
        _receivedLogView.clipsToBounds = YES;
        [_receivedLogView addTarget:self action:@selector(receivedMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receivedLogView;
}
@end
