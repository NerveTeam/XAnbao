//
//  XABSearchViewController.m
//  XAnBao
//
//  Created by Minlay on 17/6/9.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassSearchViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABClassRequest.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "NSArray+Safe.h"
#import "XABSearchStudentViewController.h"

@interface XABClassSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UITextField *inputPhoto;
@property(nonatomic, strong)UIButton *postBtn;
@property(nonatomic, strong)NSArray *result;
@property(nonatomic, strong)UITableView *resultTableview;
@end

@implementation XABClassSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.inputPhoto];
    [self.view addSubview:self.postBtn];
    [self.view addSubview:self.resultTableview];
    
    [self.inputPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.topBarView.mas_bottom).offset(10);
        make.right.equalTo(self.postBtn.mas_left).offset(-10);
        make.height.offset(30);
    }];
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputPhoto);
        make.width.offset(50);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(30);
    }];
    
    [self.resultTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputPhoto.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)search {
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    [pargam setSafeObject:self.inputPhoto.text forKey:@"mobilePhone"];
[ClassSearchTeacher requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
    NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
    if (code == 200) {
        NSArray *data = [request.json objectForKeySafely:@"data"];
        self.result = data;
        [self.resultTableview reloadData];
    }
} failureBlock:^(BaseDataRequest *request) {
    
}];
}

- (void)enterClick:(UIButton *)sender {
    NSDictionary *dic = [self.result safeObjectAtIndex:sender.tag];
    XABSearchStudentViewController *stu = [XABSearchStudentViewController new];
    stu.classId = [dic objectForKeySafely:@"classId"];
    [self pushToController:stu animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XABClassSearchViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XABClassSearchViewController"];
    }
    [cell removeAllSubviews];
    NSDictionary *dic = [self.result safeObjectAtIndex:indexPath.row];
    UILabel *name = [UILabel labelWithText:[dic objectForKeySafely:@"className"] fontSize:15 textColor:[UIColor blackColor]];
    [cell addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(10);
    }];
    
    UIButton *enter = [UIButton buttonWithTitle:@"进入" fontSize:15];
    enter.tag = indexPath.row;
    enter.layer.cornerRadius = 5;
    enter.clipsToBounds = YES;
    [enter setTitleColor:ThemeColor forState:UIControlStateNormal];
    enter.layer.borderWidth = 1;
    enter.layer.borderColor = ThemeColor.CGColor;
    [enter addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:enter];
    [enter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-10);
        make.width.offset(40);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"搜索" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
- (UITextField *)inputPhoto {
    if (!_inputPhoto) {
        _inputPhoto = [UITextField new];
        _inputPhoto.backgroundColor = [UIColor whiteColor];
        _inputPhoto.placeholder = @"输入教师手机号";
        _inputPhoto.font = [UIFont systemFontOfSize:15];
    }
    return _inputPhoto;
}

- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"搜索" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
- (UITableView *)resultTableview {
    if (!_resultTableview) {
        _resultTableview = [UITableView new];
        _resultTableview.delegate = self;
        _resultTableview.dataSource = self;
    }
    return _resultTableview;
}
@end
