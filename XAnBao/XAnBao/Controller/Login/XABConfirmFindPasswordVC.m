//
//  XABConfirmFindPasswordVC.m
//  XAB
//
//  Created by 韩森 on 2017/3/11.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "XABConfirmFindPasswordVC.h"
#import "Masonry.h"
#import "UITextField+CHTHealper.h"
#import "XABLoginMacro.h"
#import "XABLoginViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
@interface XABConfirmFindPasswordVC ()
{
    
    UIButton *_confirmBtn;
    
}
@property (nonatomic,strong) UIScrollView  *backScrollView;
@property (nonatomic,strong) UIView        *navgationView;
@property (nonatomic,strong) UIButton      *backBtn;
@property (nonatomic,strong) UITextField   *passwordTF;
@property (nonatomic,strong) UITextField   *rPasswordTF;
@end

@implementation XABConfirmFindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
}

#pragma mark - 确认

-(void)confirmClick{
    
    if (self.passwordTF.text.length <1) return;
    if (self.passwordTF.text != self.rPasswordTF.text) {
        
        [self showMessage:@"两次输入密码不一致"];
        return;
    }
    
    //修改密码
    [[XABUserLogin getInstance] modifyPassword:self.passwordTF.text callBack:^(BOOL success,NSString *message) {
        
        if (success) {
            
            [self showMessage:@"修改密码成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pushToController:[[XABLoginViewController alloc] init] animated:YES];
                
            });
        }else{
            [self showMessage:@"修改密码失败"];
        }
    }];
    
}



-(void)initSubViews{
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navgationView.backgroundColor = kColorWithRGB(47, 132, 213,10.f);
    [self passwordTF];
    
    [self rPasswordTF];
    
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = kColorWithRGB(46, 132, 213, 1.0f);
    _confirmBtn.layer.cornerRadius = 3.0f;
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backScrollView addSubview:_confirmBtn];
    
    WS(weakSelf);
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.rPasswordTF.mas_bottom).offset(40);
        make.right.equalTo(weakSelf.rPasswordTF.mas_right).offset(0);
        make.left.equalTo(weakSelf.rPasswordTF.mas_left).offset(-10);
        make.height.offset(TFHEIGHT/4*5);
    }];
    
    
}
-(UITextField *)rPasswordTF{
    
    if (!_rPasswordTF) {
        
        _rPasswordTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_rPasswordTF];
        _rPasswordTF.moveView = self.backScrollView;
        
        
        WS(weakSelf);
        
        [_rPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.passwordTF.mas_bottom).offset(10);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
            make.right.equalTo(weakSelf.passwordTF.mas_right).offset(15);
        }];
        
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imagView.image = [UIImage imageNamed:@""];
        _rPasswordTF.leftView = imagView;
        _rPasswordTF.contentMode = UITextFieldViewModeAlways;
        _rPasswordTF.placeholder = @"请再次确认密码";
        
        // 线的路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        // 起点
        [linePath moveToPoint:CGPointMake(-10, TFHEIGHT)];
        // 其他点
        [linePath addLineToPoint:CGPointMake(TFWIDTH+10,TFHEIGHT)];// 40+70+20+35+40 +
        
        CAShapeLayer *lineLayerOne = [CAShapeLayer layer];
        
        lineLayerOne.lineWidth = 0.3;
        lineLayerOne.strokeColor = [UIColor lightGrayColor].CGColor;
        lineLayerOne.path = linePath.CGPath;
        lineLayerOne.fillColor = nil; // 默认为blackColor
        [_rPasswordTF.layer addSublayer:lineLayerOne];
        
    }
    return _rPasswordTF;
}


-(UITextField *)passwordTF{
    
    if (!_passwordTF) {
        
        _passwordTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_passwordTF];
        _passwordTF.moveView = self.backScrollView;
        
        
        WS(weakSelf);
        
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.navgationView.mas_bottom).offset(SPACEING*2);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
        }];
        
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imagView.image = [UIImage imageNamed:@""];
        _passwordTF.leftView = imagView;
        _passwordTF.contentMode = UITextFieldViewModeAlways;
        _passwordTF.placeholder = @"请输入密码";
        
        // 线的路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        // 起点
        [linePath moveToPoint:CGPointMake(-10, TFHEIGHT)];
        // 其他点
        [linePath addLineToPoint:CGPointMake(TFWIDTH+10,TFHEIGHT)];// 40+70+20+35+40 +
        
        CAShapeLayer *lineLayerOne = [CAShapeLayer layer];
        
        lineLayerOne.lineWidth = 0.3;
        lineLayerOne.strokeColor = [UIColor lightGrayColor].CGColor;
        lineLayerOne.path = linePath.CGPath;
        lineLayerOne.fillColor = nil; // 默认为blackColor
        [_passwordTF.layer addSublayer:lineLayerOne];
        
    }
    return _passwordTF;
}


//初始化导航按钮
-(UIView *)navgationView
{
    if (!_navgationView) {
        
        _navgationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        [self.view addSubview:_navgationView];
        _navgationView = [_navgationView topBarWithTintColor:ThemeColor title:@"找回密码" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
    }
    return _navgationView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
}


-(UIScrollView *)backScrollView{
    
    if (!_backScrollView) {
        
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        
        _backScrollView.alwaysBounceVertical = YES;
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_backScrollView];
        
    }
    return _backScrollView;
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
