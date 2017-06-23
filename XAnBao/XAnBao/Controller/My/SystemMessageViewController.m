//
//  SystemMessageViewController.m
//  XAnBao
//
//  Created by wyy on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SysMeageTableViewCell.h"
#import "AFNetworking.h"
#import "FrameAutoScaleLFL.h"
#import "UrlViewController.h"
#import "MessageModel.h"
@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *MessArr;
    UIAlertView * missalview ;
    NSString *jiazhangid;
}
@property(nonatomic,retain)UITableView *SettingTableView;


@end

@implementation SystemMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *demessarr=[def objectForKey:@"mess"];
   
    
    
    NSLog(@">>>>>>>=======%@",[def objectForKey:@"mess"]);
    
  
    
    if(!MessArr){
        MessArr =[[NSMutableArray alloc]init];
    }
    
    if (demessarr.count<=0) {
        [MessArr addObject:@"暂无消息"];
        
    }else{
        
    
    for (NSDictionary *dic in demessarr) {

        MessageModel *message=[[MessageModel alloc]initWithDic:dic];
        [MessArr addObject:message];
        self.SettingTableView.backgroundColor=[UIColor clearColor];
        [_SettingTableView reloadData
         ];
    }
    }
 
    [self initNavItem];
 
   }





-(void)VersionRequest
{
    
    
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    
    //这个是传的token
    NSDictionary *headerFieldValueDictionary =Token;

    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            //这里是给请求头添加 cookie
            [manger.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    
    //给接口传的 键值对

    NSDictionary *dict = @{
                           @"id":jiazhangid,
                           @"pass":@"true",
                           };
    [manger POST:@"http://118.190.97.150/interface/api1/class-grade/pass-attention" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@">>>>>=========%@",dic[@"message"]);
        
        missalview = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [missalview show];

          [self performSelector:@selector(dismissalertView) withObject:nil afterDelay:1.5];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


-(void)dismissalertView{

  [ missalview dismissWithClickedButtonIndex:0 animated:YES];

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
    titlelab.text = @"系统消息";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    
}

- (UITableView *)SettingTableView{
    if (!_SettingTableView) {
        _SettingTableView = [[UITableView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:65 width:320 height:503] style:UITableViewStylePlain];
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
    return MessArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysMeageTableViewCell *SettionCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!SettionCell) {
        
        SettionCell=[[SysMeageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                     @"cell"];
        
        MessageModel *model=MessArr[indexPath.row];
         NSLog(@">>>>%@",MessArr);
        
        
        NSLog(@">>>>%@",model.alert);
        
        
        SettionCell.Messatelab.text=[NSString stringWithFormat:@"%@",model.alert];
    }
    SettionCell.ArrowiconView.image=[UIImage imageNamed:@"jiantou.png"];
   
    
    return SettionCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MessageModel *messagemodel=MessArr[indexPath.row];
    if ([messagemodel.type isEqualToString:@"attention"]) {
        UIAlertView * alview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否同意该请求" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alview.tag=indexPath.row;
        [alview show];
        
        jiazhangid=messagemodel.jiazhangid;
        NSLog(@">>>>>>>>>>>>>>>%@",messagemodel.jiazhangid);
        
    }else if ([messagemodel.type isEqualToString:@"notice"]){
        
        UrlViewController *urlvc=[[UrlViewController alloc]init];
        urlvc.XqUrl=messagemodel.url;
        urlvc.titleStr=messagemodel.alert;
        [self.navigationController pushViewController:urlvc animated:1];
    }
    
  
}



//
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        return;
    }
    else if (buttonIndex==1  )
    {
       
             [self VersionRequest];
    } 
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
   
  

    
    
    
    
}



-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
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
