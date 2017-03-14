//
//  XABClassViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassViewController.h"
#import "MLMeunView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIButton+Extention.h"
#import "XABSchoolMenu.h"
#import "XABSchoolMessage.h"
#import "XABSearchViewController.h"
#import "SDCycleScrollView.h"
#import "XABClassContentView.h"

@interface XABClassViewController ()
<XABSchoolMessageDelegate, XABSchoolMenuDelegate,XABClassContentViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *currentSelectSchool;
@property(nonatomic, strong)UIButton *searchBtn;
@property(nonatomic, strong)UIView *schoolMenuBgView;
@property(nonatomic, strong)XABSchoolMenu *schoolMenu;
@property(nonatomic, strong)XABSchoolMessage *schoolMessage;
@property(nonatomic, strong)XABClassContentView *contentView;
@end

@implementation XABClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];
    [self requestFoucs];
}

- (void)requestFoucs {
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.cycleView.imageURLStringsGroup = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3510003795,2153467965&fm=23&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1017904219,2460650030&fm=23&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=938946740,2496936570&fm=23&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3448641352,2315059109&fm=23&gp=0.jpg"];
    });
}

// init菜单
- (void)initTopBar {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.cycleView];
    [self.view addSubview:self.contentView];
    [self.currentSelectSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView).offset(-10);
        make.leading.equalTo(self.topBarView).offset(15);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentSelectSchool);
        make.trailing.equalTo(self.topBarView).offset(-10);
    }];
}


- (void)clickSchoolMenu {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.schoolMenuBgView];
    self.schoolMenu = [XABSchoolMenu schoolMenuList:@[@"我是家长:某某学校",@"我是老师:北京市昌平区回龙观小学",@"我是家长:北京市东城区实验小学"]];
    self.schoolMenu.delegate = self;
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

- (void)searchClick {
    [self.navigationController pushViewController:[XABSearchViewController new] animated:YES];
}


- (void)messageDidFinish:(NSString *)object content:(NSString *)content {
    
}

- (void)cancelMessage {
    [self.schoolMessage removeFromSuperview];
    [self.schoolMenuBgView removeFromSuperview];
    self.schoolMessage = nil;
}


- (void)schoolMenuSetDefault:(NSString *)str {
    [self.currentSelectSchool setTitle:str forState:UIControlStateNormal];
    [_currentSelectSchool sizeToFit];
    [_currentSelectSchool layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [self.schoolMenu removeFromSuperview];
    [self.schoolMenuBgView removeFromSuperview];
}

- (void)schoolMenuCancelFoucs:(NSString *)str {
    
}

- (void)schoolMenuSelected:(NSString *)str {
    [self.currentSelectSchool setTitle:str forState:UIControlStateNormal];
    [_currentSelectSchool sizeToFit];
    [_currentSelectSchool layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [self.schoolMenu removeFromSuperview];
    [self.schoolMenuBgView removeFromSuperview];
}

- (void)clickItemWithClass:(NSString *)className {
    Class class = NSClassFromString(className);
    UIViewController *viewcontroller = [class new];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma mark - lazy
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
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
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
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.topBarView.height, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
    }
    return _cycleView;
}
- (XABClassContentView *)contentView {
    if (!_contentView) {
        CGFloat Y = CGRectGetMaxY(self.cycleView.frame);
        _contentView = [[XABClassContentView alloc]initWithFrame:CGRectMake(0, Y, self.view.width, self.view.height - Y)];
        _contentView.delegate = self;
    }
    return _contentView;
}
@end
