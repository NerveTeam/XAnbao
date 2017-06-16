//
//  XABClassStudentDetailViewController.m
//  XAnBao
//
//  Created by Minlay on 17/6/12.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassStudentDetailViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABClassRequest.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "NSArray+Safe.h"
#import "ZZCheckBox.h"
@interface XABClassStudentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ZZCheckBoxDataSource,ZZCheckBoxDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *postBtn;
@property(nonatomic, strong)NSArray *result;
@property(nonatomic, strong)UITableView *resultTableview;
@property(nonatomic, strong)UIView *followObjectView;
@property(nonatomic, strong)ZZCheckBox *singCheckBox;
@property(nonatomic, assign)NSInteger selectCallIndex;
@property(nonatomic, strong)UIImageView *followBgView;
@property(nonatomic, strong)UIButton *cofBtn;
@end

@implementation XABClassStudentDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestInfo];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.resultTableview];
    [self.view addSubview:self.postBtn];
    
    [self.resultTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
    
}


- (void)requestInfo {
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    [pargam setSafeObject:self.sid forKey:@"id"];
    [ClassStudentDetail requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [[request.json objectForKeySafely:@"data"] objectForKeySafely:@"patriarchs"];
            self.result = data;
            [self.resultTableview reloadData];
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)follow {
    [self.view addSubview:self.followObjectView];
    [self.view addSubview:self.followBgView];
    [self.view addSubview:self.cofBtn];
    [self.followBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
    [self.cofBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.followBgView.mas_bottom).offset(-10);
        make.width.offset(self.followBgView.width - 20);
        make.height.offset(40);
    }];
    self.singCheckBox = [ZZCheckBox checkBoxWithCheckBoxType:CheckBoxTypeSingleCheckBox];
    self.singCheckBox.tag = 1;
    self.singCheckBox.delegate = self;
    self.singCheckBox.dataSource = self;
}

- (void)selectOk {
    [self.followObjectView removeFromSuperview];
    [self.followBgView removeFromSuperview];
    [self.cofBtn removeFromSuperview];
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    [pargam setSafeObject:UserInfo.name forKey:@"name"];
    [pargam setSafeObject:UserInfo.mobile forKey:@"mobilePhone"];
    [pargam setSafeObject:self.sid forKey:@"studentId"];
    [pargam setSafeObject:self.classId forKey:@"classId"];
    [pargam setSafeObject:[self getCall:self.selectCallIndex] forKey:@"appellation"];
    [ClassFollowStudent requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            [self showMessage:@"关注成功"];
        }else {
            [self showMessage:@"等待其他成员确认"];
        }
    } failureBlock:^(BaseDataRequest *request) {
            [self showMessage:@"等待其他成员确认"];
    }];
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
    
    UILabel *tip = [UILabel labelWithText:@"家长姓名:" fontSize:15 textColor:[UIColor blackColor]];
    [cell addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(10);
    }];
    
    UILabel *name = [UILabel labelWithText:[dic objectForKeySafely:@"appellation"] fontSize:15 textColor:[UIColor blackColor]];
    [cell addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.centerX.equalTo(cell);
    }];
    
    
    UILabel *iphone = [UILabel labelWithText:[dic objectForKeySafely:@"mobilePhone"] fontSize:15 textColor:[UIColor blackColor]];
    [cell addSubview:iphone];
    [iphone sizeToFit];
    [iphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-10);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


-(NSInteger)numberOfRowsInCheckBox:(ZZCheckBox *)checkBox {
    return 7;
}
-(CGRect)checkBox:(ZZCheckBox *)checkBox frameAtIndex:(NSInteger)index {
    return CGRectMake(70, 130 + 30 * index, 100, 30);
}
-(UIView *)checkBox:(ZZCheckBox *)checkBox supperViewAtIndex:(NSInteger)index {
    return self.followBgView;
}
-(NSString *)checkBox:(ZZCheckBox *)checkBox titleForCheckBoxAtIndex:(NSInteger)index {
   
    return [self getCall:index];
}
- (UIColor *)checkBox:(ZZCheckBox *)checkBox titleColorForCheckBoxAtIndex:(NSInteger)index {
    return [UIColor blackColor];
}
-(void)checkBox:(ZZCheckBox *)checkBox didDeselectedAtIndex:(NSInteger)index {
  
}
-(void)checkBox:(ZZCheckBox *)checkBox didSelectedAtIndex:(NSInteger)index {
    self.selectCallIndex = index;
}

- (NSString *)getCall:(NSInteger)index {
    if (index == 0) {
        return @"我是爸爸";
    }else if (index == 1) {
        return @"我是妈妈";
    }else if (index == 2) {
        return @"我是爷爷";
    }else if (index == 3) {
        return @"我是奶奶";
    }else if (index == 4) {
        return @"我是姥爷";
    }else if (index == 5) {
        return @"我是姥姥";
    }else if (index == 6) {
        return @"我是其他";
    }
    return nil;
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"学生信息" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"关注学生" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
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
- (UIView *)followObjectView {
    if (!_followObjectView) {
        _followObjectView = [UIView new];
        _followObjectView.backgroundColor = [UIColor blackColor];
        _followObjectView.alpha = 0.5;
        _followObjectView.frame = self.view.bounds;
    }
    return _followObjectView;
}
- (UIImageView *)followBgView {
    if (!_followBgView) {
        _followBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_msg_eidt"]];
        [_followBgView sizeToFit];
        _followBgView.userInteractionEnabled = YES;
    }
    return _followBgView;
}
- (UIButton *)cofBtn {
    if (!_cofBtn) {
        _cofBtn = [UIButton buttonWithTitle:@"确认" fontSize:15 titleColor:[UIColor whiteColor]];
        _cofBtn.backgroundColor = ThemeColor;
        _cofBtn.layer.cornerRadius = 5;
        _cofBtn.clipsToBounds = YES;
        [_cofBtn addTarget:self action:@selector(selectOk) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cofBtn;
}
@end
