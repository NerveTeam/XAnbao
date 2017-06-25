//
//  XABHomeworkViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/29.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABHomeworkViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABCalendar.h"
#import "XABEnclosureViewController.h"
#import "XABSelectView.h"
#import "XABClassRequest.h"
#import "NSArray+Safe.h"
#import "XABSelectPeopleGroupViewController.h"
#import "UILabel+Extention.h"
#import "XABHomeworkCell.h"
#import "NSArray+Safe.h"
#import "NSString+URLEncode.h"
#import "XABHomework.h"

@interface XABHomeworkViewController ()<XABCalendarDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,XABHomeworkCellDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIView *layerBgView;
@property(nonatomic, strong)XABCalendar *calendar;
@property(nonatomic, strong)XABSelectView *calendarClickView;
@property(nonatomic, strong)XABSelectView *subjectClickView;
@property(nonatomic, strong)XABSelectView *studentGroupClickView;
@property(nonatomic, strong)XABSelectView *statisClickView;
@property(nonatomic, strong)UITableView *homeworkTableview;
@property(nonatomic, strong)UIView *addHomeworkView;
// 原始数据
@property(nonatomic, strong)NSArray *subjectData;

// 选中数据
@property(nonatomic, strong)NSDictionary *selectSubjectData;
@property(nonatomic, strong)NSDate *selectDate;
@property(nonatomic, strong)NSDictionary *selectGroupData;
@property(nonatomic, assign)NSInteger currentHandleIndex;
// 作业数据
@property(nonatomic, strong)NSMutableArray *homeworkData;
@property(nonatomic, strong)UIButton *addEnclosureBtn;
@property(nonatomic, strong)UIButton *postBtn;
@end

@implementation XABHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestSubjectInfo];
    [self setup];
    [self addNotification];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.calendarClickView];
    [self.view addSubview:self.subjectClickView];
    [self.view addSubview:self.studentGroupClickView];
    [self.view addSubview:self.homeworkTableview];
    [self.view addSubview:self.postBtn];
    [self.calendarClickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [self.subjectClickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarClickView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [self.studentGroupClickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subjectClickView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    [self.homeworkTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentGroupClickView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.postBtn.mas_top);
    }];
    
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
    
}



#pragma mark - itemClick
- (void)dateClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.layerBgView];
    [window addSubview:self.calendar];
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.alpha = 1.0;
    }];
}
- (void)tapClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.alpha = 0.0;
        [self.layerBgView removeFromSuperview];
    }completion:^(BOOL finished) {
        [self.calendar removeFromSuperview];
    }];
}
- (void)subjectClick {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择对象" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary *item in self.subjectData) {
        [sheet addButtonWithTitle:[item objectForKeySafely:@"name"]];
    }
    [sheet showInView:self.view];
}

- (void)studentClick {
    XABSelectPeopleGroupViewController *group  = [XABSelectPeopleGroupViewController new];
    group.isScholl = NO;
    group.classId = self.classId;
    group.selectedInfo = self.selectGroupData;
    [self pushToController:group animated:YES];
}

- (void)addHomeworkClick {
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    [pargam setSafeObject:@"" forKey:@"contents"];
    [pargam setSafeObject:@"0" forKey:@"reply"];
    NSMutableArray *attachments = [NSMutableArray array];
    [pargam setSafeObject:attachments forKey:@"attachments"];
    [self.homeworkData addObject:pargam];
    [self.homeworkTableview reloadData];
}

- (void)postHomework {
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
//    [parma setSafeObject:self.selectDate forKey:@"assignDate"];
    [parma setSafeObject:[self.selectSubjectData objectForKeySafely:@"id"] forKey:@"subjectId"];
    [parma setSafeObject:[self.selectSubjectData objectForKeySafely:@"name"]forKey:@"subjectName"];
    [parma setSafeObject:[self.selectGroupData objectForKeySafely:@"groupList"]forKey:@"groups"];
    [parma setSafeObject:[self.selectGroupData objectForKeySafely:@"teacherList"]forKey:@"students"];
    [parma setSafeObject:self.homeworkData.copy forKey:@"contents"];
    
    [ClassPostHomeworkRequest requestDataWithParameters:@{@"json":[[self dictionaryToJson:parma] URLEncodedString]} headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            [self showMessage:@"留作业成功"];
        }
        else {
        [self showMessage:@"留作业失败"];
        }
    } failureBlock:^(BaseDataRequest *request) {
    }];
}

- (NSString *)dictionaryToJson:(NSObject *)obj
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma maek - delegate
- (void)calendarSelectDate:(NSDate *)date {
    [self.calendarClickView showContentText:[self dateFormatter:date]];
    self.selectDate = date;
    [self tapClick];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        NSLog(@"点击了取消");
    }
    else {
        self.selectSubjectData = [self.subjectData safeObjectAtIndex:buttonIndex - 1];
        [self.subjectClickView showContentText:[self.selectSubjectData objectForKeySafely:@"name"]];
    }
}

