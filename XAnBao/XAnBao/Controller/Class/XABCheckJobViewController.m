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

@interface XABCheckJobViewController ()
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

/// 数据
@property(nonatomic, strong)NSArray *subjectData;
@end

@implementation XABCheckJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
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
//            self.subjectData = data;
            [weakSelf.setingTeamView setModel:data follow:nil];
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}
- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.dateSelect];
    [self.view addSubview:self.peopleCheck];
    [self.view addSubview:self.groupCheck];
    [self.view addSubview:self.setingTeamView];
    [self.setingTeamView addSubview:self.rollSeparatorLine];
    [self.dateSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
    }];
    
    [self.peopleCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateSelect);
        make.right.equalTo(self.groupCheck.mas_left).offset(-15);
    }];
    
    [self.groupCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateSelect);
        make.right.equalTo(self.view).offset(-10);
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




- (void)calendarSelectDate:(NSDate *)date {
    [self.dateSelect setTitle:[self dateFormatter:date] forState:UIControlStateNormal];
    [self tapClick];
}


- (NSString *)dateFormatter:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"今日作业" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
    }
    return _peopleCheck;
}

- (UIButton *)groupCheck {
    if (!_groupCheck) {
        _groupCheck = [UIButton buttonWithTitle:@"按组检查" fontSize:14 titleColor:[UIColor blackColor]];
        [_groupCheck sizeToFit];
    }
    return _groupCheck;
}

- (SPFollowSetingTeamView *)setingTeamView {
    if (!_setingTeamView) {
        _setingTeamView = [[SPFollowSetingTeamView alloc]initWithDidSelectCallBack:^(NSIndexPath *indexPath) {
                [self.rollSeparatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.setingTeamView).offset([self.setingTeamView cellHeight] * indexPath.row);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                }];
//            [self.setingTeamDetailedListView refreshData:self.dataList[indexPath.row] recordFollow:[self.followTeamList[indexPath.row] objectForKey:@"follow"]];
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
@end
