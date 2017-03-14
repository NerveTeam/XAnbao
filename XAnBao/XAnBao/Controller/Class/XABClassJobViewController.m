//
//  XABClassJobViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassJobViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
@interface XABClassJobViewController ()
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@end

@implementation XABClassJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"今日作业" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
        _topBarView.backgroundColor = ThemeColor;
    }
    return _topBarView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
}

@end
