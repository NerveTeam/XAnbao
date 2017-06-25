//
//  UpdatePassViewControler.m
//  XAnBao
//
//  Created by wyy on 17/3/17.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "UpdatePassViewControler.h"
#import "FrameAutoScaleLFL.h"
#import "AFNetworking.h"
#import "ToolsNSobject.h"
@interface UpdatePassViewControler ()
{
    UIImageView *loginimgview;

    UITextField *pwdtxt;
    UITextField *newpwdtxt;
    UITextField *surepwdtxt;
}
@property(nonatomic,retain)UIButton *sureBtn;
@end

@implementation UpdatePassViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
       [self set];
    self.sureBtn.backgroundColor=[UIColor colorWithRed:16/255.0 green:159/255.0 blue:1 alpha:1];

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
    titlelab.text = @"个人信息";
    titlelab.textColor = [UIColor whiteColor];
    titlelab.font = [UIFont systemFontOfSize:15];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [BlueView addSubview:titlelab];
    
    
}
-(void)backToBeforeController{
    [self.navigationController popViewControllerAnimated:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }


-(void) set{
    
    
    loginimgview=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:320 height:568]];
    loginimgview.userInteractionEnabled=YES;
//    loginimgview.image=[UIImage imageNamed:@"1.png"];
    loginimgview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:loginimgview];
    
    
 
   //原密码
    pwdtxt=[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:60 width:280 height:30]];
    pwdtxt.placeholder=@"请输入原密码";
    [loginimgview addSubview:pwdtxt];
    pwdtxt.leftViewMode=UITextFieldViewModeAlways;
    pwdtxt.secureTextEntry=YES;
    pwdtxt.keyboardType=UIKeyboardTypeNumberPad;
     [pwdtxt setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    UIView * pwdlineV = [[UIView alloc]initWithFrame:CGRectMake(0, pwdtxt.frame.size.height, pwdtxt.frame.size.width, 1)];
    [pwdlineV setBackgroundColor:[UIColor grayColor]];
    [pwdtxt addSubview: pwdlineV];

 //新密码
    
    newpwdtxt=[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:110 width:280 height:30]];
    newpwdtxt.placeholder=@"请输入新密码";
    newpwdtxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    [loginimgview addSubview:newpwdtxt];
    
    
    newpwdtxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    newpwdtxt.leftViewMode=UITextFieldViewModeAlways;
    newpwdtxt.keyboardType=UIKeyboardTypeNumberPad;
    newpwdtxt.secureTextEntry=YES;
    [newpwdtxt setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];

    UIView * newpwdline = [[UIView alloc]initWithFrame:CGRectMake(0, newpwdtxt.frame.size.height, newpwdtxt.frame.size.width, 1)];
    [newpwdline setBackgroundColor:[UIColor grayColor]];
    [newpwdtxt addSubview:newpwdline];
    
    
 //确认密码
    surepwdtxt =[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:190 width:280 height:30]];
    surepwdtxt.placeholder=@"请再次确认密码";
    [loginimgview addSubview:surepwdtxt];
    
    [surepwdtxt setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    surepwdtxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    surepwdtxt.leftViewMode=UITextFieldViewModeAlways;
    surepwdtxt.keyboardType=UIKeyboardTypeNumberPad;
    surepwdtxt.secureTextEntry=YES;

    
    UIView * surepwdlineV= [[UIView alloc]initWithFrame:CGRectMake(0, surepwdtxt.frame.size.height, surepwdtxt.frame.size.width, 1)];
    [surepwdlineV setBackgroundColor:[UIColor grayColor]];
    [surepwdtxt addSubview:surepwdlineV];
}


-(UIButton *)sureBtn{
    
    if (!_sureBtn) {
        _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:20 Y:230 width:280 height:30];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [loginimgview addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sueClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


-(void)sueClick{
    
    if ((newpwdtxt.text.length !=surepwdtxt.text.length) || (! [newpwdtxt.text isEqualToString:surepwdtxt.text]) ) {
        UIAlertView * alview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alview.delegate=self;
        [alview show];
    }else{
        [self VersionRequest];
    }
}





//这是网络请求的方法
-(void)VersionRequest
{
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    
    //这个是传的token
    NSDictionary *headerFieldValueDictionary =Token;
    
    NSLog(@">>>>>>>>>>>>>>%@",Token);
    
    
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            //这里是给请求头添加 cookie
            [manger.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    
    //给接口传的 键值对
    
    NSDictionary *dict = @{
                           
                           
                           @"password":[ToolsNSobject textMd5:newpwdtxt.text],
                           @"originalPassword":[ToolsNSobject textMd5:pwdtxt.text],
                           };
    [manger POST:@"http://118.190.97.150/interface/api1/my/change-password" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *dic=responseObject;
        
        //输出的内容
        
        NSLog(@">>>>>=========%@",responseObject);
        NSLog(@">>>>>=======message======%@",dic[@"message"]);
        NSLog(@">>>>>=======code==%@",dic[@"code"]);
      
        [self creatalt:dic[@"code"]];
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}



-(void)creatalt:(NSString *)code{
    
    UIAlertView * alview;
  
        
        if ([code isEqualToString:@"200" ]) {
            alview  = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alview.delegate=self;
            [alview show];
        }else{
            alview  = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码错误，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alview.delegate=self;
            [alview show];
        }
        
        
   

}


//清楚缓存
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
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
