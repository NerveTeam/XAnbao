//
//  UrlViewController.m
//  XAnBao
//
//  Created by wyy on 17/6/20.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "UrlViewController.h"

@interface UrlViewController ()

@end

@implementation UrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavItem];
    
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width,self.view.frame.size.height)];
    NSURL *url=[NSURL URLWithString:_XqUrl];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}
-(void)buttonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)*0.5, 30, 100, 25)];
//    titlelab.text = self.titleStr;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
