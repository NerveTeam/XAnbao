//
//  MySelfInfoViewController.m
//  XAnBao
//
//  Created by wyy on 17/3/17.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "MySelfInfoViewController.h"
#import "UpdatePassViewControler.h"
#import "UIView+TopBar.h"
#import "MySelfTableCell.h"
@interface MySelfInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArr;
}
@property(nonatomic,retain)UITableView *MySelfimfoTableView;
@end

@implementation MySelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.MySelfimfoTableView.backgroundColor=[UIColor clearColor];
    titleArr=@[@"编辑头像",@"姓名",@"账号",@"性别",@"修改密码"];
    [self initNavItem];
}
//初始化导航按钮
- (void)initNavItem
{
    UIImageView *BlueView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    BlueView.image = [UIImage imageNamed:@"blue.png"];
    //    BlueView.backgroundColor=[UIColor redColor];
    BlueView.userInteractionEnabled=YES;
    [self.view addSubview:BlueView];
    
    UIButton *backBt = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 40, 25)];
    backBt.contentMode = UIViewContentModeScaleAspectFit;
    [backBt setTitle:@"返回" forState:UIControlStateNormal];
    backBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [BlueView addSubview:backBt];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToBeforeController)];
    [leftView addGestureRecognizer:tap];
    [BlueView addSubview:leftView];
    
    UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)*0.5, 30, 100, 25)];
    titlelab.text = @"个人信息";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    
}
-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
}
- (UITableView *)MySelfimfoTableView{
    if (!_MySelfimfoTableView) {
        _MySelfimfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight , self.view.width, self.view.height - TopBarHeight - StatusBarHeight - TabBarHeight) style:UITableViewStyleGrouped];
        _MySelfimfoTableView.delegate=self;
        _MySelfimfoTableView.dataSource=self;
        [self.view addSubview:_MySelfimfoTableView];
    }
    return _MySelfimfoTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MySelfTableCell *MySelfCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!MySelfCell) {
        
        MySelfCell=[[MySelfTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                    @"cell"];
        MySelfCell.namelbl.text=titleArr[indexPath.row];
    }
    MySelfCell.iconView.image=   [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", titleArr[indexPath.row]]];
    MySelfCell.ArrowiconView.backgroundColor=[UIColor redColor];
    
    return MySelfCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
       
            break;
        case 4:{
            UpdatePassViewControler *updatepassvc=[[UpdatePassViewControler alloc]init];
            [self.navigationController pushViewController:updatepassvc animated:1];

        }
                       break;
        default:
            break;
    }
    
    
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
