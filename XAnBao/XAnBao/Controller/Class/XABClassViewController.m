//
//  XABClassViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassViewController.h"
#import "MLMeunView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIButton+Extention.h"
#import "XABSchoolMenu.h"
#import "XABSchoolMessage.h"
#import "XABSearchViewController.h"
#import "SDCycleScrollView.h"
#import "XABClassContentView.h"
#import "XABClassRequest.h"
#import "NSArray+Safe.h"
#import <objc/runtime.h>
#import "XABClassSearchViewController.h"
#import "XABClassChatViewController.h"
@interface XABClassViewController ()
<XABSchoolMessageDelegate, XABSchoolMenuDelegate,XABClassContentViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *currentSelectSchool;
@property(nonatomic, strong)UIButton *searchBtn;
@property(nonatomic, strong)UIView *schoolMenuBgView;
@property(nonatomic, strong)XABSchoolMenu *schoolMenu;
@property(nonatomic, strong)XABSchoolMessage *schoolMessage;
@property(nonatomic, strong)XABClassContentView *contentView;
@property(nonatomic, strong)NSArray *followData;
@property(nonatomic, assign)NSInteger currentSelectIndex;
@end

@implementation XABClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFollowList];
}

- (void)loadFollowList {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:UserInfo.mobile forKey:@"mobilePhone"];
    
    [ClassFollowList requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            NSMutableArray *follow = [[NSMutableArray alloc]initWithCapacity:data.count];
            for (NSDictionary *item in data) {
                NSString *classId = [item objectForKeySafely:@"classId"];
                NSString *className = [item objectForKeySafely:@"className"];
                NSInteger type = [[item objectForKeySafely:@"type"] longValue];
                NSString *studentId = [item objectForKeySafely:@"studentId"] ;
                NSString *studentName = [item objectForKeySafely:@"studentName"];
                NSMutableDictionary *list = [NSMutableDictionary dictionary];
                [list setSafeObject:[item objectForKeySafely:@"id"] forKey:@"roleId"];
                [list setSafeObject:classId forKey:@"classId"];
                [list setSafeObject:className forKey:@"className"];
                [list setSafeObject:studentId forKey:@"studentId"];
                [list setSafeObject:studentName forKey:@"studentName"];
                [list setSafeObject:@(type) forKey:@"type"];
                
                [follow addObject:list];
            }
            weakSelf.followData = follow.copy;
            [weakSelf initTopBar];
            [weakSelf initContent];
            [weakSelf requestFoucs];
            
            NSInteger type = [[[follow safeObjectAtIndex:0]objectForKeySafely:@"type"] longValue];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ClassChangeRole" object:nil userInfo:@{@"isTeacher":type == 2? @(YES) : @(NO)}];
        }else {
        [weakSelf initTopBar];
        }
    } failureBlock:^(BaseDataRequest *request) {
        [weakSelf initTopBar];
    }];
}

- (void)requestFoucs {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:[[self.followData safeObjectAtIndex:self.currentSelectIndex] objectForKeySafely:@"classId"] forKey:@"classId"];
    [ClassFoucsMapRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            NSMutableArray *follow = [[NSMutableArray alloc]initWithCapacity:data.count];
            for (NSDictionary *item in data) {
                [follow safeAddObject:[item objectForKeySafely:@"url"]];
            }
            weakSelf.cycleView.imageURLStringsGroup = follow.copy;
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

// init菜单
- (void)initTopBar {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBarView];
    [self.currentSelectSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView).offset(-10);
        make.leading.equalTo(self.topBarView).offset(15);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentSelectSchool);
        make.trailing.equalTo(self.topBarView).offset(-10);
    }];
}

- (void)initContent {
    [self.view addSubview:self.cycleView];
    [self.view addSubview:self.contentView];
}

- (void)clickSchoolMenu {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.schoolMenuBgView];
    NSMutableArray *meunList = [NSMutableArray array];
    for (NSDictionary *item in self.followData) {
        NSInteger type = [[item objectForKeySafely:@"type"] longValue];
        NSString *result = @"";
        if (type == 1) {
            result = @"我是家长:";
        }else if(type == 2){
            result = @"我是老师:";
        }
        result = [result stringByAppendingString:[item objectForKeySafely:@"className"]];
        NSString *studentName = [item objectForKeySafely:@"studentName"];
        if (studentName) {
           result = [result stringByAppendingString:studentName];
        }
        [meunList addObject:result];
    }
    self.schoolMenu = [XABSchoolMenu schoolMenuList:meunList.copy meunType:MeunTypeClass];
    self.schoolMenu.delegate = self;
    [window addSubview:self.schoolMenu];
}
- (void)tapClick {
    __weak typeof(self)weakSelf = self;
    if (self.schoolMessage) {
        [self cancelMessage];
    }else {
        [self.schoolMenu hide:^{
            [weakSelf.schoolMenu removeFromSuperview];
            [weakSelf.schoolMenuBgView removeFromSuperview];
            weakSelf.schoolMenu = nil;
        }];
    }
}

