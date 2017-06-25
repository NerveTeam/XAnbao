//
//  XABNewGroupViewController.m
//  XAnBao
//
//  Created by Minlay on 17/5/25.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABNewGroupViewController.h"
#import "UIView+TopBar.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "XABMemberListSelectorView.h"
#import "XABSchoolRequest.h"
#import "XABClassRequest.h"

@interface XABNewGroupViewController ()
@property(nonatomic,strong)UIView *topBar;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIView *groupBgView;
@property(nonatomic, strong)UILabel *groupTip;
@property(nonatomic, strong)UITextField *groupName;
@property(nonatomic, strong)XABMemberListSelectorView *selectorView;
@property(nonatomic, strong)UIButton *postBtn;
@end

@implementation XABNewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
}

- (void)createGroup {
    NSMutableDictionary *pargam = [NSMutableDictionary dictionary];
    
    if (self.isScholl) {
        [pargam setSafeObject:UserInfo.id forKey:@"createId"];
        [pargam setSafeObject:self.groupName.text forKey:@"name"];
        [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
        [pargam setSafeObject:@"校安宝演示学校B" forKey:@"schoolName"];
        [pargam setSafeObject:[self.selectorView.selectList.copy componentsJoinedByString:@","]forKey:@"teacherIds"];
        
        [SchoolNewGroupRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
            [self showMessage:@"创建成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:NewGroupDidFinish object:nil];
            [self popViewControllerAnimated:YES];
            }else {
            [self showMessage:@"创建失败"];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];
    }else {
        [pargam setSafeObject:[self.selectorView.selectList.copy componentsJoinedByString:@","] forKey:@"students"];
        [pargam setSafeObject:self.groupName.text forKey:@"name"];
        [ClassNewGroupRequest requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                [self showMessage:@"创建成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:NewGroupDidFinish object:nil];
                [self popViewControllerAnimated:YES];
            }else {
                [self showMessage:@"创建失败"];
            }
        } failureBlock:^(BaseDataRequest *request) {
            
        }];

    }
    
}
- (void)setup {
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.groupBgView];
    [self.groupBgView addSubview:self.groupTip];
    [self.groupBgView addSubview:self.groupName];
    [self.view addSubview:self.selectorView];
    [self.view addSubview:self.postBtn];
    [self.groupBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.offset(30);
    }];
    
    [self.groupTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.groupBgView);
        make.left.equalTo(self.groupBgView).offset(10);
        make.width.offset(_groupTip.width);
    }];
    
    [self.groupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.groupBgView);
        make.left.equalTo(self.groupTip.mas_right).offset(15);
        make.right.equalTo(self.groupBgView);
    }];
    
    [self.selectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupBgView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
    
}

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        _topBar = [_topBar topBarWithTintColor:ThemeColor title:_isScholl ? @"新建教师组" : @"新建学生组" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
    }
    return _topBar;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:14 titleColor:[UIColor whiteColor]];
    }
    return _backBtn;
}

- (UIView *)groupBgView {
    if (!_groupBgView) {
        _groupBgView = [UIView new];
        _groupBgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _groupBgView;
}

- (UILabel *)groupTip {
    if (!_groupTip) {
        _groupTip = [UILabel labelWithText:@"组名:" fontSize:15 textColor:[UIColor blackColor]];
        [_groupTip sizeToFit];
    }
    return _groupTip;
}

- (UITextField *)groupName {
    if (!_groupName) {
        _groupName = [UITextField new];
        _groupName.placeholder = @"请输入组名";
        _groupName.font = [UIFont systemFontOfSize:15];
    }
    return _groupName;
}

- (XABMemberListSelectorView *)selectorView {
    if (!_selectorView) {
        _selectorView = [XABMemberListSelectorView memberListSelectorWithData:self.memberList isSchool:_isScholl selectedData:nil];
    }
    return _selectorView;
}
- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"确认" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
@end
