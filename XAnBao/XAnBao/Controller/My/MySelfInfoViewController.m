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
#import "FrameAutoScaleLFL.h"
@interface MySelfInfoViewController ()
{
    NSArray *titleArr;
}
@property(nonatomic,retain)UITableView *MySelfimfoTableView;
@end

@implementation MySelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    titleArr=@[@"编辑头像",@"姓名",@"账号",@"性别",@"修改密码"];
    [self initNavItem];
    [self createView];
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

-(void)createView{
    
    UIView *headview=[[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:65 width:320 height:80]];
    headview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headview];
    
    UILabel *headlab=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:15 width:40 height:50]];
    headlab.text=@"头像";
    [headview addSubview:headlab];
    
    UIImageView *headImgView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:220 Y:10 width:60 height:60]];
    
    headImgView.layer.cornerRadius=35;
    
    headImgView.backgroundColor=[UIColor orangeColor];
    
    [headview addSubview:headImgView];

    UIImageView *jiantouImgView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:290  Y:30 width:18 height:20]];
    
    jiantouImgView.image=[UIImage imageNamed:@"jiantou.png"];
    
    [headview addSubview:jiantouImgView];
}


-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
    UpdatePassViewControler *updatepassvc=[[UpdatePassViewControler alloc]init];
    [self.navigationController pushViewController:updatepassvc animated:1];
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
