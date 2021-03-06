//
//  XABIntranetNoticeViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABIntranetNoticeViewController.h"
#import "SDCycleScrollView.h"
#import "XABResource.h"
#import "XABResourceListCell.h"
#import "XABArticleViewController.h"
#import "XABSchoolRequest.h"
#import "NSArray+Safe.h"

@interface XABIntranetNoticeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;
@end

@implementation XABIntranetNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 1;
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
    [self loadData:_currentIndex];
    [self loadFoucsMap];
}

- (void)loadFoucsMap {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
    [SchoolFoucsMap requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            NSMutableArray *img = [NSMutableArray arrayWithCapacity:data.count];
            NSMutableArray *name = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *sub in data) {
                [img safeAddObject:[sub objectForKeySafely:@"url"]];
                [name safeAddObject:[sub objectForKeySafely:@"title"]];
            }
            weakSelf.cycleView.imageURLStringsGroup = img.copy;
        }
    } failureBlock:^(BaseDataRequest *request) {
        [weakSelf showMessage:[request.json objectForKeySafely:@"message"]];
    }];
}

- (void)loadData:(NSInteger)page {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
    [pargam setSafeObject:UserInfo.id forKey:@"userId"];
    [pargam setSafeObject:@(page) forKey:@"current"];
    [SchoolIntranetNotice requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
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
        [weakSelf stopRefresh];
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
    article.isReturn = sport.confirm;
    article.showType = ArticleTypeSchool;
    article.isCatStatis = [UserInfo.id isEqualToString:sport.createId];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];
}



#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height -  2 * TopBarHeight - StatusBarHeight)];
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

@end
