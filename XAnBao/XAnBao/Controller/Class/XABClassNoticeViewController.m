//
//  XABClassNoticeViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassNoticeViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABPostNoticeViewController.h"
#import "SDCycleScrollView.h"
#import "XABResourceListCell.h"
#import "XABArticleViewController.h"

@interface XABClassNoticeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *postNotice;
@end

@implementation XABClassNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadData:_currentIndex];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
    _currentIndex = 1;
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

- (void)loadData:(NSInteger)page {
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf stopRefresh];
        [weakSelf.tableView reloadData];
        
        weakSelf.cycleView.imageURLStringsGroup = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3510003795,2153467965&fm=23&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1017904219,2460650030&fm=23&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=938946740,2496936570&fm=23&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3448641352,2315059109&fm=23&gp=0.jpg"];
    });
}


- (void)stopRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
    //    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XABResourceListCell *cell = [XABResourceListCell newsSportListCellWithTableView:tableView];
    cell.sportList = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"XABResourceListCell" cacheByIndexPath:indexPath configuration:^(XABResourceListCell *cell) {
        cell.sportList = self.dataList[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    XABResource *sport = self.dataList[indexPath.row];
    XABArticleViewController *article = [[XABArticleViewController alloc]initWithUrl:@"https://sports.sina.cn/nba/warriors/2017-03-09/detail-ifychhuq3433755.d.html?vt=4&pos=10&HTTPS=1"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];
}






- (void)jumpPostNotice {
    [self.navigationController pushViewController:[XABPostNoticeViewController new] animated:YES];
}


#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topBarView.height, self.view.width, self.view.height - self.topBarView.height)];
        [_tableView registerClass:[XABResourceListCell class] forCellReuseIdentifier:NSStringFromClass([XABResourceListCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.cycleView;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentIndex = 1;
            [self loadData:_currentIndex];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadData:++_currentIndex];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
    }
    return _cycleView;
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"班级通知" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:self.postNotice responseTarget:self];
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
        _postNotice = [UIButton buttonWithTitle:@"发布班级通知" fontSize:15];
        [_postNotice addTarget:self action:@selector(jumpPostNotice) forControlEvents:UIControlEventTouchUpInside];
        [_postNotice sizeToFit];
    }
    return _postNotice;
}
@end
