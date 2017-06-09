//
//  XABSelectPeopleGroupViewController.m
//  XAnBao
//
//  Created by Minlay on 17/5/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSelectPeopleGroupViewController.h"
#import "UILabel+Extention.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABSchoolRequest.h"
#import "XABClassRequest.h"
#import "XABNewGroupViewController.h"
#import "XABMemberListSelectorView.h"
#import "XABSelectGroupCell.h"
#import "NSArray+Safe.h"

@interface XABSelectPeopleGroupViewController ()<UITableViewDelegate,UITableViewDataSource,XABSelectGroupCellDelegate>
@property(nonatomic,strong)NSMutableArray *selectGroupList;
@property(nonatomic,strong)NSMutableArray *selectPeopleList;
@property(nonatomic,strong)NSArray *groupList;
@property(nonatomic,strong)NSArray *teacherMemberList;
@property(nonatomic, strong)UIView *topBar;
@property(nonatomic, strong)UIButton *backView;
@property(nonatomic, strong)UIView *existGroupView;
@property(nonatomic, strong)UIButton *existOpenBtn;
@property(nonatomic, strong)UIButton *newGroupBtn;
@property(nonatomic, strong)UITableView *existTableview;
@property(nonatomic, strong)XABMemberListSelectorView *selectorView;
@property(nonatomic, strong)UIButton *postBtn;
@end

@implementation XABSelectPeopleGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self loadData];
    [self setup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:NewGroupDidFinish object:nil];
}

- (void)loadData {
    [self requestTeacherGroup];
    [self requestTeacherList];
}

- (void)selectListFinsih {
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    [pargam setSafeObject:self.selectGroupList.copy forKey:@"groupList"];
    [pargam setSafeObject:self.selectorView.selectList.copy forKey:@"teacherList"];
    [[NSNotificationCenter defaultCenter]postNotificationName:KSelectGroupListDidFinish object:nil userInfo:pargam.copy];
    [self popViewControllerAnimated:YES];

}
- (void)openOrFold {
    WeakSelf;
    if (self.existOpenBtn.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.existOpenBtn.transform = CGAffineTransformMakeRotation(M_PI);
            weakSelf.existTableview.height = 60;
            [weakSelf.existTableview reloadData];
        }];
    }else {
       [UIView animateWithDuration:0.5 animations:^{
           self.existOpenBtn.transform = CGAffineTransformIdentity;
           weakSelf.existTableview.height = 200;
           [weakSelf.existTableview reloadData];
       }];
    }
    [self.existOpenBtn setSelected:!self.existOpenBtn.isSelected];
}

- (void)newGroupClick {
    XABNewGroupViewController *new = [XABNewGroupViewController new];
    new.schoolId = _schoolId;
    new.classId = _classId;
    new.isScholl = _isScholl;
    new.memberList = self.teacherMemberList;
    [self pushToController:new animated:YES];
}


- (void)requestTeacherGroup {
    if (self.isScholl) {
        NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
        [pargam setSafeObject:UserInfo.id forKey:@"userId"];
        [SchoolGetTeacherGroup requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                NSArray *data = [request.json objectForKeySafely:@"data"];
                NSMutableArray *group = [NSMutableArray array];
                for (NSDictionary *item in data) {
                    NSInteger type = [[item objectForKeySafely:@"type"]longValue];
                    if (type == 1) {
                        [group addObject:item];
                    }
                    
                }
                self.groupList = group.copy;
                [self.existTableview reloadData];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
    }else {
        NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
        [pargam setSafeObject:UserInfo.mobile forKey:@"mobilePhone"];
        [ClassGetStudentGroup requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                NSArray *data = [request.json objectForKeySafely:@"data"];
                NSMutableArray *group = [NSMutableArray array];
                for (NSDictionary *item in data) {
                    NSString *parentId = [item objectForKeySafely:@"parentId"];
                    if ([parentId isEqualToString:@"0"]) {
                        [group addObject:item];
                    }
                    
                }
                self.groupList = group.copy;
                [self.existTableview reloadData];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
    }
   
}

- (void)requestTeacherList {
    if (self.isScholl) {
        NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
        [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
        [SchoolGetTeacherList requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                NSArray *data = [request.json objectForKeySafely:@"data"];
                [self parseTeachAndSchoolData:data];
            }
        } failureBlock:^(BaseDataRequest *request) {
        }];
    }else {
        NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
        [pargam setSafeObject:UserInfo.mobile forKey:@"mobilePhone"];
        [ClassGetStudentList requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                NSArray *data = [request.json objectForKeySafely:@"data"];
                [self parseTeachAndSchoolData:data];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
    }
}

- (void)parseTeachAndSchoolData:(NSArray *)dataList {
    NSMutableArray *schoolList = [NSMutableArray array];
    NSMutableArray *teacherList = [NSMutableArray array];
    for (NSDictionary *element in dataList) {
        NSString *parentId = [element objectForKeySafely:@"parentId"];
        if ([parentId isEqualToString:@"0"]) {
            [schoolList addObject:element];
        }else {
            [teacherList addObject:element];
        }
    }
    
    NSMutableArray *teacherMemberList = [NSMutableArray arrayWithCapacity:schoolList.count];
    
    for (NSDictionary *school in schoolList) {
        NSMutableDictionary *schoolItem = [NSMutableDictionary dictionary];
        NSString *schoolId = [school objectForKeySafely:@"id"];
        [schoolItem setSafeObject:schoolId forKey:@"schoolId"];
        [schoolItem setSafeObject:[school objectForKeySafely:@"name"] forKey:@"schoolName"];
        NSMutableArray *teacherlist = [NSMutableArray array];
        
        for (NSDictionary *teacher in teacherList) {
            NSString *parentId = [teacher objectForKeySafely:@"parentId"];
            if ([parentId isEqualToString:schoolId]) {
                [teacherlist addObject:teacher];
            }
        }
        
        [schoolItem setSafeObject:teacherlist forKey:@"teacherList"];
        [teacherMemberList addObject:schoolItem];
    }
    
    self.teacherMemberList = teacherMemberList.copy;
    self.selectorView = [XABMemberListSelectorView memberListSelectorWithData:self.teacherMemberList isSchool:_isScholl];
    [self.view addSubview:self.selectorView];
    [self.selectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.existTableview.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.view bringSubviewToFront:self.postBtn];
}

- (void)setup {
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.existTableview];
    [self.existGroupView addSubview:self.existOpenBtn];
    [self.existOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.existGroupView);
        make.right.equalTo(self.existGroupView).offset(-10);
    }];
    
    [self.view addSubview:self.postBtn];
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
}



