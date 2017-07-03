//
//  XABResourceViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABResourceViewController.h"
#import "MLMeunView.h"
#import "UIView+TopBar.h"
#import "XABResourceRequest.h"
#import "NSArray+Safe.h"

@interface XABResourceViewController ()
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 导航背景
@property(nonatomic, strong)UIView *topBarView;
// 频道名称
@property(nonatomic, strong)NSArray *channelName;
@end

@implementation XABResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMenu];
}


- (void)loadMenu {
    WeakSelf;
    [XABResourceMenuListRequest requestDataWithParameters:nil headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            NSMutableArray *channelName = [NSMutableArray arrayWithCapacity:data.count];
            NSMutableArray *channelData = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *sub in data) {
                [channelName safeAddObject:[sub objectForKeySafely:@"name"]];
                [channelData safeAddObject:@{@"class":@"XABNewsViewController",
                                             @"info":@{
                                                     @"channelId":[sub objectForKeySafely:@"id"]}}];
            }
            weakSelf.channelName = channelName.copy;
            weakSelf.channelData = channelData.copy;
            [self initTopBar];
        }else {
            [self initTopBar];
        }
    } failureBlock:^(BaseDataRequest *request) {
        [self initTopBar];
        [self showMessage:[request.json objectForKeySafely:@"message"]];
    }];
}

// init菜单
- (void)initTopBar {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.meunView];
    [self.meunView show];
}

#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, 20, self.topBarView.width, TopBarHeight) titles:self.channelName viewcontrollersInfo:self.channelData isParameter:YES];
        _meunView.normalColor = [UIColor blackColor];
        _meunView.selectlColor = [UIColor whiteColor];
        [_meunView reloadMeunStyle];
    }
    return _meunView;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
    }
    return _topBarView;
}
@end
