//
//  MyWordViewController.m
//  XAnBao
//
//  Created by wyy on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "MyWordViewController.h"
#import "FrameAutoScaleLFL.h"
#import "SysMeageTableViewCell.h"
#import "AFNetworking.h"
#import "XABUserLogin.h"
#import "LiuYanModel.h"
@interface MyWordViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *ContentArr;
}
@property(nonatomic,retain)UITableView *SettingTableView;

@end

@implementation MyWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ContentArr=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initNavItem];
    [self VersionRequest];
    
    
}
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
    titlelab.text = @"我的留言";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    
}


- (UITableView *)SettingTableView{
    if (!_SettingTableView) {
        _SettingTableView = [[UITableView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:65  width:320 height:503] style:UITableViewStylePlain];
        
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
    return ContentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysMeageTableViewCell *SettionCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!SettionCell) {
        
        SettionCell=[[SysMeageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                     @"cell"];
        LiuYanModel *liuyanmodel=ContentArr[indexPath.row];
        SettionCell.Messatelab.text=liuyanmodel.content;
    }
    SettionCell.ArrowiconView.image=[UIImage imageNamed:@"jiantou.png"];

    
    
    return SettionCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LiuYanModel *liuyanmodel=ContentArr[indexPath.row];
    [self MyContent:liuyanmodel.content tag:[liuyanmodel.id intValue] name:liuyanmodel.teacherName];
    
    
}

-(void)MyContent:(NSString *)Content tag:(int)tag name:(NSString *)liuyanren{
    
    UIView *view, *whiteView;
    if (!view ) {
        
       
        
        
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        view.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:0.8];
        [self.view addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
        [view addGestureRecognizer:tap];

        whiteView=[[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:40 Y:170 width:240 height:220]];
        whiteView.backgroundColor=[UIColor whiteColor];
        [view addSubview:whiteView];
        
        
        UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:2 Y:50 width:236 height:Content.length*13/226*15]];
        
        
        UILabel *contenlbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:5 Y:60 width:226 height: Content.length*13/226*15]];
        
        contenlbl.text=Content;
        
        
        [view addSubview:scroll];
        
        
        
        
    }
  

}
-(void)removeView:(UIGestureRecognizer *)gesuter{
    [gesuter.view removeFromSuperview];
}

-(void)VersionRequest
{
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSDictionary *headerFieldValueDictionary =Token;
    
    NSLog(@">>>>>>>>>>>>>>>>>>%@",Token);
    
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [manger.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    };
    
    NSDictionary *dic=@{@"userId":[XABUserLogin getInstance].userInfo.id,
                        @"current":@"1"};

    
    NSLog(@">>>>>>>>>><<<<<=====%@",dic);
    
    [manger GET:@"http://118.190.97.150/interface/api1/my/mymessage" parameters:dic progress:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
      NSLog(@"%@",responseObject[@"message"])   ;
         
         if ([responseObject[@"message"]isEqualToString:  @"请求成功"]) {
             NSDictionary *dic=responseObject[@"data"];
             
             NSArray *resultArr=dic[@"results"];
             
             for (NSDictionary *contentDic in resultArr) {
                 LiuYanModel *liuyanmodel=[[LiuYanModel alloc]initWithDic:contentDic];
                 [ContentArr addObject:liuyanmodel];
                 
             }
         }
         self.SettingTableView.backgroundColor=[UIColor clearColor];
         [_SettingTableView reloadData];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
    
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
