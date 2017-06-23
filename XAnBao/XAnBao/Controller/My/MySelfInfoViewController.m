//
//  MySelfInfoViewController.m
//  XAnBao
//
//  Created by wyy on 17/3/17.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "MySelfInfoViewController.h"
#import "UpdatePassViewControler.h"
#import "FrameAutoScaleLFL.h"
#import "UIView+TopBar.h"
#import "MySelfTableCell.h"
#import "AFNetworking.h"
#import "SelfModel.h"
#import "HKNetEngine.h"
#import "QNResolver.h"
#import "QNDnsManager.h"
#import "QNNetworkInfo.h"
#import "ZXCameraManager.h"
#define KQNHttp @"http://7y6y23.com2.z1.glb.clouddn.com/"
#import "UIImageView+AFNetworking.h"
@interface MySelfInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArr;
    
    NSMutableArray *contentArr;
    
    Boolean  isSAVE;
    
    NSString *token_qn  , *urlString;
    
    UIImageView *imgview;
    
   }
@property(nonatomic,retain)UITableView *MySelfimfoTableView;
@end

@implementation MySelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contentArr=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
       isSAVE= false;
    titleArr=@[@"编辑头像",@"姓名",@"账号",@"性别",@"修改密码"];
    [self initNavItem];
    [self VersionRequest];
}
//初始化导航按钮
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
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToBeforeController)];
    [leftView addGestureRecognizer:tap];
    [BlueView addSubview:leftView];
    
    UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)*0.5, 30, 100, 25)];
    titlelab.text = @"个人信息";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    UIButton *SaveBt = [[UIButton alloc] initWithFrame:CGRectMake(280, 30, 40, 25)];
    SaveBt.contentMode = UIViewContentModeScaleAspectFit;
    [SaveBt setTitle:@"修改" forState:UIControlStateNormal];
    SaveBt.tag=620;
    SaveBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [BlueView addSubview:SaveBt];
    
    UIView *SaveView = [[UIView alloc]initWithFrame:CGRectMake(260, 10, 60, 60)];
//    SaveView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *savetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SaveforeController:)];
    SaveView.tag=619;
    [SaveView addGestureRecognizer:savetap];
    [BlueView addSubview:SaveView];
    
    
    
    
    
}

-(void)SaveforeController:(UIGestureRecognizer *)getster{
    UITextField *nametext  ,*sextext;
    UIButton *btn=[self.view viewWithTag:getster.view.tag+1];
   
    if ([btn.titleLabel.text isEqualToString:@"修改"]) {
        [btn setTitle:@"保存" forState:UIControlStateNormal];
    

         isSAVE=true;
        
        [_MySelfimfoTableView reloadData];
       
        
    }else if ([btn.titleLabel.text isEqualToString:@"保存"]) {

        [btn setTitle:@"修改" forState:UIControlStateNormal];
        isSAVE=false;
         [_MySelfimfoTableView reloadData];
        nametext=[self.view viewWithTag:101];
     
        sextext=[self.view viewWithTag:103];
        
        [self upinfoRequest:nametext.text url:urlString sex:sextext.text];
//        [self VersionRequest];
    }
  
}


