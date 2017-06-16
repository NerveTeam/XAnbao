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
#import "XABClassRequest.h"

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
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:@(self.type) forKey:@"userType"];
    [pargam setSafeObject:self.classId forKey:@"classId"];
    [pargam setSafeObject:UserInfo.id forKey:@"userId"];
    [pargam setSafeObject:@(20) forKey:@"length"];
    [pargam setSafeObject:@(page) forKey:@"current"];
     [ClassNoticeList requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
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
         [self showMessage:@"网络异常"];
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
    article.articleId = sport.id;
    article.isReturn = sport.reply;
    article.isReceived = sport.replied;
    article.showType = ArticleTypeClass;
    article.isCatStatis = self.type == 2 ? YES : NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];
}






- (void)jumpPostNotice {
    XABPostNoticeViewController *notice = [XABPostNoticeViewController new];
    notice.classId = self.classId;
    notice.noticeType = NoticeTypeClass;
    [self.navigationController pushViewController:notice animated:YES];
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
        _postNotice.hidden = self.type == 1 ? YES : NO;
    }
    return _postNotice;
}
@end
