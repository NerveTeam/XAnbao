//
//  XABSchoolViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolViewController.h"
#import "MLMeunView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIButton+Extention.h"
#import "XABSchoolMenu.h"
#import "XABSchoolMessage.h"

@interface XABSchoolViewController ()<XABSchoolMessageDelegate>
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 导航背景
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *currentSelectSchool;
@property(nonatomic, strong)UIButton *searchBtn;
@property(nonatomic, strong)UIView *schoolMenuBgView;
@property(nonatomic, strong)XABSchoolMenu *schoolMenu;
@property(nonatomic, strong)XABSchoolMessage *schoolMessage;
@property(nonatomic, strong)UIButton *messageMailBtn;
@end

@implementation XABSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];
    [self.meunView changeMenuWidth:self.messageMailBtn.x];
}

// init菜单
- (void)initTopBar {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.meunView];
    [self.view addSubview:self.messageMailBtn];
    [self.meunView show];
    
    [self.currentSelectSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView).offset(-10);
        make.leading.equalTo(self.topBarView).offset(15);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentSelectSchool);
        make.trailing.equalTo(self.topBarView).offset(-10);
    }];
}

- (void)clickMessageMail {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.schoolMenuBgView];
    self.schoolMessage = [XABSchoolMessage schoolMessageList:@[@"dsf",@"dffs",@"fdgfdg"]];
    self.schoolMessage.delegate = self;
    self.schoolMessage.width = SCREEN_WIDTH - 40;
    self.schoolMessage.height = 200;
    self.schoolMessage.centerX = window.centerX;
    self.schoolMessage.centerY = window.centerY;
    [window addSubview:self.schoolMessage];
}

- (void)clickSchoolMenu {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.schoolMenuBgView];
    self.schoolMenu = [XABSchoolMenu schoolMenuList:@[@"dsf",@"dffs",@"fdgfdg"]];
    [window addSubview:self.schoolMenu];
}
- (void)tapClick {
    __weak typeof(self)weakSelf = self;
    if (self.schoolMessage) {
        [self cancelMessage];
    }else {
    [self.schoolMenu hide:^{
        [weakSelf.schoolMenu removeFromSuperview];
        [weakSelf.schoolMenuBgView removeFromSuperview];
        weakSelf.schoolMenu = nil;
    }];
    }
}


- (void)messageDidFinish:(NSString *)object content:(NSString *)content {

}

- (void)cancelMessage {
    [self.schoolMessage removeFromSuperview];
    [self.schoolMenuBgView removeFromSuperview];
    self.schoolMessage = nil;
}

#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, self.topBarView.height, self.topBarView.width - self.messageMailBtn.width, TopBarHeight) titles:@[@"新闻公告",@"学生风采",@"学校简介",@"学校图片"] viewcontrollersInfo:self.channelData isParameter:NO];
        _meunView.normalColor = [UIColor blackColor];
        _meunView.selectlColor = ThemeColor;
        [_meunView reloadMeunStyle];
    }
    return _meunView;
}
- (NSArray *)channelData {
    if (!_channelData) {
        _channelData = @[@"XABNewsNoticeViewController",@"XABStudentStyleViewController",@"XABSchoolSummaryViewController",@"XABSchoolPictureViewController"];
    }
    return _channelData;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView.backgroundColor = ThemeColor;
    }
    return _topBarView;
}
- (UIButton *)currentSelectSchool {
    if (!_currentSelectSchool) {
        _currentSelectSchool = [[UIButton alloc]init];
        [_currentSelectSchool.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_currentSelectSchool setTitle:@"北京市朝阳区第二实验小学" forState:UIControlStateNormal];
        [_currentSelectSchool setImage:[UIImage imageNamed:@"faculty_arrow"] forState:UIControlStateNormal];
        [_currentSelectSchool sizeToFit];
        [_currentSelectSchool layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [self.topBarView addSubview:_currentSelectSchool];
        [_currentSelectSchool addTarget:self action:@selector(clickSchoolMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentSelectSchool;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithImageNormal:@"nav_btn_search" imageSelected:@"nav_btn_search"];
        [_searchBtn sizeToFit];
        [self.topBarView addSubview:_searchBtn];
    }
    return _searchBtn;
}
- (UIView *)schoolMenuBgView {
    if (!_schoolMenuBgView) {
        _schoolMenuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _schoolMenuBgView.backgroundColor = [UIColor blackColor];
        _schoolMenuBgView.alpha = 0.5;
        [_schoolMenuBgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    }
    return _schoolMenuBgView;
}
- (UIButton *)messageMailBtn {
    if (!_messageMailBtn) {
        _messageMailBtn = [UIButton buttonWithImageNormal:@"btn_mailbox" imageSelected:@"btn_mailbox"];
        [_messageMailBtn sizeToFit];
        _messageMailBtn.x = self.view.width - _messageMailBtn.width - 10;
        _messageMailBtn.y = CGRectGetMaxY(self.topBarView.frame) + 10;
        [_messageMailBtn addTarget:self action:@selector(clickMessageMail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageMailBtn;
}
@end
