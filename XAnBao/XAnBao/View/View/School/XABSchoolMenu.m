//
//  XABSchoolMenu.m
//  XAnBao
//
//  Created by Minlay on 17/3/8.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolMenu.h"
#import "XABSchoolMenuCell.h"

@interface XABSchoolMenu ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)NSArray *menuList;
@property(nonatomic, strong)UITableView *menuListView;
@end
@implementation XABSchoolMenu

static int rowHeight = 40;

+ (instancetype)schoolMenuList:(NSArray *)list {
    XABSchoolMenu *menu = [[XABSchoolMenu alloc]init];
    menu.menuList = list;
    menu.frame = CGRectMake(0, TopBarHeight + StatusBarHeight, SCREEN_WIDTH, rowHeight * list.count);
    [menu show];
    return menu;
}


- (void)show {
    [self.menuListView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.menuListView.height = self.height;
    }];
}
- (void)hide:(hideBlock)callBack {
    [UIView animateWithDuration:0.5 animations:^{
        self.menuListView.height = 0;
    }completion:^(BOOL finished) {
        callBack();
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XABSchoolMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XABSchoolMenuCell"];
    if (!cell) {
        cell = [[XABSchoolMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XABSchoolMenuCell"];
    }
    [cell setModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *cancelAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"dd");
        tableView.editing = NO;
    }];
    cancelAction.backgroundColor = [UIColor redColor];
    UITableViewRowAction *defaultAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"dd");
        tableView.editing = NO;
    }];
    defaultAction.backgroundColor = [UIColor blueColor];
    return @[defaultAction,cancelAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (UITableView *)menuListView {
    if (!_menuListView) {
        _menuListView = [[UITableView alloc]initWithFrame:self.bounds];
        _menuListView.delegate = self;
        _menuListView.dataSource = self;
        _menuListView.height = 0;
        [self addSubview:_menuListView];
    }
    return _menuListView;
}

@end
