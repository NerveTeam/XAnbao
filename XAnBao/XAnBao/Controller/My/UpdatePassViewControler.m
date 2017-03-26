//
//  UpdatePassViewControler.m
//  XAnBao
//
//  Created by wyy on 17/3/17.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "UpdatePassViewControler.h"
#import "FrameAutoScaleLFL.h"
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
    pwdtxt=[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:80 width:280 height:40]];
    pwdtxt.placeholder=@"请输入原密码";
    pwdtxt.borderStyle=UITextBorderStyleRoundedRect;
    [loginimgview addSubview:pwdtxt];
    pwdtxt.leftViewMode=UITextFieldViewModeAlways;
    pwdtxt.keyboardType=UIKeyboardTypeNumberPad;
    
    
 //新密码
    
    newpwdtxt=[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:130 width:280 height:40]];
    newpwdtxt.placeholder=@"请输入新密码";
    newpwdtxt.borderStyle=UITextBorderStyleRoundedRect;
    newpwdtxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    [loginimgview addSubview:newpwdtxt];
    
    
    newpwdtxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    newpwdtxt.leftViewMode=UITextFieldViewModeAlways;
    newpwdtxt.keyboardType=UIKeyboardTypeNumberPad;
    newpwdtxt.secureTextEntry=YES;
 
    
    
 //确认密码
    surepwdtxt =[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:180 width:280 height:40]];
    surepwdtxt.placeholder=@"请再次确认密码";
    surepwdtxt.borderStyle=UITextBorderStyleRoundedRect;
    
    [loginimgview addSubview:surepwdtxt];
    
    
    surepwdtxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    surepwdtxt.leftViewMode=UITextFieldViewModeAlways;
    surepwdtxt.keyboardType=UIKeyboardTypeNumberPad;
    surepwdtxt.secureTextEntry=YES;

}


-(UIButton *)sureBtn{
    
    if (!_sureBtn) {
        _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:20 Y:220 width:280 height:30];
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
