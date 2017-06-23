//
//  SettingViewController.m
//  XAnBao
//
//  Created by wyy on 17/3/16.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "SettingViewController.h"
#import "UIView+TopBar.h"
#import "SettingtavleViewCell.h"
#import "NSString+Addtion.h"
#import "FrameAutoScaleLFL.h"
#import "AppDelegate.h"
#import "XABLoginViewController.h"
#import "JPUSHService.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *SettinArr;
}
@property(nonatomic,retain)UITableView *SettingTableView;
@property(nonatomic,retain)UIButton *sureBtn;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    SettinArr=@[@"是否静音",@"版本更新",@"清理缓存"];
    [self initNavItem];
    self.SettingTableView.backgroundColor=[UIColor clearColor];
      self.sureBtn.backgroundColor=[UIColor colorWithRed:16/255.0 green:159/255.0 blue:1 alpha:1];
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
    
    [backBt setImage:[UIImage imageNamed:@"leftjiantou.png"] forState:UIControlStateNormal];    backBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [BlueView addSubview:backBt];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToBeforeController)];
    [leftView addGestureRecognizer:tap];
    [BlueView addSubview:leftView];
    
    UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)*0.5, 30, 100, 25)];
    titlelab.text = @"系统设置";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    
}
-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
}

- (UITableView *)SettingTableView{
    if (!_SettingTableView) {
        _SettingTableView = [[UITableView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:65 width:320 height:503] style:UITableViewStylePlain];
        _SettingTableView.scrollEnabled=NO;
        _SettingTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        if (!IS_IPHONE_5) {
            _SettingTableView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:50 width:320 height:503];
        }
        _SettingTableView.delegate=self;
        _SettingTableView.dataSource=self;
        [self.view addSubview:_SettingTableView];
    }
    return _SettingTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SettinArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingtavleViewCell *SettionCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!SettionCell) {
        
        SettionCell=[[SettingtavleViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
              @"cell"];
        SettionCell.Settingtitlelbl.text=SettinArr[indexPath.row];
    }
    
    if (indexPath.row==1) {
        SettionCell.CleanLabel.text=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    
    
    
    if (indexPath.row == 2) {
        SettionCell.CleanLabel.hidden = NO;
        SettionCell.CleanLabel.text = [NSString stringWithFormat:@"清除缓存(%.2fM)",[NSString getFileSizeWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches"]]]];
    }

    return SettionCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        UIAlertView * alview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否清楚缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alview.tag=indexPath.row;
        [alview show];
    }
}



//清楚缓存
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        return;
    }
   else if (buttonIndex==1 && alertView.tag==2 )
    {
        //清楚缓存
       UIAlertView* alertViewc = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"清理成功，共清理(%.2fM)垃圾",[NSString getFileSizeWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches"]]]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertViewc show];
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        
        return;
    }
    
    [self.SettingTableView reloadData];
}

- (void)viewWillappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


-(UIButton *)sureBtn{
    
    if (!_sureBtn) {
        _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:20 Y:230 width:280 height:30];
        [_sureBtn setTitle:@"退出" forState:UIControlStateNormal];
        [self.view addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sueClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(void)sueClick{
    
    XABLoginViewController *vc = [[XABLoginViewController alloc] init];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:vc];
    AppDelegate *app =(AppDelegate *) [[UIApplication sharedApplication] delegate ];
    app.window.rootViewController = navLogin;
    
    //    //退出登录
    [JPUSHService setTags:nil alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
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
