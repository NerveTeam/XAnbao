//
//  AboutOurViewController.m
//  XAnBao
//
//  Created by wyy on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "AboutOurViewController.h"
#import "AboutOurTableViewCell.h"
#import "AFNetworking.h"
#import "FrameAutoScaleLFL.h"
#import "UrlViewController.h"

@interface AboutOurViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *AboutArr;
    NSArray *AboutCode;
    
}
@property(nonatomic,retain)UITableView *SettingTableView;



@end

@implementation AboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    AboutArr=@[@"家长帮助",@"教师帮助",@"关于我们"];
    AboutCode=@[@"10003",@"10002",@"10001"];
    
    [self initNavItem];
    self.SettingTableView.backgroundColor=[UIColor clearColor];

   
}
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
    titlelab.text = @"关于我们";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    
}





-(void)AbuoutRequest:(NSString *)aboutCode
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
        NSDictionary *dict = @{
                           @"itemId":aboutCode,
                          
                           };
    [manger POST:@"http://118.190.97.150/interface/api1/school/helpitem" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@">>>>>=========%@",dic[@"message"]);
         NSLog(@">>>>>=========%@",dic[@"data"]);
        if ([dic[@"message"] isEqualToString:@"请求成功"]) {
            UrlViewController *urlvc=[UrlViewController alloc];
            urlvc.XqUrl=[NSString stringWithFormat:@"%@",dic[@"data"]];
            [self.navigationController pushViewController:urlvc animated:1];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
    return AboutArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AboutOurTableViewCell *SettionCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!SettionCell) {
        
        SettionCell=[[AboutOurTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                     @"cell"];
        SettionCell.titlelab.text=AboutArr[indexPath.row];
    }
    
    
    
    return SettionCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [self AbuoutRequest:AboutCode[indexPath.row]];

}




-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
