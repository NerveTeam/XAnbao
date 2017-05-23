//
//  XABSchoolIntranetViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolIntranetViewController.h"
#import "MLMeunView.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABPostNoticeViewController.h"

@interface XABSchoolIntranetViewController ()
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 导航背景
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *postNotice;
@end

@implementation XABSchoolIntranetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.meunView];
    [self.meunView show];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)jumpPostNotice {
    XABPostNoticeViewController *notice = [XABPostNoticeViewController new];
    notice.schoolId = self.schoolId;
    notice.noticeType = NoticeTypeSchool;
    [self.navigationController pushViewController:notice animated:YES];
}
#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, self.topBarView.height, self.view.width, TopBarHeight) titles:@[@"内部公告",@"校群讨论",@"学校文件"] viewcontrollersInfo:self.channelData isParameter:YES];
        _meunView.normalColor = [UIColor blackColor];
        _meunView.selectlColor = ThemeColor;
        [_meunView reloadMeunStyle];
    }
    return _meunView;
}

- (NSArray *)channelData {
    if (!_channelData) {
        _channelData =
        @[@{@"class":@"XABIntranetNoticeViewController",
            @"info":@{
                    @"schoolId":self.schoolId}},
            @{@"class":@"XABIntranetChatViewController",
              @"info":@{
                      @"schoolId":self.schoolId}},
              @{@"class":@"XABIntranetFileViewController",
                @"info":@{
                        @"schoolId":self.schoolId}}];
    }
    return _channelData;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"学校内网" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:self.postNotice responseTarget:self];
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
- (UIButton *)postNotice {
    if (!_postNotice) {
        _postNotice = [UIButton buttonWithTitle:@"发布校内通知" fontSize:15];
        [_postNotice addTarget:self action:@selector(jumpPostNotice) forControlEvents:UIControlEventTouchUpInside];
        [_postNotice sizeToFit];
    }
    return _postNotice;
}
@end
