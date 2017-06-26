//
//  XABLoginViewController.m
//  XAB
//
//  Created by 韩森 on 2017/3/10.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "XABLoginViewController.h"
#import "UITextField+CHTHealper.h"
#import "Masonry.h"
#import "XABLoginMacro.h"
#import "XABLoginRegisterViewController.h"
#import "XABFindPasswordViewController.h"
#import "YBTabBarController.h"
#import "AppDelegate.h"
#import "XABUserLogin.h"
#import "UIView+TopBar.h"
#import "XABShareSDKTool.h"
#import "XABChatTool.h"
@interface XABLoginViewController ()

{
    UIButton *_goInBtn;      // 浏览进入
    
    UIButton *_loginBtn;     // 登录

    UIButton *_registerBtn;  // 注册按钮
    
    UIButton *_forgetBtn;    // 忘记密码
    
    UIButton *_shareBtn;    // 忘记密码

}
@property (nonatomic,strong) UIScrollView  *backScrollView;
@property (nonatomic,strong) UIView *topBarView;
@property (nonatomic,strong) UIImageView   *imgView;
@property (nonatomic,strong) UILabel       *signaLabel;
@property (nonatomic,strong) UITextField   *accountTF;
@property (nonatomic,strong) UITextField   *passwordTF;



@end

@implementation XABLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    [self initSubViews];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

#pragma mark - 浏览进入
-(void)goInClick{
    
    
    YBTabBarController *tabBarController = [[YBTabBarController alloc]init];
    
    AppDelegate *app =(AppDelegate *) [[UIApplication sharedApplication] delegate ];
    app.window.rootViewController = tabBarController;
    
}

#pragma mark - 登录
-(void)loginClick{
    
   
    if (self.accountTF.text.length ==0 && self.passwordTF.text.length == 0) {
        
        [self showMessage:@"账号、密码不能为空"];
        return;
    }
    [[XABUserLogin getInstance] userLogin:self.accountTF.text password:self.passwordTF.text callBack:^(BOOL success, XABUserModel *user) {
        
        
        if (success) {
            NSLog(@"登录成功");
//            [self showMessage:@"登录成功"];
            [[XABChatTool getInstance] initWithRCIM];
            [[XABChatTool getInstance] connectRCServer];

            YBTabBarController *tabBarController = [[YBTabBarController alloc]init];
            
            AppDelegate *app =(AppDelegate *) [[UIApplication sharedApplication] delegate ];
            app.window.rootViewController = tabBarController;
            [app.window makeKeyAndVisible];


        }else {
            // 提示用户名密码错误
            [self showMessage:@"用户名密码错误"];
        }
    }];

}

#pragma mark - 跳转 到 注册
-(void)registerClick{
    
    [self pushToController:[[XABLoginRegisterViewController alloc]init] animated:YES];
}
#pragma mark - 跳转 到 忘记密码

-(void)findPasswordClick{
    
    [self pushToController:[[XABFindPasswordViewController alloc]init] animated:YES];
}

-(void)shareClick{
    
    NSArray* imageArray = @[@"http://touxiang.qqzhi.com/uploads/2012-11/1111105304979.jpg"];
    [XABShareSDKTool shareContentWithShareContentType:SSDKContentTypeAuto contentTitle:@"大家好" contentDescription:@"详情描述" contentImage:imageArray contentURL:@"https://sports.sina.cn/nba/warriors/2017-03-09/detail-ifychhuq3433755.d.html?vt=4&pos=10&HTTPS=1" showInView:self.backScrollView success:^{
        DLog(@"分享成功");
    } failure:^(NSString *failureInfo) {
        DLog(@"分享失败=%@",failureInfo);

    } OtherResponseStatus:^(SSDKResponseState state) {
        DLog(@"分享state=%ld",state);

    }];
}

#pragma mark - 初始化 加载 视图
-(void)initSubViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.frame];;
    imgView.image = [UIImage imageNamed:@"bj"];
    [self.view addSubview:imgView];
    
//    self.navgationView.backgroundColor = kColorWithRGB(47, 132, 213, 1.0f);
    [self topBarView];
    self.backScrollView.backgroundColor = [UIColor clearColor];

    [self imgView];
    [self signaLabel];
    [self accountTF];
    [self passwordTF];
    
    
//    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.5];
//    [_shareBtn setTitleColor:kColorWithRGB(47, 132, 213, 1.0f) forState:UIControlStateNormal];
//    [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.backScrollView addSubview:_shareBtn];
    
//    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.offset(SPACEING*6/7);
//        make.left.equalTo(self.topBarView.mas_left).offset(10);
//        make.height.offset(25);
//        make.width.offset(120);
//    }];
    
    WS(weakSelf);

    //浏览进入
    
