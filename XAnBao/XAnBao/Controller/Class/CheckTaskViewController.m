//
//  CheckTaskViewController.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "CheckTaskViewController.h"
#import "XABCalendar.h"
#import "CurriculumTableView.h"
#import "StatusTaskView.h"
#import "TaskContentView.h"
#import "FSResource.h"
#import "UIButton+Extention.h"
#import "XABClassRequest.h"
#import "UIView+TopBar.h"


@interface CheckTaskViewController () < XABCalendarDelegate,CurriculumTableViewDelegate, StatusTaskViewDelegate>
{
    NSString *studentId;

}
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property (strong, nonatomic) StatusTaskView *statusTView;
@property (strong, nonatomic) CurriculumTableView *curriculumView;
@property (strong, nonatomic) UIButton              *taskDateBtn;  // 日期按钮
@property(nonatomic, strong)XABCalendar *calendar;
@property(nonatomic, strong)UIView *calendarBgView;

@property(nonatomic, copy)NSString *selectStudentId;
@property(nonatomic, copy)NSString *selectDate;
@end

@implementation CheckTaskViewController

#pragma mark StatusTaskViewDelegate 
- (void)statusTaskViewCheckLink:(NSArray *)fileArray
{
    
}
- (void)statusTaskViewTaskContent:(NSString *)content
{
    [[TaskContentView shareInstance] showWithString:content];
}
#pragma mark barViewDelegate 私有

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectDate = [self dateFormatter:[NSDate date]];
    [self initTopView];
    [self initTableViews];
    [self initStudentList];
    [self initStudentTask];
    
}

- (void)initStudentList {
    self.curriculumView.datalist = self.groupList;
    [self.curriculumView reloadData];
    [self.curriculumView setDefaultSelected];
}

- (void)initStudentTask {
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setSafeObject:self.selectDate forKey:@"date"];
    [parm setSafeObject:self.courseId forKey:@"subjectId"];
    [parm setSafeObject:self.selectStudentId forKey:@"studentId"];
    [self.statusTView refreshStatusaskList:parm urlString:@"" isUp:NO];
    
}
#pragma mark - 成员方法
#pragma mark 设置界面

- (NSString *)dateFormatter:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}
- (void)initTopView {
    
    [self.view addSubview:self.topBarView];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topBarView.height, KScreenWidth, 40)];
    topView.backgroundColor = kCellSelectedBg;
    topView.layer.borderWidth = .3;
    topView.layer.borderColor = [kLineColor CGColor];
    [self.view addSubview:topView];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 115, 0, 100, 40)];
    label.font = HKUISystemFontT15;
    label.textColor = kLableTextColor;
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%@作业", self.courseName];
    [topView addSubview:label];
    
    self.taskDateBtn = [UIButton buttonWithTitle:[self dateFormatter:[NSDate date]] fontSize:14 titleColor:[UIColor blackColor]];
    
    self.taskDateBtn.frame = CGRectMake(15, 5, 100, 30);
    
    [self.taskDateBtn addTarget:self action:@selector(pullButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_taskDateBtn];
}
- (void)initTableViews
{
    // 学生列表
    self.curriculumView = [[CurriculumTableView alloc]initWithFrame:CGRectMake(0, self.topBarView.height + 40, 80, KScreenHeight - 104) style:UITableViewStyleGrouped];
    [_curriculumView setCurriculumDelegate:self];
    [self.view addSubview:_curriculumView];
    
    // 作业完成情况tableView
    self.statusTView = [[StatusTaskView alloc]initWithFrame:CGRectMake(80, self.topBarView.height + 40, KScreenWidth - 80, KScreenHeight - 104) style:UITableViewStyleGrouped];
    [_statusTView setStatusDelegate:self];
    [self.view addSubview:_statusTView];
}

#pragma mark - 监听事件
#pragma mark 选择日期
- (void)pullButtonAction {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.calendarBgView];
    [window addSubview:self.calendar];
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.alpha = 1.0;
    }];
}

#pragma mark - 代理方法

#pragma mark - 代理方法
- (void)curriculumTableViewSelectedRowAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)senderID withName:(NSString *)senderName
{
    self.selectStudentId = senderID;
    [self initStudentTask];
}

#pragma mark  选择日期代理方法

- (void)calendarSelectDate:(NSString *)date {
    self.selectDate = date;
    [_taskDateBtn setTitle:date forState:UIControlStateNormal];
    [self initStudentTask];
    [self tapClick];
}

- (XABCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[XABCalendar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBarView.frame) + 40, self.view.width, self.view.height - CGRectGetMaxY(self.topBarView.frame) +40)];
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

 
- (void)tapClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.alpha = 0.0;
        [self.calendarBgView removeFromSuperview];
    }completion:^(BOOL finished) {
        [self.calendar removeFromSuperview];
    }];
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
@end
