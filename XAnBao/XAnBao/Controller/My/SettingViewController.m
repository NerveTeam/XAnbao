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
#import "AFNetworking.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *SettinArr;
}
@property(nonatomic,retain)UITableView *SettingTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.SettingTableView.backgroundColor=[UIColor clearColor];
    SettinArr=@[@"是否静音",@"版本更新",@"清理缓存"];
    
    NSLog(@">>>>>>>>>>>>%@",self.alert);
   
    NSLog(@">>>>>>>>>>>>%@",self.jianzhangid);

    [self    VersionRequest];
}



-(void)creataler{
    
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:self.alert message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.delegate=self;
    [alertview show];
}


-(void)VersionRequest
{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSDictionary *headerFieldValueDictionary =Token;
    NSLog(@">>>>>>>>>>>>>>>>>>%@",Token);
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    manger.requestSerializer = requestSerializer;
    NSDictionary *dict = @{
                           @"id":self.jianzhangid,
                           @"pass":@"true",
                           };
    [manger POST:@"http://118.190.97.150/interface/api1/class-grade/pass-attention" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@">>>>>=========%@",dic[@"message"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//初始化导航按钮
-(void)initNavItem
{
    UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
    [self.view addSubview:topBarView];
    topBarView = [topBarView topBarWithTintColor:ThemeColor title:@"系统设置" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
    
}

- (UITableView *)SettingTableView{
    if (!_SettingTableView) {
        _SettingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight , self.view.width, self.view.height - TopBarHeight - StatusBarHeight - TabBarHeight) style:UITableViewStyleGrouped];
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
    else if (buttonIndex==1  )

//    else if (buttonIndex==1 && alertView.tag==2 )
    {
        
        
        
          [self VersionRequest];
    }
        
        //清楚缓存
    /*    UIAlertView* alertViewc = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"清理成功，共清理(%.2fM)垃圾",[NSString getFileSizeWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches"]]]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
    
    [self.SettingTableView reloadData];*/
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
