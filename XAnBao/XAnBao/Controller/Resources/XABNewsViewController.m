//
//  XABNewsViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABNewsViewController.h"
#import "XABResource.h"
#import "XABResourceListCell.h"

@interface XABNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;
@end

@implementation XABNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 1;
    [self loadData:_currentIndex];
    [self.tableView.mj_header beginRefreshing];
   self.view.backgroundColor = [UIColor colorWithRed:(int)(arc4random() % (255))/255.0 green:(int)(arc4random() % (255))/255.0 blue:(int)(arc4random() % (255))/255.0 alpha:1];
}
- (void)loadData:(NSInteger)page {
    [self stopRefresh];
    [self.tableView reloadData];
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
    XABResource *sport = self.dataList[indexPath.row];
//    YBArticleViewController *article = [[YBArticleViewController alloc]initWithNewsId:[NSString stringWithFormat:@"%ld",sport.newsId]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.navigationController pushViewController:article animated:YES];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [_tableView registerClass:[XABResourceListCell class] forCellReuseIdentifier:NSStringFromClass([XABResourceListCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
@end
