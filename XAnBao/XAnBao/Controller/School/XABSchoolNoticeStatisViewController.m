//
//  XABSchoolNoticeStatisViewController.m
//  XAnBao
//
//  Created by Minlay on 17/6/20.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolNoticeStatisViewController.h"
#import "XABSchoolRequest.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABMemberListSelectorView.h"

@interface XABSchoolNoticeStatisViewController ()
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)XABMemberListSelectorView *selectorView;
@end

@implementation XABSchoolNoticeStatisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topBarView];
    [self requestStatis];
}

- (void)requestStatis {
    NSMutableDictionary *pa = [NSMutableDictionary dictionary];
    [pa setSafeObject:self.noticeId forKey:@"noticeId"];
    [SchoolNoticeStatisRequest requestDataWithParameters:pa headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            [self parseSchoolData:data];
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)parseSchoolData:(NSArray *)data {
    NSMutableArray *statis = [NSMutableArray array];
    NSMutableDictionary *nothing = [NSMutableDictionary dictionary];
    NSMutableDictionary *yes = [NSMutableDictionary dictionary];
    
    [nothing setSafeObject:@"未确认" forKey:@"schoolName"];
    [yes setSafeObject:@"已确认" forKey:@"schoolName"];
    
    NSMutableArray *noT = [NSMutableArray array];
    NSMutableArray *yesT = [NSMutableArray array];
    for (NSDictionary *item in data) {
        BOOL confim = [[item objectForKeySafely:@"confim"] boolValue];
        NSString *name = [item objectForKeySafely:@"teacherName"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:name forKey:@"name"];
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
    [self.selectorView hideAllBtn];
    [self.view addSubview:self.selectorView];
    [self.selectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"学校内网公告确认统计" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
