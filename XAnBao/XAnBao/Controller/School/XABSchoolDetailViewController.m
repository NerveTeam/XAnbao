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
#import "XABSchoolRequest.h"
#import "XABSchoolMessage.h"
#import "NSArray+Safe.h"

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
    [self loadFoucsMap];
    [self loadData:_currentIndex];
}

- (void)setup {
    _currentIndex = 1;
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}
- (void)loadFoucsMap {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.schollId forKey:@"schoolId"];
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
            self.cycleView.imageURLStringsGroup = img.copy;
        }
    } failureBlock:^(BaseDataRequest *request) {
        [self showMessage:[request.json objectForKeySafely:@"message"]];
    }];
}


- (void)loadData:(NSInteger)page {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.schollId forKey:@"schoolId"];
    [pargam setSafeObject:self.channelId forKey:@"itemId"];
    [pargam setSafeObject:@(page) forKey:@"current"];
    [SchoolFeedList requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
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

- (void)enterIntranet {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.schollId forKey:@"schoolId"];
    [pargam setSafeObject:UserInfo.id forKey:@"userId"];
    [SchoolEnterIntranetJudgeTeacher requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
         BOOL judge = [[request.json objectForKeySafely:@"data"]boolValue];
        if (judge) {
            XABSchoolIntranetViewController *intranet = [XABSchoolIntranetViewController new];
            intranet.schoolId = self.schollId;
            [self.navigationController pushViewController:intranet animated:YES];
        }else {
            [weakSelf showMessage:@"无权进入"];
        }
    } failureBlock:^(BaseDataRequest *request) {
            [weakSelf showMessage:@"网络异常"];
    }];
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