- (void)searchClick {
    [self.navigationController pushViewController:[XABClassSearchViewController new] animated:YES];
}


- (void)messageDidFinish:(NSString *)object content:(NSString *)content {
    
}

- (void)cancelMessage {
    [self.schoolMessage removeFromSuperview];
    [self.schoolMenuBgView removeFromSuperview];
    self.schoolMessage = nil;
}

- (void)schoolMenuSelected:(NSInteger)index str:(NSString *)str {
   NSInteger type = [[[self.followData safeObjectAtIndex:index]objectForKeySafely:@"type"] longValue];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ClassChangeRole" object:nil userInfo:@{@"isTeacher":type == 2? @(YES) : @(NO)}];
    self.currentSelectIndex = index;
    [self.currentSelectSchool setTitle:str forState:UIControlStateNormal];
    [_currentSelectSchool sizeToFit];
    [_currentSelectSchool layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [self.schoolMenu removeFromSuperview];
    [self.schoolMenuBgView removeFromSuperview];
    [self requestFoucs];
}


- (void)schoolMenuCancelFoucs:(NSInteger)index {
    NSDictionary *dic = [self.followData safeObjectAtIndex:index];
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
        [pargam setSafeObject:[dic objectForKeySafely:@"studentId"] forKey:@"studentId"];
        [pargam setSafeObject:UserInfo.mobile forKey:@"mobilePhone"];
    [ClassCancelFollowStudent requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}


- (void)clickItemWithClass:(NSString *)className {
    Class class = NSClassFromString(className);
    UIViewController *viewcontroller = [class new];
    
    NSDictionary *currentInfo = [self.followData safeObjectAtIndex:self.currentSelectIndex];
    [currentInfo enumerateKeysAndObjectsUsingBlock:^(NSString   *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       objc_property_t property = class_getProperty(NSClassFromString(className), key.UTF8String);
        if (property) {
            [viewcontroller setValue:obj forKey:key];
        }
    }];
    if ([viewcontroller isKindOfClass:[XABClassChatViewController class]]) {
        
        NSString *classId = [currentInfo objectForKeySafely:@"classId"];
        NSString *className = [currentInfo objectForKeySafely:@"className"];

        if (classId) {
            
            if (!className) className = @"班级讨论组";
            XABClassChatViewController *viewcontroller = [[XABClassChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:classId];
            viewcontroller.title =className;
            RCGroup *group = [[RCGroup alloc]initWithGroupId:classId groupName:className portraitUri:nil];
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:classId];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }else{
            [self showMessage:@"未获取到班级群组!"];
        }
        
        
    }else{
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}

#pragma mark - lazy
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView.backgroundColor = ThemeColor;
    }
    return _topBarView;
}
- (UIButton *)currentSelectSchool {
    if (!_currentSelectSchool) {
        _currentSelectSchool = [[UIButton alloc]init];
        [_currentSelectSchool.titleLabel setFont:[UIFont systemFontOfSize:16]];
        NSString *result = @"";
        if (self.followData) {
            NSInteger type = [[self.followData.firstObject objectForKeySafely:@"type"] longValue];
            
            if (type == 1) {
                result = @"我是家长:";
            }else if(type == 2){
                result = @"我是老师:";
            }
            result = [result stringByAppendingString:[self.followData.firstObject objectForKeySafely:@"className"]];
            NSString *studentName = [self.followData.firstObject objectForKeySafely:@"studentName"];
            if (studentName) {
                result = [result stringByAppendingString:studentName];
            }
        }else {
            result = @"尚未关注";
        }
       
        [_currentSelectSchool setTitle:result forState:UIControlStateNormal];
        [_currentSelectSchool setImage:[UIImage imageNamed:@"faculty_arrow"] forState:UIControlStateNormal];
        [_currentSelectSchool sizeToFit];
        [_currentSelectSchool layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [self.topBarView addSubview:_currentSelectSchool];
        [_currentSelectSchool addTarget:self action:@selector(clickSchoolMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentSelectSchool;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithImageNormal:@"nav_btn_search" imageSelected:@"nav_btn_search"];
        [_searchBtn sizeToFit];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:_searchBtn];
    }
    return _searchBtn;
}
- (UIView *)schoolMenuBgView {
    if (!_schoolMenuBgView) {
        _schoolMenuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _schoolMenuBgView.backgroundColor = [UIColor blackColor];
        _schoolMenuBgView.alpha = 0.5;
        [_schoolMenuBgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    }
    return _schoolMenuBgView;
}
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.topBarView.height, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
    }
    return _cycleView;
}
- (XABClassContentView *)contentView {
    if (!_contentView) {
        CGFloat Y = CGRectGetMaxY(self.cycleView.frame);
        _contentView = [[XABClassContentView alloc]initWithFrame:CGRectMake(0, Y, self.view.width, self.view.height - Y)];
        _contentView.delegate = self;
    }
    return _contentView;
}
@end
