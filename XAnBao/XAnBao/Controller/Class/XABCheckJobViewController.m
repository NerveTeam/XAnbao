//
//  XABCheckJobViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/29.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABCheckJobViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABCalendar.h"
#import "XABEnclosureViewController.h"
#import "XABClassRequest.h"
#import "SPFollowSetingTeamView.h"
#import "NSArray+Safe.h"
#import "XABMemberListSelectorView.h"
#import "UILabel+Extention.h"
#import "CheckTaskViewController.h"

@interface XABCheckJobViewController ()<XABMemberListSelectorViewDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *dateSelect;
@property(nonatomic, strong)UIButton *peopleCheck;
@property(nonatomic, strong)UIButton *groupCheck;
@property(nonatomic, strong)XABCalendar *calendar;
@property(nonatomic, strong)UIView *calendarBgView;


// contentUI
// 左侧list
@property(nonatomic, strong)SPFollowSetingTeamView *setingTeamView;
// 左侧滚动条
@property(nonatomic, strong)UIView *rollSeparatorLine;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIView *contentClassView;
@property(nonatomic, strong)UIView *contentGroupView;
@property(nonatomic, strong)XABMemberListSelectorView *selectorView;

/// 数据
@property(nonatomic, strong)NSArray *subjectData;
@property(nonatomic, strong)NSArray *classListData;
@property(nonatomic, strong)NSArray *studentListData;
@property(nonatomic, strong)NSArray *studentGroupData;

@property(nonatomic, strong)NSDictionary *studentListGroupData;

// 当前选择的数据
@property(nonatomic, copy)NSString *selectSubjectId;
@property(nonatomic, strong)NSString *selectDate;
@property(nonatomic, copy)NSString *selectClassId;
@property(nonatomic, copy)NSString *selectSubjectName;
@end

@implementation XABCheckJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self requestGroupList];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateformatter stringFromDate:[NSDate date]];
    self.selectDate = dateStr;
    [self requestSubject];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)requestSubject {
    WeakSelf;
    [ClassGetSubjectRequest requestDataWithParameters:nil headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            weakSelf.subjectData = data;
            weakSelf.selectSubjectId = [data.firstObject objectForKey:@"id"];
            weakSelf.selectSubjectName = [data.firstObject objectForKey:@"name"];
            [weakSelf.setingTeamView setModel:data follow:nil];
            [weakSelf requestClassList];
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)requestClassList {
    WeakSelf;
    NSMutableDictionary *pagrm = [NSMutableDictionary dictionary];
    [pagrm setSafeObject:self.selectSubjectId forKey:@"subjectId"];
    [pagrm setSafeObject:self.selectDate forKey:@"date"];
    [HomeworkClassListRequest requestDataWithParameters:pagrm headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            weakSelf.classListData = data;
            weakSelf.selectClassId = [data.firstObject objectForKey:@"id"];
            [weakSelf requestStudentList];
            [weakSelf reloadClassUI];
        }else {
        [self showMessage:@"本课程无作业"];
        }
    } failureBlock:^(BaseDataRequest *request) {
        [self showMessage:@"本课程无作业"];
    }];
}

- (void)requestStudentList {
    WeakSelf;
    NSMutableDictionary *pagrm = [NSMutableDictionary dictionary];
    [pagrm setSafeObject:self.selectSubjectId forKey:@"subjectId"];
    [pagrm setSafeObject:self.selectDate forKey:@"date"];
    [pagrm setSafeObject:self.selectClassId forKey:@"classId"];
    [HomeworkStudentListRequest requestDataWithParameters:pagrm headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            weakSelf.studentListData = data;
            [weakSelf reloadStudentUI];
        }else {
        [self showMessage:@"本课程无作业"];
        }
    } failureBlock:^(BaseDataRequest *request) {
        [self showMessage:@"本课程无作业"];
    }];
}

- (void)requestGroupList {
    WeakSelf;
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
            weakSelf.studentGroupData = group.copy;
            [weakSelf reloadGroupUI];
            
            NSMutableDictionary *stuList = [NSMutableDictionary dictionary];
            for (NSDictionary *item in group) {
                NSString *fid = [item objectForKeySafely:@"id"];
            NSMutableArray *temp = [NSMutableArray array];
                for (NSDictionary *iitm in data) {
                    if ([fid isEqualToString:[iitm objectForKeySafely:@"parentId"]]) {
                        [temp addObject:iitm];
                    }
                }
                [stuList setSafeObject:temp forKey:fid];
            }
            self.studentListGroupData = stuList.copy;
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];

}


