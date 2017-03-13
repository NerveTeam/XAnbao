//
//  XABSchoolDetailViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/12.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolDetailViewController.h"
#import "SDCycleScrollView.h"
#import "XABResource.h"
#import "XABResourceListCell.h"
#import "XABArticleViewController.h"
#import "UIButton+Extention.h"
#import "XABSchoolIntranetViewController.h"

@interface XABSchoolDetailViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic, strong)UIButton *enterIntranetBtn;
@property(nonatomic, strong)UIView *tableHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;


@end

@implementation XABSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadData:_currentIndex];
}

- (void)setup {
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

- (void)enterIntranet {
    [self.navigationController pushViewController:[XABSchoolIntranetViewController new] animated:YES];
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
    XABResource *sport = self.dataList[indexPath.row];
    XABArticleViewController *article = [[XABArticleViewController alloc]initWithUrl:@"https://sports.sina.cn/nba/warriors/2017-03-09/detail-ifychhuq3433755.d.html?vt=4&pos=10&HTTPS=1"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];
}



#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - TabBarHeight -  2 * TopBarHeight - StatusBarHeight)];
        [_tableView registerClass:[XABResourceListCell class] forCellReuseIdentifier:NSStringFromClass([XABResourceListCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
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
- (UIButton *)enterIntranetBtn {
    if (!_enterIntranetBtn) {
        _enterIntranetBtn = [UIButton buttonWithTitle:@"进入内网" fontSize:14 titleColor:ThemeColor];
        _enterIntranetBtn.frame = CGRectMake(0, self.cycleView.height, self.view.width, 40);
        [_enterIntranetBtn addTarget:self action:@selector(enterIntranet) forControlEvents:UIControlEventTouchUpInside];
        _enterIntranetBtn.layer.borderWidth = 0.5;
        _enterIntranetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_enterIntranetBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _enterIntranetBtn;
}
- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [UIView new];
        [_tableHeaderView addSubview:self.cycleView];
        [_tableHeaderView addSubview:self.enterIntranetBtn];
        _tableHeaderView.frame = CGRectMake(0, 0, self.view.width, self.cycleView.height + self.enterIntranetBtn.height);
    }
    return _tableHeaderView;
}
@end
