//
//  XABClassJobViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassJobViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABCalendar.h"
#import "XABEnclosureViewController.h"

@interface XABClassJobViewController ()<XABCalendarDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *dateSelect;
@property(nonatomic, strong)XABCalendar *calendar;
@property(nonatomic, strong)UIView *calendarBgView;
@property(nonatomic, strong)UIButton *addEnclosureBtn;
@end

@implementation XABClassJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.dateSelect];
    [self.view addSubview:self.addEnclosureBtn];
    [self.dateSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
    }];
    
    [self.addEnclosureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateSelect.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
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

- (void)addEnclosureClick {
    [self pushToController:[XABEnclosureViewController new] animated:YES];
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
- (UIButton *)addEnclosureBtn {
    if (!_addEnclosureBtn) {
        _addEnclosureBtn = [UIButton buttonWithTitle:@"添加附件" fontSize:14 titleColor:[UIColor blackColor]];
        [_addEnclosureBtn addTarget:self action:@selector(addEnclosureClick) forControlEvents:UIControlEventTouchUpInside];
        [_addEnclosureBtn sizeToFit];
    }
    return _addEnclosureBtn;
}
@end
