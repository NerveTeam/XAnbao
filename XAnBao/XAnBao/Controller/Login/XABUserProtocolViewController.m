//
//  XABUserProtocolViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/27.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABUserProtocolViewController.h"
#import "XABLoginMacro.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
@interface XABUserProtocolViewController ()
@property (nonatomic,strong) UIView *topBarView;
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation XABUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self topBarView];
    self.view.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:self.html_str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:_webView];
    }
    return _webView; 
}
//初始化导航按钮
-(UIView *)topBarView
{
    if (!_topBarView) {
        
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        [self.view addSubview:_topBarView];
        
        UIButton *backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];

        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"用户注册协议" titleColor:[UIColor whiteColor] leftView:backBtn rightView:nil responseTarget:self];
    }
    return _topBarView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
