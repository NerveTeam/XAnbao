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
#import "FrameAutoScaleLFL.h"

#import "AboutOurViewController.h"
#import "SystemMessageViewController.h"
#import "MyWordViewController.h"


@interface XABMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *imgArr;
}
@property(nonatomic,retain)UITableView *MyInfoTableView;

@end

@implementation XABMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       titleArr=@[@"我的消息",@"我的留言",@"个人信息",@"系统消息",@"关于我们",@"设置"];
     imgArr=@[@"我的消息.jpg",@"我的留言.jpg",@"个人信息.png",@"系统通知.png",@"关于我们.jpg",@"设置.png"];
    [self initNavItem];
    self.MyInfoTableView.backgroundColor=[UIColor clearColor];

}
//初始化导航按钮

- (void)initNavItem
{
    UIImageView *BlueView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    BlueView.image = [UIImage imageNamed:@"blue.png"];
//    BlueView.backgroundColor=[UIColor redColor];
    BlueView.userInteractionEnabled=YES;
     [self.view addSubview:BlueView];
    
    UIButton *backBt = [[UIButton alloc] initWithFrame:CGRectMake(15, 31, 12, 20)];

    backBt.contentMode = UIViewContentModeScaleAspectFit;
    
    [backBt setImage:[UIImage imageNamed:@"leftjiantou.png"] forState:UIControlStateNormal];
    backBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [BlueView addSubview:backBt];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToBeforeController)];
    [leftView addGestureRecognizer:tap];
    [BlueView addSubview:leftView];
    
    UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)*0.5, 30, 100, 25)];
    titlelab.text = @"我的信息";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
   
    
}
-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
}
- (UITableView *)MyInfoTableView{
    if (!_MyInfoTableView) {
        _MyInfoTableView = [[UITableView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:-90 width:320 height:580] style:UITableViewStyleGrouped];
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
   MyinfoCell.iconView.image=   [UIImage imageNamed:[NSString stringWithFormat:@"%@", imgArr[indexPath.row]]];
   MyinfoCell.ArrowiconView.image=[UIImage imageNamed:@"jiantou.png"];
   MyinfoCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return MyinfoCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            MyWordViewController *mywordvc=[[MyWordViewController alloc]init];
            [self.navigationController pushViewController:mywordvc animated:1];
        }
            break;
            //个人消息
        case 2:
        {
            MySelfInfoViewController *myselfinfovc=[[MySelfInfoViewController alloc]init];
            [self.navigationController pushViewController:myselfinfovc animated:1];
        }
            break;
            //系统消息
        case 3:
        { SystemMessageViewController *settingvc=[[SystemMessageViewController alloc]init];
            [self.navigationController pushViewController:settingvc animated:1];
        }
            break;
            
            //关于我们
        case 4:
        {
            AboutOurViewController *aboutvc=[[AboutOurViewController alloc]init];
            [self.navigationController pushViewController:aboutvc animated:1];
        }
            break;
            //系统设置
        case 5:
        { SettingViewController *settingvc=[[SettingViewController alloc]init];
            [self.navigationController pushViewController:settingvc animated:1];
        }
            break;
               default:
            break;
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *view=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:320 height:180]];
    view.image=[UIImage imageNamed:@"蓝背景.png"];
//    view.backgroundColor=[UIColor redColor];
    
    
    UIImageView *headImgView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:130 Y:150 width:60 height:60]];
    
    headImgView.layer.cornerRadius=headImgView.frame.size.width/2;

    headImgView.backgroundColor=[UIColor orangeColor];
    
    [view addSubview:headImgView];
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}




-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
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
