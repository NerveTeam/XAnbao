//
//  SPFollowSetingTeamView.m
//  sinaSports
//
//  Created by 磊 on 15/12/23.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import "SPFollowSetingTeamView.h"
#import "SPFollowSetingTeamViewCell.h"
#define DefaultColor RGBCOLOR(245, 245, 245)
#define SelectColor [UIColor whiteColor]

@interface SPFollowSetingTeamView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, copy)callBackBlock callBack;
@property(nonatomic, strong)NSArray *teamList;
@property(nonatomic, strong)NSMutableArray *selectList;
@property(nonatomic, strong)NSArray *dataList;
@property(nonatomic, strong)NSArray *followList;
@end
@implementation SPFollowSetingTeamView
{
    CGFloat cellHeight;
}

- (CGFloat)cellHeight {
    return cellHeight;
}

- (void)setModel:(NSArray *)list follow:(NSArray *)follow{
    self.dataList = list;
    self.followList = follow;
    [self reloadData];
    [self selectRow];

}

- (void)selectRow {
    [self selectRowAtIndexPath:[self.selectList lastObject] animated:NO scrollPosition:0];
}
- (void)showOrigin:(BOOL)isShowOrigin {
    NSIndexPath *indexPath = [self indexPathForSelectedRow];
    SPFollowSetingTeamViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    [cell showOrigin:isShowOrigin];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPFollowSetingTeamViewCell *cell = [SPFollowSetingTeamViewCell followSetingTeamViewCellWithtTableView:tableView];
    [cell setModel:self.dataList[indexPath.row] follow:self.followList];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
     SPFollowSetingTeamViewCell *teamCell = (SPFollowSetingTeamViewCell *)cell;
    if ([self.selectList containsObject:indexPath]) {
        teamCell.backgroundColor = SelectColor;
        [teamCell changeCellStyleSelect:YES isTop:NO];
        teamCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section]];
        [teamCell changeCellStyleSelect:NO isTop:YES];
        return;
    }
    teamCell.backgroundColor = DefaultColor;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SPFollowSetingTeamViewCell *teamCell = (SPFollowSetingTeamViewCell *)cell;
    if ([self.selectList containsObject:indexPath]) {
        teamCell.backgroundColor = DefaultColor;
        [teamCell changeCellStyleSelect:NO isTop:NO];
        teamCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section]];
        [teamCell changeCellStyleSelect:NO isTop:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_callBack) {
        _callBack(indexPath);
    }
    if (self.selectList.count > 0) {
        NSIndexPath *path =  [self.selectList lastObject];
        SPFollowSetingTeamViewCell *cell = [tableView cellForRowAtIndexPath:path];
        cell.backgroundColor = DefaultColor;
        [cell changeCellStyleSelect:NO isTop:NO];
        [self.selectList removeLastObject];
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:path.item - 1 inSection:path.section]];
        [cell changeCellStyleSelect:NO isTop:NO];
    }
    
    SPFollowSetingTeamViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [self.selectList addObject:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell changeCellStyleSelect:YES isTop:NO];
    
    cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section]];
    [cell changeCellStyleSelect:NO isTop:YES];
}

#pragma mark - init
- (instancetype)initWithDidSelectCallBack:(callBackBlock)callBack {
    if (self = [self init]) {
        self.callBack = callBack;
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.tableFooterView = [[UIView alloc]init];
    cellHeight = 60;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.selectList addObject:indexPath];
}

#pragma mark - lazy
- (NSMutableArray *)selectList {
    if (!_selectList) {
        _selectList = [[NSMutableArray alloc]init];
    }
    return _selectList;
}

@end
