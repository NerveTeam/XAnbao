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
#import "UIImageView+WebCache.h"
#import "XABSchoolGroupChatViewController.h"
@interface XABClassChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *sourceArray;

@end

@implementation XABClassChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self setup];
    
//    //获取 班级讨论组
//    XABParamModel *model = [XABParamModel paramClassGroupWithClassId:self.classId];
//    [[XABChatTool getInstance] getChatClassGroupWithRequestModel:model resultBlock:^(NSArray *sourceArray, NSError *error) {
//        if (sourceArray.count > 0) {
//            
//            self.sourceArray = sourceArray;
//            [self.tableView reloadData];
//        }else{
//            [self showMessage:@"未获取到校群信息"];
//        }
//
//        NSLog(@"输出 班级讨论组的group == %@",sourceArray);
//    }];
    
}

#pragma mark - 下面2个方法 为了 只是 当前界面 禁用 手势返回
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
}

#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"XABSchoolGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (indexPath.row < self.sourceArray.count) {
        
        XABChatClassGroupModel *model = self.sourceArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.name] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
        
        cell.textLabel.text = model.name;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.sourceArray.count) {
        
        XABChatClassGroupModel *model = self.sourceArray[indexPath.row];
        
        XABSchoolGroupChatViewController *vc = [[XABSchoolGroupChatViewController alloc]initWithConversationType:ConversationType_GROUP targetId:model.groupId];
        
        vc.isJumpDetailVC = @"0";
        vc.groupName = model.name;
        vc.senderGroupId = model.groupId;
        RCGroup *group = [[RCGroup alloc]initWithGroupId:model.groupId groupName:model.name portraitUri:nil];
        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:model.groupId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

-(NSArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [[NSArray alloc]init];
    }
    return _sourceArray;
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
