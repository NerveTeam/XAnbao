//
//  XABClassMembersDetailnfoVC.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassMembersDetailnfoVC.h"
#import "XABChatRequest.h"
#import "XABChatTool.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "UIImageView+WebCache.h"
#import "XABConversationViewController.h"
@interface XABClassMembersDetailnfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *sourceArray;
@property (nonatomic,strong) UIView *topBarView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIView *footView;

@property (nonatomic,strong) XABChatClassGradeTeachersDetailModel *teacherDetailModel;
@property (nonatomic,strong) XABChatClassGradeStudentsParentsDetailModel *parentDetailModel;

@end

@implementation XABClassMembersDetailnfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    [self topBarView];
    [self loadUserInfo];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)loadUserInfo{
    
    if ([self.isTeacherOrParent isEqualToString:@"1"]) {
        
        XABParamModel *param = [XABParamModel paramChatSchoolGroupMembersWithId:self.id pass:nil];
        [[XABChatTool getInstance] getClassGradeTeachersDetailWithRequestModel:param resultBlock:^(XABChatClassGradeTeachersDetailModel *model, NSError *error) {
            
            if (!error) {
                
                if (model) {
                    
                    self.teacherDetailModel = model;
                    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.teacherDetailModel.url] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
                    [self.tableView reloadData];

                }
            }
        }];
    }else{
        
        XABParamModel *param = [XABParamModel paramChatSchoolGroupMembersWithId:self.id pass:nil];
        [[XABChatTool getInstance] getClassGradeParentsDetailWithRequestModel:param resultBlock:^(XABChatClassGradeStudentsParentsDetailModel *model, NSError *error) {
            
            if (!error) {
                
                if (model) {
                    
                    self.parentDetailModel = model;
                    [self.tableView reloadData];
                }
            }
        }];
    }
    
}
-(void)callPhone:(UITapGestureRecognizer *)tap{
    
    UILabel *label =(UILabel *)tap.view;
    if (label.text.length != 11) return;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",label.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

//跳转到聊天
-(void)startChat{
    
    if ([self.isTeacherOrParent isEqualToString:@"1"]) {
        
        XABConversationViewController *vc = [[XABConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.teacherDetailModel.id];
        vc.title = self.teacherDetailModel.name;
        [self.navigationController pushViewController:vc animated:true];
        
    }else{
        
        XABConversationViewController *vc = [[XABConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.parentDetailModel.id];
        vc.title = self.parentDetailModel.name;
        [self.navigationController pushViewController:vc animated:true];
        
    }
   
}
#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"姓名:";
            if ([self.isTeacherOrParent isEqualToString:@"1"]) {
                
                cell.detailTextLabel.text = self.teacherDetailModel.name;

            }else{
                cell.detailTextLabel.text = self.parentDetailModel.name;

            }

        }
            break;
        case 1:
        {
            if ([self.isTeacherOrParent isEqualToString:@"1"]) {
                
                cell.textLabel.text = @"科目:";

                cell.detailTextLabel.text = self.teacherDetailModel.subject;
                
            }else{
                cell.textLabel.text = @"关联学生:";

                cell.detailTextLabel.text = self.parentDetailModel.studentName;
                
            }

        }
            break;
        case 2:
        {
            cell.textLabel.text = @"电话:";
//            cell.detailTextLabel.text = self.teacherDetailModel.mobilePhone;

            if ([self.isTeacherOrParent isEqualToString:@"1"]) {
                
                
                cell.detailTextLabel.text = self.teacherDetailModel.mobilePhone;
                
            }else{
                
                if (self.type == 1) {
                    //家长身份的时候 看到其他家长手机号时 显示 星号的
                    NSString *string=[self.parentDetailModel.mobilePhone stringByReplacingOccurrencesOfString:[self.parentDetailModel.mobilePhone substringWithRange:NSMakeRange(3,4)]withString:@"****"];
                    cell.detailTextLabel.text = string;

                }else{
                    
                    cell.detailTextLabel.text = self.parentDetailModel.mobilePhone;
                }
                
            }
            cell.detailTextLabel.userInteractionEnabled = YES;
            cell.detailTextLabel.textColor = [UIColor blueColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            [cell.detailTextLabel addGestureRecognizer:tap];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

-(UIView *)headView{
    
    if (!_headView) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        _headImageView = [[UIImageView alloc] init];
        _headImageView.center = _headView.center;
        _headImageView.bounds = CGRectMake(0, 0, 80, 80);
        _headImageView.layer.cornerRadius = 40;
        _headImageView.clipsToBounds = YES;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.teacherDetailModel.url] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
        
        [_headView addSubview:_headImageView];
    }
    return _headView;
}
-(UIView *)footView{
    
    if (!_footView) {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(23, 20, SCREEN_WIDTH-23*2, 40);
        btn.layer.cornerRadius = 4.0f;
        btn.clipsToBounds = YES;
        btn.backgroundColor = ThemeColor;
        [btn setTitle:@"开始聊天" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(startChat) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
    }
    return _footView;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"个人详情" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
        _topBarView.backgroundColor = ThemeColor;
        
        [self.view addSubview:_topBarView];
    }
    return _topBarView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