- (void)deleteHomework:(XABHomeworkCell *)cell {
    NSIndexPath *path = [self.homeworkTableview indexPathForCell:cell];
    [self.homeworkData removeObjectAtIndex:path.row];
    [self.homeworkTableview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)contentInputFinish:(NSString *)text cell:(XABHomeworkCell *)cell {
    NSIndexPath *path = [self.homeworkTableview indexPathForCell:cell];
    NSMutableDictionary *dic = [self.homeworkData safeObjectAtIndex:path.row];
    [dic setSafeObject:text forKey:@"contents"];
}

- (void)addEnclosureClick:(XABHomeworkCell *)cell {
    NSIndexPath *path = [self.homeworkTableview indexPathForCell:cell];
    self.currentHandleIndex = path.row;
    [self pushToController:[XABEnclosureViewController new] animated:YES];
}

- (void)returnClick:(BOOL)isReturn cell:(XABHomeworkCell *)cell {
    NSIndexPath *path = [self.homeworkTableview indexPathForCell:cell];
    NSMutableDictionary *dic = [self.homeworkData safeObjectAtIndex:path.row];
    [dic setSafeObject:[NSString stringWithFormat:@"%d",isReturn] forKey:@"reply"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeworkData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XABHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XABHomeworkCell"];
    if (!cell) {
        cell = [[XABHomeworkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XABHomeworkCell"];
    }
    cell.delegate = self;
    [cell setmodel:[self.homeworkData safeObjectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
//    return 100;
//}



#pragma mark - request

- (void)requestSubjectInfo {
//    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
//    [pargam setSafeObject:self.inputPhoto.text forKey:@"name"];
//    [pargam setSafeObject:self.classId forKey:@"classId"];
    [ClassGetSubjectRequest requestDataWithParameters:nil headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            self.subjectData = data;
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
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
- (XABCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[XABCalendar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarClickView.frame), self.view.width, self.view.height - CGRectGetMaxY(self.calendarClickView.frame))];
        _calendar.alpha = 0.0;
        _calendar.delegate = self;
    }
    return _calendar;
}

- (XABSelectView *)calendarClickView {
    if (!_calendarClickView) {
        _calendarClickView = [XABSelectView selectWithTitle:@"选择日期"];
        [_calendarClickView addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calendarClickView;
}
- (UIView *)layerBgView {
    if (!_layerBgView) {
        _layerBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _layerBgView.backgroundColor = [UIColor blackColor];
        _layerBgView.alpha = 0.4;
        [_layerBgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    }
    return _layerBgView;
}
- (XABSelectView *)subjectClickView {
    if (!_subjectClickView) {
        _subjectClickView = [XABSelectView selectWithTitle:@"选择科目"];
        [_subjectClickView addTarget:self action:@selector(subjectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subjectClickView;
}

- (XABSelectView *)studentGroupClickView {
    if (!_studentGroupClickView) {
        _studentGroupClickView = [XABSelectView selectWithTitle:@"选择学生"];
        [_studentGroupClickView addTarget:self action:@selector(studentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _studentGroupClickView;
}

- (XABSelectView *)statisClickView {
    if (!_statisClickView) {
        _statisClickView = [XABSelectView selectWithTitle:@"是否统计"];
//        [_statisClickView addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    }
    return _statisClickView;
}
- (UIButton *)addEnclosureBtn {
    if (!_addEnclosureBtn) {
        _addEnclosureBtn = [UIButton buttonWithTitle:@"添加附件" fontSize:14 titleColor:[UIColor blackColor]];
        [_addEnclosureBtn addTarget:self action:@selector(addEnclosureClick) forControlEvents:UIControlEventTouchUpInside];
        [_addEnclosureBtn sizeToFit];
    }
    return _addEnclosureBtn;
}

- (UITableView *)homeworkTableview {
    if (!_homeworkTableview) {
        _homeworkTableview = [[UITableView alloc]init];
        _homeworkTableview.delegate = self;
        _homeworkTableview.dataSource = self;
        _homeworkTableview.tableFooterView = self.addHomeworkView;
    }
    return _homeworkTableview;
}
- (UIView *)addHomeworkView {
    if (!_addHomeworkView) {
        _addHomeworkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        UIButton *add = [UIButton buttonWithImageNormal:@"class_job_add" imageSelected:@"class_job_add"];
        [_addHomeworkView addSubview:add];
        [add mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_addHomeworkView);
            make.left.equalTo(_addHomeworkView).offset(10);
        }];
        [add addTarget:self action:@selector(addHomeworkClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *tip = [UILabel labelWithText:@"添加作业" fontSize:14 textColor:[UIColor blackColor]];
        [_addHomeworkView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_addHomeworkView);
            make.left.equalTo(add.mas_right).offset(10);
        }];
    }
    return _addHomeworkView;
}
- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"确认" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(postHomework) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
- (NSMutableArray *)homeworkData {
    if (!_homeworkData) {
        _homeworkData = [NSMutableArray array];
    }
    return _homeworkData;
}
- (void)selectGroupFinish:(NSNotification *)noti {
    self.selectGroupData = noti.userInfo;
}

- (void)uploadEnclosureFinish:(NSNotification *)noti {
    NSArray *record = [noti.userInfo objectForKeySafely:@"recordUrl"];
    NSArray *image = [noti.userInfo objectForKeySafely:@"imageUrl"];
    NSMutableArray *attachments = [[self.homeworkData safeObjectAtIndex:self.currentHandleIndex] objectForKeySafely:@"attachments"];
    
    for (NSString *url in record) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:url forKey:@"url"];
        [dic setSafeObject:@"4" forKey:@"type"];
        [attachments addObject:dic];
    }
    
    for (NSString *url in image) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:url forKey:@"url"];
        [dic setSafeObject:@"2" forKey:@"type"];
        [attachments addObject:dic];
    }
    
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectGroupFinish:) name:KSelectGroupListDidFinish object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadEnclosureFinish:) name:AddEnclosureDidFinish object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:KSelectGroupListDidFinish];
    [[NSNotificationCenter defaultCenter]removeObserver:AddEnclosureDidFinish];
}
@end
