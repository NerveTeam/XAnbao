//
//  XABClassFriendsViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassFriendsViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABClassMemberCell.h"
#import "XABResource.h"
@interface XABClassFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UISegmentedControl *segment;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, strong)NSMutableArray *teacherList;
@property(nonatomic, strong)NSMutableArray *parentList;
@end

@implementation XABClassFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    _currentIndex = 1;
    self.teacherList = [NSMutableArray array];
    self.parentList = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        XABResource *re = [XABResource new];
        re.title = @"我是老师某某某";
//        re.img = @[@"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=f0c5c08030d3d539c16807c70fb7c566/8ad4b31c8701a18bbef9f231982f07082838feba.jpg"];
        [self.teacherList addObject:re];
    }
    for (NSInteger i = 0; i < 10; i++) {
        XABResource *re = [XABResource new];
        re.title = @"我是家长某某某";
//        re.img = @[@"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=f0c5c08030d3d539c16807c70fb7c566/8ad4b31c8701a18bbef9f231982f07082838feba.jpg"];
        [self.parentList addObject:re];
    }
    [self loadData:_currentIndex];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)loadData:(NSInteger)page {
    [self stopRefresh];
    [self.tableView reloadData];
}
- (void)stopRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.topBarView.mas_bottom).offset(20);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.segment.mas_bottom).offset(20);
        make.bottom.equalTo(self.view);
    }];
}

- (void)segmentChange {
    [self loadData:_currentIndex++];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment.selectedSegmentIndex) {
        return self.parentList.count;
    }
    return self.teacherList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XABClassMemberCell *cell = [XABClassMemberCell classMemberCellWithTableView:tableView];
    cell.sportList = self.segment.selectedSegmentIndex ? self.parentList[indexPath.row] : self.teacherList[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    XABResource *sport = self.dataList[indexPath.row];
    //    XABArticleViewController *article = [[XABArticleViewController alloc]initWithUrl:@"https://sports.sina.cn/nba/warriors/2017-03-09/detail-ifychhuq3433755.d.html?vt=4&pos=10&HTTPS=1"];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self.navigationController pushViewController:article animated:YES];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"班级好友" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc]initWithItems:@[@"班级老师",@"班级家长"]];
        _segment.selectedSegmentIndex = 0;
        [_segment sizeToFit];
        [_segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentIndex = 1;
            [self loadData:_currentIndex];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadData:++_currentIndex];
        }];
    }
    return _tableView;
}
@end
