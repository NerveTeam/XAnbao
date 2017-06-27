//
//  XABClassMemberViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassMemberViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABClassMemberCell.h"
#import "XABResource.h"

#import "XABChatTool.h"
#import "XABMacro.h"
#import "XABGuardianHeaderView.h"
#import "XABClassMembersDetailnfoVC.h"
@interface XABClassMemberViewController ()<UITableViewDelegate,UITableViewDataSource,XABGuardianHeaderViewDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UISegmentedControl *segment;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, assign)NSInteger currentIndexSegmentFirst;
@property(nonatomic, assign)NSInteger currentIndexSegmentSecond;
@property(nonatomic, strong)NSMutableArray *teacherList;
@property(nonatomic, strong)NSMutableArray *studentList;
@property(nonatomic, strong)NSMutableArray *parentList;

// 所有标题行的字典
@property (strong, nonatomic) NSMutableDictionary *sectionDict;
@end

@implementation XABClassMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    _currentIndex = 1;
    
    _currentIndexSegmentFirst = 1;
    _currentIndexSegmentSecond = 1;
    
    self.sectionDict = [NSMutableDictionary dictionary];

    [self loadTeachersData:_currentIndexSegmentFirst];

}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)loadTeachersData:(NSInteger)page {
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        XABParamModel *model = [XABParamModel paramClassGradeTeachersWithClassId:self.classId];
        [[XABChatTool getInstance] getClassGradeTeachersWithRequestModel:model resultBlock:^(NSArray *sourceArray, NSError *error) {
            
            if (error == nil) {
                
                self.teacherList = [sourceArray mutableCopy];
                [self.tableView reloadData];
            }
            [self stopRefresh];
            
        }];
    }else{
        
        XABParamModel *model = [XABParamModel paramClassGradeTeachersWithClassId:self.classId];
        [[XABChatTool getInstance] getClassGradeStudentsWithRequestModel:model resultBlock:^(NSArray *sourceArray, NSError *error) {
            
            if (error == nil) {
                
                self.studentList = [sourceArray mutableCopy];
                
                if (_currentIndex == 1) {
                    
                    self.parentList = nil;
                }
                for (XABChatClassGradeStudentsModel *studentModel in self.studentList) {
                    
                        XABParamModel *model = [XABParamModel paramClassGradePatriarchWithStudentId:studentModel.id];
                        [[XABChatTool getInstance] getClassGradePatriarchWithRequestModel:model resultBlock:^(NSArray *sourceArray, NSError *error) {
                    
                            if (error == nil) {
                    
                                
                                [self.parentList addObject:sourceArray];
                            }
                            [self.tableView reloadData];

                        }];

                }
            }
            [self stopRefresh];
            
        }];
        
        
    }
    
    
}

- (void)guardianHeaderViewDidSelectedHeader:(XABGuardianHeaderView *)header{
    
    header.isOpen = header.isOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.section] withRowAnimation:UITableViewRowAnimationFade];
    
};

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
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        [self loadTeachersData:_currentIndex];

    }else{
        [self loadTeachersData:_currentIndex];

    }
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.segment.selectedSegmentIndex == 1) {
        
        return self.parentList.count;
    }
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment.selectedSegmentIndex == 1) {
        
        XABGuardianHeaderView *headerView = self.sectionDict[@(section)];
        NSInteger number = 0;
        number = ((NSArray *)self.parentList[section]).count;
        if (headerView.isOpen) {
            return number;
        }
        return 0;
    }else{
        
        return self.teacherList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = kLableContentColor;
    cell.detailTextLabel.textColor = kLableTextColor;
    cell.textLabel.font = kGlobaLableFont_13px;
    cell.detailTextLabel.font = kGlobaLableFont_13px;
    
    if (self.segment.selectedSegmentIndex == 1) {
        
        if (self.parentList.count >indexPath.row) {
            
            XABChatClassGradeStudentsParentsModel *model = self.parentList[indexPath.section][indexPath.row];
            cell.textLabel.text = model.name;
            cell.detailTextLabel.text = model.appellation;
        }
        
    }else{
        
        if (self.teacherList.count >indexPath.row) {
            
            XABChatClassGradeTeachersModel *model = self.teacherList[indexPath.row];
            cell.textLabel.text = model.subject;
            cell.detailTextLabel.text = model.name;
        }
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        return nil;
        
    }else{
        static NSString *Identifier = @"ClassParentHeaderViewIdentifier";
        
        XABGuardianHeaderView *headerView  = self.sectionDict[@(section)];
        if (headerView == nil) {
            headerView = [[XABGuardianHeaderView alloc]initWithReuseIdentifier:Identifier];
            [self.sectionDict setObject:headerView forKey:@(section)];
            
            [headerView setGuardianHeaderDelegate:self];
        }
        XABChatClassGradeStudentsModel *model = self.studentList[section];
        headerView.labelStudent.text = model.name;
        
        //    headerView.labelTelephoto.text = @"(15804826789)";
        
        headerView.section = section;
        return headerView;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        return 0.01;
        
    }else{
        
        
        return 44;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    XABGuardianHeaderView *headerView = self.sectionDict[@(section)];
    if (headerView.isOpen) {
        return 15;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        return 44;
        
    }else{
        
        return 44;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.segment.selectedSegmentIndex == 0) {
        
       
        if (self.teacherList.count >indexPath.row) {
            
            XABChatClassGradeTeachersModel *model = self.teacherList[indexPath.row];
            XABClassMembersDetailnfoVC *vc = [[XABClassMembersDetailnfoVC alloc] init];
            vc.id = model.id;
            vc.isTeacherOrParent = @"1";
            vc.type = self.type;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else{
        
        if (self.parentList.count >indexPath.row) {
            
            XABChatClassGradeStudentsParentsModel *model = self.parentList[indexPath.section][indexPath.row];
            XABClassMembersDetailnfoVC *vc = [[XABClassMembersDetailnfoVC alloc] init];
            vc.id = model.id;
            vc.isTeacherOrParent = @"0";
            vc.type = self.type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"班级成员" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
            _currentIndexSegmentFirst = 1;
            _currentIndexSegmentSecond = 1;
            if (self.segment.selectedSegmentIndex == 0) {
                
                [self loadTeachersData:_currentIndexSegmentFirst];
                
            }else{
                [self loadTeachersData:_currentIndexSegmentSecond];
                
            }
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if (self.segment.selectedSegmentIndex == 0) {
                
                [self loadTeachersData:++_currentIndexSegmentFirst];
                
            }else{
                [self loadTeachersData:++_currentIndexSegmentSecond];
                
            }
        }];
    }
    return _tableView;
}

#pragma mark -懒加载

-(NSMutableArray *)teacherList{
    if (!_teacherList) {
        _teacherList = [[NSMutableArray alloc] init];
    }
    return _teacherList;
}
-(NSMutableArray *)parentList{
    if (!_parentList) {
        _parentList = [[NSMutableArray alloc] init];
    }
    return _parentList;
}
-(NSMutableArray *)studentList{
    if (!_studentList) {
        _studentList = [[NSMutableArray alloc] init];
    }
    return _studentList;
}

@end
