//
//  XABSearchViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/10.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSearchViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABSearchCell.h"
#import "NSArray+Safe.h"
#import "XABSchoolRequest.h"

@interface XABSearchViewController ()<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIView *topBar;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UISearchDisplayController *displayController;

@property(nonatomic, strong)UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *datalist;
// 搜索结果记录数组
@property (strong, nonatomic) NSMutableArray *resultList;

@property(nonatomic, strong)UIView *navigationBarBg;

@property(nonatomic, assign)NSInteger page;

@property(nonatomic, assign)BOOL isHandle;
@end

@implementation XABSearchViewController

static NSString *identifier = @"XABSearchViewController";

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page = 1;
    [self initView];
    self.datalist = [NSMutableArray new];
    [self loadData];
}


- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)loadData {
    WeakSelf;
    [SchoolSearchListTeacher requestDataWithParameters:@{@"current":@(_page)} headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *item in data) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setSafeObject:[item objectForKeySafely:@"id"] forKey:@"schoolId"];
                [dict setSafeObject:[item objectForKeySafely:@"name"] forKey:@"schoolName"];
                [list addObject:dict];
            }
            if (_page > 1) {
                [self.datalist addObjectsFromArray:list];
            }else {
                weakSelf.datalist = list;
            }
            [self stopRefresh];
            [self.tableView reloadData];
            [self.displayController.searchResultsTableView reloadData];
        }
        
    } failureBlock:^(BaseDataRequest *request) {
        [self stopRefresh];
        [self showMessage:@"网络异常"];
    }];
}
- (void)initView {
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.tableView];
}

- (void)stopRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView) {
        return self.datalist.count;
    }
        return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XABSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XABSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setTitle: tableView == self.tableView ? [self.datalist[indexPath.row] objectForKeySafely:@"schoolName"] : self.resultList[indexPath.row]];
    return cell;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.navigationController.navigationBar.hidden = NO;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{   self.navigationBarBg.hidden = NO;
    self.tableView.frame = CGRectMake(0, 20, self.view.width, SCREEN_HEIGHT - 20);
    return YES;
};

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationBarBg.hidden = YES;
        self.tableView.frame = CGRectMake(0, self.topBar.height, self.view.width    , SCREEN_HEIGHT - self.topBar.height);
    }];
    
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *foucsAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        // 发起关注请求
        if (tableView == self.tableView) {
            NSMutableDictionary *pargam = [NSMutableDictionary new];
            [pargam setSafeObject:UserInfo.id forKey:@"userId"];
            [pargam setSafeObject:[[self.datalist safeObjectAtIndex:indexPath.row] objectForKeySafely:@"schoolId"] forKey:@"schoolId"];
            [SchoolAddFollow requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
                [self.datalist removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                self.isHandle = YES;
            } failureBlock:^(BaseDataRequest *request) {
                [self showMessage:@"网络异常"];
            }];

        }else {
            NSMutableDictionary *pargam = [NSMutableDictionary new];
            [pargam setSafeObject:UserInfo.id forKey:@"userId"];
            [pargam setSafeObject:[[self.datalist safeObjectAtIndex:indexPath.row] objectForKeySafely:@"schoolId"] forKey:@"schoolId"];
            [SchoolAddFollow requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
                [self.resultList removeObjectAtIndex:indexPath.row];
                [self.displayController.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView reloadData];
                self.isHandle = YES;
            } failureBlock:^(BaseDataRequest *request) {
                [self showMessage:@"网络异常"];
            }];

        }

        tableView.editing = NO;
    }];
    return @[foucsAction];
}



#pragma mark 用用户输入的搜索内容进行查找
// 返回参数会让表格重新刷新数据
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 根据用户输入的内容，对现有表格数据内容进行匹配
    // 通过谓词对数组进行匹配
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchString];
    
    // 在查询之前需要清理或者初始化数组：懒加载
    if (self.resultList != nil) {
        
        [self.resultList removeAllObjects];
    }
    
    // 生成查询结果数组
    NSMutableArray *nameArray = [NSMutableArray array];
    for (NSDictionary *item in self.datalist) {
        [nameArray addObject:[item objectForKeySafely:@"schoolName"]];
    }
    self.resultList = [NSMutableArray arrayWithArray:[nameArray filteredArrayUsingPredicate:preicate]];
    
    // 返回YES，刷新表格
    return YES;
}
- (void)goBack {
    if (self.isHandle) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KSearchFollowDidFinish object:nil];
    }
}

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatusBarHeight + TopBarHeight)];
        UIButton *back = [UIButton buttonWithTitle:@"返回" fontSize:13];
        [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        _topBar = [_topBar topBarWithTintColor:ThemeColor title:@"搜索" titleColor:[UIColor whiteColor] leftView:back rightView:nil responseTarget:self];
    }
    return _topBar;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, TopBarHeight)];
        [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.height, self.view.width, self.view.height - self.topBar.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.searchBar;
        _tableView.rowHeight = 40;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [self loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData];
        }];

    }
    return _tableView;
}

- (UISearchDisplayController *)displayController {
    if (!_displayController) {
        _displayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _displayController.searchResultsDataSource = self;
        _displayController.searchResultsDelegate = self;
        _displayController.delegate = self;
        _displayController.displaysSearchBarInNavigationBar = NO ;
        _displayController.searchContentsController.navigationController.navigationBarHidden = YES ;
    }
    return _displayController;
}
- (UIView *)navigationBarBg {
    if (!_navigationBarBg) {
        _navigationBarBg = [UIView new];
        _navigationBarBg.backgroundColor = RGBCOLOR(201, 201, 206);
        _navigationBarBg.frame = CGRectMake(0, 0, self.view.width, StatusBarHeight);
        _navigationBarBg.hidden = YES;
        [self.topBar addSubview:_navigationBarBg];
    }
    return _navigationBarBg;
}
@end