- (void)reloadClassUI {
    [self.contentView addSubview:self.contentClassView];
    [self.contentClassView removeAllSubviews];
    UIButton *lastItem = nil;
    for (NSInteger i = 0; i < self.classListData.count; i++) {
        NSDictionary *dic = [self.classListData safeObjectAtIndex:i];
        UIButton *secItem = [UIButton buttonWithTitle:[dic objectForKeySafely:@"name"] fontSize:15 titleColor:[UIColor blackColor]];
        secItem.tag = i;
        secItem.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentClassView addSubview:secItem];
        CGFloat Height = 50;
        CGFloat Y = i * Height;
        CGFloat width = self.contentView.width;
        secItem.frame = CGRectMake(0, Y, width, Height);
        [secItem addTarget:self action:@selector(classItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [UIView new];
        [secItem addSubview:line];
        line.backgroundColor = DefaultColor;
        line.frame = CGRectMake(0, Height-1, width, 1);
        lastItem = secItem;
    }
    
    [self.contentClassView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.offset(CGRectGetMaxY(lastItem.frame));
    }];
}

- (void)reloadStudentUI {
    if (self.selectorView) {
         [_selectorView removeFromSuperview];   
    }
        NSMutableArray *statis = [NSMutableArray array];
        NSMutableDictionary *nothing = [NSMutableDictionary dictionary];
        NSMutableDictionary *yes = [NSMutableDictionary dictionary];
        
        [nothing setSafeObject:@"未完成" forKey:@"schoolName"];
        [yes setSafeObject:@"已完成" forKey:@"schoolName"];
        
        NSMutableArray *noT = [NSMutableArray array];
        NSMutableArray *yesT = [NSMutableArray array];
        for (NSDictionary *item in self.studentListData) {
            BOOL confim = [[item objectForKeySafely:@"checked"] boolValue];
            NSString *name = [item objectForKeySafely:@"name"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setSafeObject:name forKey:@"name"];
            [dic setSafeObject:[item objectForKeySafely:@"id"] forKey:@"id"];
            if (confim) {
                [yesT addObject:dic];
            }else {
                [noT addObject:dic];
            }
        }
        [nothing setSafeObject:noT.copy forKey:@"teacherList"];
        [yes setSafeObject:yesT.copy forKey:@"teacherList"];
        
        [statis addObject:nothing.copy];
        [statis addObject:yes.copy];
        
        self.selectorView = [XABMemberListSelectorView memberListSelectorWithData:statis.copy isSchool:YES selectedData:nil];
        self.selectorView.delegate = self;
        [self.selectorView hideAllBtn];
        self.selectorView.elementSelEnable = YES;
        self.selectorView.titleBgColor = DefaultColor;
        self.selectorView.elementBgColor = [UIColor whiteColor];
        [self.contentView addSubview:self.selectorView];
        [self.selectorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentClassView.mas_bottom).offset(20);
            make.left.right.bottom.equalTo(self.contentView);
        }];
}


- (void)reloadGroupUI {
    for (NSInteger i = 0; i < self.studentGroupData.count; i++) {
        NSDictionary *dic = [self.studentGroupData safeObjectAtIndex:i];
        
        UIView *item = [UIView new];
        [self.contentGroupView addSubview:item];
        CGFloat Height = 50;
        CGFloat Y = i * Height;
        CGFloat width = self.contentGroupView.width;
        item.frame = CGRectMake(0, Y, width, Height);
        
        UILabel *name = [UILabel labelWithText:[dic objectForKeySafely:@"name"] fontSize:15 textColor:[UIColor blackColor]];
        
        [item addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.left.equalTo(item).offset(10);
        }];
        
        
        UIButton *btn = [UIButton buttonWithImageNormal:@"anzujianchazuoye_jianchazuoye" imageHighlighted:@"anzujianchazuoye_jianchazuoye"];
        
        [item addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.right.equalTo(item).offset(-10);
        }];
        btn.tag = i;
        [btn addTarget:self action:@selector(groupCheckJump:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [UIView new];
        [item addSubview:line];
        line.backgroundColor = DefaultColor;
        line.frame = CGRectMake(0, Height-1, width, 1);
    }
}

- (void)classItemClick:(UIButton *)item {
    NSDictionary *dic = [self.classListData safeObjectAtIndex:item.tag];
    self.selectClassId = [dic objectForKeySafely:@"id"];
    [self requestStudentList];
}

- (void)groupCheckJump:(UIButton *)sender {
    NSString *groupId = [[self.studentGroupData safeObjectAtIndex:sender.tag] objectForKey:@"id"];
    CheckTaskViewController *task = [CheckTaskViewController new];
    task.groupList = [self.studentListGroupData objectForKeySafely:groupId];
    task.courseId = self.selectSubjectId;
    task.courseName = self.selectSubjectName;
    task.isTeacher = YES;
    [self pushToController:task animated:YES];
}

- (void)clickItem:(NSString *)mid name:(NSString *)name{
    CheckTaskViewController *task = [CheckTaskViewController new];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setSafeObject:mid forKey:@"id"];
    [dic setSafeObject:name forKey:@"name"];
    task.groupList = @[dic];
    task.courseId = self.selectSubjectId;
    task.courseName = self.selectSubjectName;
    task.isTeacher = YES;
    [self pushToController:task animated:YES];
}


- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.dateSelect];
    [self.view addSubview:self.peopleCheck];
    [self.view addSubview:self.groupCheck];
    [self.view addSubview:self.setingTeamView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.contentGroupView];
    [self.setingTeamView addSubview:self.rollSeparatorLine];
    [self.dateSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
    }];
    
    [self.peopleCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateSelect);
        make.right.equalTo(self.groupCheck.mas_left).offset(-15);
        make.width.offset(_peopleCheck.width + 15);
    }];
    
    [self.groupCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateSelect);
        make.right.equalTo(self.view).offset(-10);
        make.width.offset(_groupCheck.width + 15);
    }];
    
    [self.setingTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateSelect.mas_bottom).offset(10);
        make.left.bottom.equalTo(self.view);
        make.width.offset(78);
    }];
    
    [self.rollSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setingTeamView);
        make.left.equalTo(self.setingTeamView);
        make.width.offset(4);
        make.height.offset([self.setingTeamView cellHeight]);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setingTeamView);
        make.left.equalTo(self.setingTeamView.mas_right).offset(10);
        make.right.bottom.equalTo(self.view);
    }];
    
    [self.contentGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setingTeamView);
        make.left.equalTo(self.setingTeamView.mas_right).offset(10);
        make.right.bottom.equalTo(self.view);
    }];
}

- (void)dateClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.calendarBgView];
    [window addSubview:self.calendar];
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.alpha = 1.0;
    }];
}


- (void)tapClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.alpha = 0.0;
        [self.calendarBgView removeFromSuperview];
    }completion:^(BOOL finished) {
        [self.calendar removeFromSuperview];
    }];
}

- (void)peopleClick {
    self.contentGroupView.hidden = YES;
    self.contentView.hidden = NO;
}

- (void)groupClick {
    self.contentGroupView.hidden = NO;
    self.contentView.hidden = YES;
}


- (void)calendarSelectDate:(NSString *)date {
    [self.dateSelect setTitle:date forState:UIControlStateNormal];
    self.selectDate = date;
    [self tapClick];
    [self requestClassList];
}


- (NSString *)dateFormatter:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"检查作业" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
- (UIButton *)dateSelect {
    if (!_dateSelect) {
        _dateSelect = [UIButton buttonWithTitle:[self dateFormatter:[NSDate date]] fontSize:14 titleColor:[UIColor blackColor]];
        
        [_dateSelect addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateSelect;
}
- (XABCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[XABCalendar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateSelect.frame), self.view.width, self.view.height - CGRectGetMaxY(self.dateSelect.frame))];
        _calendar.alpha = 0.0;
        _calendar.delegate = self;
    }
    return _calendar;
}
- (UIView *)calendarBgView {
    if (!_calendarBgView) {
        _calendarBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _calendarBgView.backgroundColor = [UIColor blackColor];
        _calendarBgView.alpha = 0.4;
        [_calendarBgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    }
    return _calendarBgView;
}

- (UIButton *)peopleCheck {
    if (!_peopleCheck) {
        _peopleCheck = [UIButton buttonWithTitle:@"按人检查" fontSize:14 titleColor:[UIColor blackColor]];
        [_peopleCheck sizeToFit];
        _peopleCheck.backgroundColor = DefaultColor;
        [_peopleCheck addTarget:self action:@selector(peopleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _peopleCheck;
}

- (UIButton *)groupCheck {
    if (!_groupCheck) {
        _groupCheck = [UIButton buttonWithTitle:@"按组检查" fontSize:14 titleColor:[UIColor blackColor]];
        [_groupCheck sizeToFit];
        _groupCheck.backgroundColor = DefaultColor;
        [_groupCheck addTarget:self action:@selector(groupClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupCheck;
}

- (SPFollowSetingTeamView *)setingTeamView {
    if (!_setingTeamView) {
        WeakSelf;
        _setingTeamView = [[SPFollowSetingTeamView alloc]initWithDidSelectCallBack:^(NSIndexPath *indexPath) {
                [self.rollSeparatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.setingTeamView).offset([self.setingTeamView cellHeight] * indexPath.row);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                }];
            weakSelf.selectSubjectId = [[self.subjectData safeObjectAtIndex:indexPath.row] objectForKey:@"id"];
            weakSelf.selectSubjectName = [[self.subjectData safeObjectAtIndex:indexPath.row] objectForKey:@"name"];
            [weakSelf.contentView removeAllSubviews];
            [weakSelf requestClassList];
        }];
        _setingTeamView.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _setingTeamView;
}
- (UIView *)rollSeparatorLine {
    if (!_rollSeparatorLine) {
        _rollSeparatorLine = [[UIView alloc]init];
        _rollSeparatorLine.backgroundColor = ThemeColor;
    }
    return _rollSeparatorLine;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIView *)contentClassView {
    if (!_contentClassView) {
        _contentClassView = [UIView new];
    }
    return _contentClassView;
}

- (UIView *)contentGroupView {
    if (!_contentGroupView) {
        _contentGroupView = [UIView new];
        _contentGroupView.hidden = YES;
    }
    return _contentGroupView;
}
@end
