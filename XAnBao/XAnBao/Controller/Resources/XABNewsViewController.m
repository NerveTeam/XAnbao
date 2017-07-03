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
#import "XABArticleViewController.h"
#import "XABResourceRequest.h"
#import "NSArray+Safe.h"

@interface XABNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;
@end

@implementation XABNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 1;
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
    [self loadData:_currentIndex];
}
- (void)loadData:(NSInteger)page {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.channelId forKey:@"programId"];
    [pargam setSafeObject:@(page) forKey:@"current"];
    [XABResourceFeedListRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSDictionary *data = [request.json objectForKeySafely:@"data"];
            NSArray *results = [data objectForKeySafely:@"results"];
            if (page > 1) {
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataList];
                [temp addObjectsFromArray:[XABResource mj_objectArrayWithKeyValuesArray:results]];
                self.dataList = temp.copy;
            }else {
                self.dataList = [XABResource mj_objectArrayWithKeyValuesArray:results];
            }
        }
        
        [weakSelf stopRefresh];
        [weakSelf.tableView reloadData];
    } failureBlock:^(BaseDataRequest *request) {
        [self showMessage:[request.json objectForKeySafely:@"message"]];
    }];
}


- (void)stopRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
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
    XABArticleViewController *article = [[XABArticleViewController alloc]initWithUrl:sport.url];
    article.showType = ArticleTypeNone;
    article.articleId = sport.id;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];

}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - TabBarHeight -  TopBarHeight - StatusBarHeight)];
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