-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
}
- (UITableView *)MySelfimfoTableView{
    if (!_MySelfimfoTableView) {
        _MySelfimfoTableView = [[UITableView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:65 width:320 height:503] style:UITableViewStylePlain];
        if (!IS_IPHONE_5) {
            _MySelfimfoTableView.frame=[FrameAutoScaleLFL CGLFLMakeX:0 Y:50 width:320 height:503];
        }
        
        
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
           }
    MySelfCell.namelbl.text=titleArr[indexPath.row];
   
    if (indexPath.row!=0) {
         MySelfCell.titlelabel.text=[NSString stringWithFormat:@"%@",contentArr[indexPath.row]];
    }
    
   
    MySelfCell.titlelabel.enabled=isSAVE;
    
    MySelfCell.titlelabel.tag=indexPath.row+100;
    
   
    MySelfCell.headerView.hidden=YES;
    MySelfCell.ArrowiconView.image=[UIImage imageNamed:@"jiantou.png"];
    
    
    if (indexPath.row ==0) {
        MySelfCell.titlelabel.enabled=false;
        MySelfCell.headerView.hidden=NO;
        MySelfCell.namelbl.frame=[FrameAutoScaleLFL CGLFLMakeX:80 Y:2 width:80 height:45];
//        MySelfCell.headerView.image=[UIImage imageNamed:@"blue.png"];
        NSURL *url = [NSURL URLWithString:contentArr[indexPath.row]];
        
        [MySelfCell.headerView  setImageWithURL:url];
        
        imgview= MySelfCell.headerView;
    }
 
    if (indexPath.row ==4 && indexPath.row==2) {
        MySelfCell.titlelabel.enabled=false;
       
    }

    
    
    
    MySelfCell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    
    
    return MySelfCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            if (isSAVE==true) {
                [self headImageClick];
                [self posttoken];
            }
            
            
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



#pragma mark --调用系统相册
-(void)headImageClick{
    [[ZXCameraManager getInstance]
     
     pickAlbumPhotoFromCurrentController:self imageBlock:^(UIImage *image) {
         
              imgview.image=image;
         [self dismissViewControllerAnimated:YES completion:nil];
         [self upLoadImageFile:image];
         
         
     }];
    
    
}
- (void)posttoken {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://139.129.221.253:8080/campus/api/v1/today_duty/token" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@",responseObject);
        
        token_qn=responseObject[@"upToken"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求ssss---%@",error);
        
        
    }];
    
}


- (void)upLoadImageFile:(UIImage *)img {
    
    NSData *data = UIImageJPEGRepresentation(img, 0.4f);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"xab_tp_wj%@.png", str];
    
    
    
    
    [[HKNetEngine shareInstance] uploadImageToQNFilePath:data name:fileName qnToken:token_qn Block:^(id dic, HKNetReachabilityType reachabilityType) {
        
        if (dic[@"hash"]) {
           
//            [self performSelector:@selector(dismissalertView) withObject:nil afterDelay:1.5];
            
            
            urlString = [NSString stringWithFormat:@"%@%@",KQNHttp, dic[@"key"]];
            
            NSLog(@">>>>>>>>>>%@",urlString);
        }
        
    }];
    
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
    }
       [manger GET:@"http://118.190.97.150/interface/api1/my" parameters:nil progress:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSDictionary *dic=responseObject[@"data"];
        
         SelfModel *selfmodel=[[SelfModel alloc]initWithDic:dic];
        
         
          [contentArr addObject:selfmodel.portrit];
          [contentArr addObject:selfmodel.name];
          [contentArr addObject:selfmodel.username];
         if ([[NSString stringWithFormat:@"%@",selfmodel.sex] isEqualToString:@"1"]) {
             [contentArr addObject:@"男"];
         }else if([[NSString stringWithFormat:@"%@",selfmodel.sex] isEqualToString:@"2"]){
               [contentArr addObject:@"女"];
         }
        
          [contentArr addObject:@""];
         self.MySelfimfoTableView.backgroundColor=[UIColor clearColor];
         [_MySelfimfoTableView reloadData];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
    
}


-(void)upinfoRequest:(NSString *)name url:(NSString *)url sex:(NSString *)sex
{
    NSString *isman;
    if ([sex isEqualToString:@"男"]) {
        isman=@"1";
    }
    if ([sex isEqualToString:@"女"]) {
         isman=@"2";
    }
    
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
                           @"portrit":url,
                           @"name":name,
                           @"sex":isman
                           };
    
    
    
    [manger POST:@"http://118.190.97.150/interface/api1/my/change-profile" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@">>>>>=========%@",dic[@"message"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