#pragma - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.existOpenBtn.isSelected) {
        return [UITableViewCell new];
    }
    XABSelectGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XABSelectGroupCell"];
    if (!cell) {
        cell = [[XABSelectGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XABSelectGroupCell"];
    }
    cell.delegate = self;
    [cell setModel:[self.groupList safeObjectAtIndex:indexPath.row]];
    return cell;
}

- (void)selectGroupList:(NSString *)groupId {
    if ([self.selectGroupList containsObject:groupId]) {
        [self.selectGroupList removeObject:groupId];
    }else {
        [self.selectGroupList addObject:groupId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.existOpenBtn.isSelected) {
        return 40;
    }
    return 0;
}


- (NSMutableArray *)selectGroupList {
    if (!_selectGroupList) {
        _selectGroupList = [NSMutableArray array];
    }
    return _selectGroupList;
}

- (NSMutableArray *)selectPeopleList {
    if (_selectPeopleList) {
        _selectPeopleList = [NSMutableArray array];
    }
    return _selectPeopleList;
}

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        _topBar = [_topBar topBarWithTintColor:ThemeColor title:_isScholl ? @"选择接收教师":@"选择接收学生" titleColor:[UIColor whiteColor] leftView:self.backView rightView:nil responseTarget:self];
    }
    return _topBar;
}
- (UIButton *)backView {
    if (!_backView) {
        _backView = [UIButton buttonWithTitle:@"返回" fontSize:14 titleColor:[UIColor whiteColor]];
    }
    return _backView;
}


- (UIView *)existGroupView {
    if (!_existGroupView) {
        _existGroupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        UILabel *tip = [UILabel labelWithText:@"" fontSize:15 textColor:[UIColor blackColor]];
        tip.text = _isScholl ? @"教师已建组" : @"学生已建组";
        [tip sizeToFit];
        [_existGroupView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(_existGroupView);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lightTextColor];
        [_existGroupView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_existGroupView).offset(-1);
            make.left.right.equalTo(_existGroupView);
            make.height.offset(1);
        }];
        
    }
    return _existGroupView;
}
- (UIButton *)existOpenBtn {
    if (!_existOpenBtn) {
        _existOpenBtn = [UIButton buttonWithImageNormal:@"class_job_arrowIcon" imageSelected:@"class_job_arrowIcon"];
        [_existOpenBtn addTarget:self action:@selector(openOrFold) forControlEvents:UIControlEventTouchUpInside];
        [_existOpenBtn sizeToFit];
        [_existOpenBtn setSelected:YES];
    }
    return _existOpenBtn;
}
- (UITableView *)existTableview {
    if (!_existTableview) {
        _existTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.height + 10, self.view.width, 200) style:UITableViewStylePlain];
        _existTableview.tableHeaderView = self.existGroupView;
        _existTableview.tableFooterView = self.newGroupBtn;
        _existTableview.delegate = self;
        _existTableview.dataSource = self;
        _existTableview.tag = 1;
    }
    return _existTableview;
}
- (UIButton *)newGroupBtn {
    if (!_newGroupBtn) {
        _newGroupBtn = [UIButton buttonWithTitle:@"新建" fontSize:14 titleColor:[UIColor blueColor]];
        _newGroupBtn.frame = CGRectMake(0, 0, self.view.width, 30);
        [_newGroupBtn addTarget:self action:@selector(newGroupClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newGroupBtn;
}
- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"确认" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(selectListFinsih) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NewGroupDidFinish object:nil];
}
@end
