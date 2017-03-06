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

@interface XABResourceViewController ()
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 导航背景
@property(nonatomic, strong)UIView *topBarView;
@end

@implementation XABResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];

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
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, self.topBarView.height, self.topBarView.width, TopBarHeight) titles:@[@"推荐",@"交通安全",@"火灾消防",@"儿童安全",@"校园安全",@"自救互救",@"居家安全",@"其他",@"测试",@"哈哈"] viewcontrollersInfo:self.channelData isParameter:NO];
        _meunView.normalColor = [UIColor blackColor];
        _meunView.selectlColor = ThemeColor;
        [_meunView reloadMeunStyle];
    }
    return _meunView;
}
- (NSArray *)channelData {
    if (!_channelData) {
        _channelData = @[@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController",@"XABNewsViewController"];
    }
    return _channelData;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"学习资源" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
    }
    return _topBarView;
}
@end
