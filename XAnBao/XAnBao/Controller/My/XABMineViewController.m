//
//  XABMineViewController.m
//  XAnBao
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABMineViewController.h"
#import "UIView+TopBar.h"
#import "SettingViewController.h"
#import "MySelfInfoViewController.h"
#import "MyInfomationCell.h"
@interface XABMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
}
@property(nonatomic,retain)UITableView *MyInfoTableView;

@end

@implementation XABMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MyInfoTableView.backgroundColor=[UIColor clearColor];
    titleArr=@[@"我的消息",@"个人信息",@"系统通知",@"设置"];
    [self initNavItem];
}
//初始化导航按钮
-(void)initNavItem
{
    UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
    [self.view addSubview:topBarView];
    topBarView = [topBarView topBarWithTintColor:ThemeColor title:@"我的信息" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
    
}


- (UITableView *)MyInfoTableView{
    if (!_MyInfoTableView) {
        _MyInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight , self.view.width, self.view.height - TopBarHeight - StatusBarHeight - TabBarHeight) style:UITableViewStyleGrouped];
        _MyInfoTableView.delegate=self;
        _MyInfoTableView.dataSource=self;
        [self.view addSubview:_MyInfoTableView];
    }
    return _MyInfoTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyInfomationCell *MyinfoCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!MyinfoCell) {
        
        MyinfoCell=[[MyInfomationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                     @"cell"];
        MyinfoCell.Settingtitlelbl.text=titleArr[indexPath.row];
    }
   MyinfoCell.iconView.image=   [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", titleArr[indexPath.row]]];
   MyinfoCell.ArrowiconView.backgroundColor=[UIColor redColor];
    
    return MyinfoCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            MySelfInfoViewController *myselfinfovc=[[MySelfInfoViewController alloc]init];
            [self.navigationController pushViewController:myselfinfovc animated:1];
        }
            break;
        case 2:
            
            break;
        case 3:
        { SettingViewController *settingvc=[[SettingViewController alloc]init];
            [self.navigationController pushViewController:settingvc animated:1];
        }
            break;
        default:
            break;
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=NO;
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