//    _goInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_goInBtn setTitle:@"浏览进入 >>" forState:UIControlStateNormal];
//    _goInBtn.titleLabel.font = [UIFont systemFontOfSize:14.5];
//    [_goInBtn setTitleColor:kColorWithRGB(47, 132, 213, 1.0f) forState:UIControlStateNormal];
//    [_goInBtn addTarget:self action:@selector(goInClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.backScrollView addSubview:_goInBtn];
//    [_goInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.offset(SPACEING*6/7);
//        make.right.equalTo(weakSelf.topBarView.mas_right).offset(-10);
//        make.height.offset(25);
//        make.width.offset(120);
//    }];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.backgroundColor = kThemeBackGroundColor;
    _loginBtn.layer.cornerRadius = 3.0f;
    [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backScrollView addSubview:_loginBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.passwordTF.mas_bottom).offset(SPACEING*1.2);
        make.right.equalTo(weakSelf.passwordTF).offset(10);
        make.left.offset(LEFTSPACEING - 10);
        make.height.offset(TFHEIGHT/4*5);
    }];

    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_registerBtn setTitleColor:kColorWithRGB( 251, 175, 68, 1.0f) forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:_registerBtn];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_loginBtn.mas_bottom).offset(5);
        make.right.equalTo(_loginBtn.mas_right).offset(0);
        make.width.offset(80);
        make.height.offset(28);
    }];

    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_forgetBtn addTarget:self action:@selector(findPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:_forgetBtn];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_loginBtn.mas_bottom).offset(5);
        make.left.equalTo(_loginBtn.mas_left).offset(0);
        make.width.offset(100);
        make.height.offset(28);
    }];
}

#pragma mark - 懒加载

-(UITextField *)passwordTF{
    
    if (!_passwordTF) {
        
        _passwordTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_passwordTF];
        _passwordTF.moveView = self.backScrollView;
        
        
        WS(weakSelf);
        
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.accountTF.mas_bottom).offset(10);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
        }];
        
        //创建左侧视图
//        UIImage *im = [UIImage imageNamed:@""];
//        UIImageView *iv = [[UIImageView alloc] initWithImage:im];
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 20+50, 28)];//宽度根据需求进行设置，高度必须大于 textField 的高度
//        iv.center = CGPointMake(leftView.center.x-30, leftView.center.y);
//        [leftView addSubview:iv];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"密码:";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.frame = CGRectMake(0, 0, 40, 28);
//        titleLabel.center = CGPointMake(leftView.center.x, leftView.center.y);
//        [leftView addSubview:titleLabel];
        
        [_passwordTF sizeToFit];
        _passwordTF.leftView = titleLabel;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
        [_passwordTF setSecureTextEntry:YES];
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


-(UITextField *)accountTF{
    
    if (!_accountTF) {
        
        _accountTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_accountTF];
        _accountTF.moveView = self.backScrollView;
        
        
        WS(weakSelf);
        
        [_accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.signaLabel.mas_bottom).offset(50);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
        }];
        
        //创建左侧视图
//        UIImage *im = [UIImage imageNamed:@""];
//        UIImageView *iv = [[UIImageView alloc] initWithImage:im];
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 20+50, 28)];//宽度根据需求进行设置，高度必须大于 textField 的高度
//        iv.center = CGPointMake(leftView.center.x-30, leftView.center.y);
//        [leftView addSubview:iv];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"账号:";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.frame = CGRectMake(0, 0, 40, 28);
//        titleLabel.center = CGPointMake(leftView.center.x, leftView.center.y);
//        [leftView addSubview:titleLabel];

        [_accountTF sizeToFit];
        _accountTF.leftView = titleLabel;
        _accountTF.leftViewMode = UITextFieldViewModeAlways;

        _accountTF.placeholder = @"请输入账号";
        
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
        [self.accountTF.layer addSublayer:lineLayerOne];
        
    }
    return _accountTF;
}

-(UILabel *)signaLabel{
    
    if (!_signaLabel) {
        
        _signaLabel = [[UILabel alloc] init];
        [self.backScrollView addSubview:_signaLabel];
        _signaLabel.text =  @"家校共育   多彩童年";
        _signaLabel.textColor = kColorWithRGB( 251, 175, 68, 1.0f);
        _signaLabel.font = [UIFont systemFontOfSize:21];
        _signaLabel.textAlignment = NSTextAlignmentCenter;
        
        WS(weakSelf);
        
        [_signaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.imgView.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.backScrollView);
            make.width.offset(220);
            make.height.offset(30);
        }];
    }
    return _signaLabel;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"校安宝"]];;
//        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.backScrollView addSubview:_imgView];
        
        WS(weakSelf);
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(SPACEING*2.6);
            make.centerX.equalTo(weakSelf.backScrollView);
            make.width.offset(3*IMAGE_HEIGHT);
            make.height.offset(IMAGE_HEIGHT);
            
        }];
    }
    return _imgView;
}

//初始化导航按钮
-(UIView *)topBarView
{
    if (!_topBarView) {
        
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        [self.view addSubview:_topBarView];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"登录" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
    }
    return _topBarView;
}
//-(UIView *)navgationView{
//    if (!_navgationView) {
//        
//        _navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//        [self.view addSubview:_navgationView];
//        
//        UILabel * registerLabel = [[UILabel alloc] init];
//        registerLabel.center = CGPointMake(_navgationView.center.x, _navgationView.center.y+10);
//        registerLabel.bounds = CGRectMake(0, 0, 100, 40);
//        registerLabel.text =  @"登录";
//        registerLabel.textColor = [UIColor whiteColor];
//        registerLabel.textAlignment = NSTextAlignmentCenter;
//        [_navgationView addSubview:registerLabel];
//        
//    }
//    return _navgationView;
//}

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
