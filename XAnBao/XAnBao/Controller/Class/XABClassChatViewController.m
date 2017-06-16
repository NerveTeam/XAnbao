//
//  XABClassChatViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassChatViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABChatTool.h"
#import "XABParamModel.h"
@interface XABClassChatViewController ()
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@end

@implementation XABClassChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    //获取 校内
    XABParamModel *model = [XABParamModel paramWithUserId:[XABUserLogin getInstance].userInfo.id];
    [[XABChatTool getInstance] getChatSchoolGroupWithRequestModel:model resultBlock:^(NSArray *sourceArray, NSError *error) {
        
        NSLog(@"输出 讨论组的group == %@",sourceArray);
    }];
    
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"班级讨论" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
