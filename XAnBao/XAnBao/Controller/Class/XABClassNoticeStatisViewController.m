//
//  XABClassNoticeStatisViewController.m
//  XAnBao
//
//  Created by Minlay on 17/6/20.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassNoticeStatisViewController.h"
#import "XABClassRequest.h"
#import "UIButton+Extention.h"
#import "UIView+TopBar.h"
#import "UILabel+Extention.h"
#import "NSArray+Safe.h"
#import "XABMemberListSelectorView.h"

@interface XABClassNoticeStatisViewController ()<UITableViewDelegate,UITableViewDataSource,XABMemberListSelectorViewDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic,strong)NSArray *classList;
@property(nonatomic, strong)NSMutableArray *statisResult;
@property(nonatomic, strong)UITableView *existTableview;
@property(nonatomic, strong)XABMemberListSelectorView *selectorView;
@property(nonatomic, strong)UIView *bgTipView;
@end

@implementation XABClassNoticeStatisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestClassList];
}

- (void)requestClassList {
    WeakSelf;
    NSMutableDictionary *pa = [NSMutableDictionary dictionary];
    [pa setSafeObject:self.noticeId forKey:@"messageId"];
    [ClassStatisReceivedRequest requestDataWithParameters:pa headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            weakSelf.classList = data;
            [weakSelf requestDetailInfo:[data.firstObject objectForKeySafely:@"id"]];
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)requestDetailInfo:(NSString *)classId {
    WeakSelf;
    NSMutableDictionary *pa = [NSMutableDictionary dictionary];
    [pa setSafeObject:self.noticeId forKey:@"id"];
    [pa setSafeObject:classId forKey:@"classId"];
    [ClassCatStatisRequest requestDataWithParameters:pa headers:Token successBlock:^(BaseDataRequest *request) {
        NSArray *data = [request.json objectForKeySafely:@"data"];
        self.statisResult = data.mutableCopy;
        [weakSelf setup];
        [weakSelf parseClassData:data];
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)setup {
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.existTableview];
}

- (void)removeObjWithSaveElement:(NSDictionary *)item {
    NSMutableArray *removeArray = [NSMutableArray array];
    for (NSDictionary *element in self.statisResult) {
        if ([[element objectForKeySafely:@"studentId"] isEqualToString:[item objectForKeySafely:@"studentId"]]) {
            if ([[element objectForKeySafely:@"patriarchId"] isEqualToString:[item objectForKeySafely:@"patriarchId"]]) {
                continue;
            }else {
                [removeArray addObject:element];
            }
        }
    }
    
    for (NSDictionary *element in removeArray) {
        [self.statisResult removeObject:element];
    }
}
- (void)parseClassData:(NSArray *)data {
    
    NSMutableArray *saveArray = [NSMutableArray array];
    for (NSMutableDictionary *item1 in data) {
        NSString *stu1 = [item1 objectForKeySafely:@"studentId"];
        BOOL confim1 = [[item1 objectForKeySafely:@"replied"] boolValue];
        [saveArray addObject:item1];
        
        for (NSInteger i = 0; i<saveArray.count; i++) {
            NSMutableDictionary *item2 = [saveArray safeObjectAtIndex:i];
            if (item1 == item2) {
                continue;
            }
            
            NSString *stu2 = [item2 objectForKeySafely:@"studentId"];
            if ([stu1 isEqualToString:stu2]) {
                BOOL confim2 = [[item2 objectForKeySafely:@"replied"] boolValue];
                [saveArray removeObject:item1];
                if (confim2 && confim1) {
                    NSString *patriarchName = [item2 objectForKeySafely:@"patriarchName"];
                    [item2 setSafeObject:[patriarchName stringByAppendingString:[NSString stringWithFormat:@",%@",[item1 objectForKeySafely:@"patriarchName"]]]  forKey:@"patriarchName"];
                }else if (confim2 && !confim1) {
                    continue;
                }else if (!confim2 && confim1) {
                    [saveArray replaceObjectAtIndex:i withObject:item1];
                }else if (!confim2 && !confim1) {
                    continue;
                }
            }
        }
        
    }
    
    self.statisResult = saveArray;
    
    NSMutableArray *statis = [NSMutableArray array];
    NSMutableDictionary *nothing = [NSMutableDictionary dictionary];
    NSMutableDictionary *yes = [NSMutableDictionary dictionary];
    
    [nothing setSafeObject:@"未确认" forKey:@"schoolName"];
    [yes setSafeObject:@"已确认" forKey:@"schoolName"];
    
    NSMutableArray *noT = [NSMutableArray array];
    NSMutableArray *yesT = [NSMutableArray array];
    for (NSDictionary *item in saveArray) {
        BOOL confim = [[item objectForKeySafely:@"replied"] boolValue];
        NSString *name = [item objectForKeySafely:@"studentName"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:name forKey:@"name"];
        [dic setSafeObject:[item objectForKeySafely:@"studentId"] forKey:@"id"];
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
    self.selectorView.elementSelEnable = YES;
    [self.selectorView hideAllBtn];
    [self.selectorView removeFromSuperview];
    [self.view addSubview:self.selectorView];
    [self.selectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.existTableview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XABClassNoticeStatisViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XABClassNoticeStatisViewController"];
    }
    
    UILabel *name = [UILabel labelWithText:[[self.classList safeObjectAtIndex:indexPath.row] objectForKeySafely:@"name"] fontSize:14 textColor:[UIColor blackColor]];
    [cell addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(10);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *classId = [[self.classList safeObjectAtIndex:indexPath.row] objectForKeySafely:@"id"];
    [self requestDetailInfo:classId];
}


- (void)clickItem:(NSString *)pid {
    NSDictionary *result = nil;
    for (NSDictionary *item in self.statisResult) {
        if ([[item objectForKeySafely:@"studentId"] isEqualToString:pid]) {
            result = item;
            break;
        }
    }
    BOOL confim = [[result objectForKeySafely:@"replied"] boolValue];
    if (!confim) {
        return;
    }
    [self.bgTipView removeFromSuperview];
    
    UIView *bgView = [UIView new];
    self.bgTipView = bgView;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.offset(200);
        make.height.offset(200);
    }];
    
    UILabel *stu = [UILabel labelWithText:[NSString stringWithFormat:@"学生：%@",[result objectForKeySafely:@"studentName"]] fontSize:14 textColor:[UIColor blackColor]];
    [bgView addSubview:stu];
    [stu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bgView).offset(10);
    }];
    
    UILabel *fa = [UILabel labelWithText:[NSString stringWithFormat:@"确认者：%@",[result objectForKeySafely:@"patriarchName"]] fontSize:14 textColor:[UIColor blackColor]];
    fa.numberOfLines = 0;
    [bgView addSubview:fa];
    [fa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(stu.mas_bottom).offset(20);
    }];
    
    UIButton *sure = [UIButton buttonWithTitle:@"确定" fontSize:14 titleColor:ThemeColor];
    [bgView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(fa.mas_bottom).offset(10);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [sure addTarget:self action:@selector(removeTip) forControlEvents:UIControlEventTouchUpInside];

}

- (void)removeTip {
    [self.bgTipView removeFromSuperview];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"通知查阅统计" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
- (UITableView *)existTableview {
    if (!_existTableview) {
        _existTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topBarView.height + 10, self.view.width, 100) style:UITableViewStylePlain];
        _existTableview.delegate = self;
        _existTableview.dataSource = self;
    }
    return _existTableview;
}
@end
