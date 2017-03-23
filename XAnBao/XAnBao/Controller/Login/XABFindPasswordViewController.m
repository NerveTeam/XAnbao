//
//  XABFindPasswordViewController.m
//  XAB
//
//  Created by 韩森 on 2017/3/10.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "XABFindPasswordViewController.h"
#import "Masonry.h"
#import "UITextField+CHTHealper.h"
#import "XABLoginMacro.h"
#import "XABConfirmFindPasswordVC.h"
#import "XABLoginViewController.h"
#import "NSString+Check.h"
@interface XABFindPasswordViewController ()
{
    
    UIButton *_codeBtn;
    
    UIButton *_nextBtn;

    UIButton *_loginBtn;
    
    NSTimer  * _timer;
    
    int        _seconds;

}
@property (nonatomic,strong) UIScrollView  *backScrollView;
@property (nonatomic,strong) UIView        *navgationView;

@property (nonatomic,strong) UITextField   *phoneTF;
@property (nonatomic,strong) UITextField   *codeTF;
@end

@implementation XABFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
}


#pragma mark - 下一步
-(void)nextClick{
 
    XABConfirmFindPasswordVC *vc = [[XABConfirmFindPasswordVC alloc] init];
    [self pushToController:vc animated:YES];
}

#pragma mark - 立即登录

-(void)loginClick{
    
//    [[XABUserLogin getInstance] userLogin:self.phoneTF.text password:self.codeTF.text callBack:^(BOOL success, XABUserModel *user) {
//        
//    }];
    //[self pushToController:[[XABLoginViewController alloc] init] animated:YES];
    [self popViewControllerAnimated:YES];
}


#pragma mark - 发送验证码

-(void)codeClick:(id)sender{
    
    if (![self.phoneTF.text isMobileNumber]) {

        DLog( @"手机号码有误");
        return;
    }
    
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(tmierCountDown:) object:sender];
    [self performSelector:@selector(tmierCountDown:) withObject:sender afterDelay:0.2f];
    
    [[XABUserLogin getInstance] requestVerifyCode:self.phoneTF.text callBack:^(BOOL success) {
        
        if (success) {
             DLog( @"验证码已发送");
        }else{
            
        }
    }];
}

-(void)tmierCountDown:(id)sender{
    
    // 开始倒数, 用户暂时不可与按钮交互
    [_codeBtn setUserInteractionEnabled:NO];
    //改变验证码的状态
    //发送验证码时的倒计时-----点击后就会有倒计时
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    _seconds = 60;
    
}
-(void)timerFireMethod:(NSTimer *)theTimer{
    
    if (_seconds == 1) {
        // 倒数完毕, 用户可与按钮进行交互.
        [_codeBtn setUserInteractionEnabled:YES];
        
        [theTimer invalidate];
        _seconds = 60;
        
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.backgroundColor = kThemeBackGroundColor;
        
    }else{
        _seconds = _seconds -1;
        NSString *title = [NSString stringWithFormat:@"%d秒请重试",_seconds];
        [_codeBtn setTitle:title forState:UIControlStateNormal];
        _codeBtn.backgroundColor = kColorWithRGB(140, 157, 172, 0.5f);
        
    }
}


-(void)initSubViews{
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navgationView.backgroundColor = kColorWithRGB(47, 132, 213,10.f);
    [self phoneTF];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeBtn addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backScrollView addSubview:_codeBtn];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _codeBtn.layer.cornerRadius = 3.0f;
    _codeBtn.backgroundColor = kThemeBackGroundColor;
    
    
    WS(weakSelf);
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.phoneTF.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.phoneTF).offset(10);
        make.width.offset(100);
        make.height.offset(TFHEIGHT );
    }];
    
    [self codeTF];

    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor = kThemeBackGroundColor;
    _nextBtn.layer.cornerRadius = 3.0f;
    [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backScrollView addSubview:_nextBtn];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.codeTF.mas_bottom).offset(40);
        make.right.equalTo(_codeBtn.mas_right).offset(0);
        make.left.equalTo(weakSelf.codeTF.mas_left).offset(-10);
        make.height.offset(TFHEIGHT/4*5);
    }];

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitleColor:kColorWithRGB( 251, 175, 68, 1.0f) forState:UIControlStateNormal];
    [self.backScrollView addSubview:_loginBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nextBtn.mas_bottom).offset(0);
        make.width.offset(90);
        make.left.equalTo(_nextBtn.mas_left).offset(0);
        make.height.offset(TFHEIGHT/4*5);
    }];

    
}
-(UITextField *)codeTF{
    
    if (!_codeTF) {
        
        _codeTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_codeTF];
        _codeTF.moveView = self.backScrollView;
        
        
        WS(weakSelf);
        
        [_codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.phoneTF.mas_bottom).offset(10);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
            make.right.equalTo(_codeBtn.mas_right).offset(15);
        }];
        
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imagView.image = [UIImage imageNamed:@""];
        _codeTF.leftView = imagView;
        _codeTF.contentMode = UITextFieldViewModeAlways;
        _codeTF.placeholder = @"请输入验证码";
        
        // 线的路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        // 起点
        [linePath moveToPoint:CGPointMake(-10, TFHEIGHT)];
        // 其他点
        [linePath addLineToPoint:CGPointMake(TFWIDTH+10-100-15,TFHEIGHT)];// 40+70+20+35+40 +
        
        CAShapeLayer *lineLayerOne = [CAShapeLayer layer];
        
        lineLayerOne.lineWidth = 0.3;
        lineLayerOne.strokeColor = [UIColor lightGrayColor].CGColor;
        lineLayerOne.path = linePath.CGPath;
        lineLayerOne.fillColor = nil; // 默认为blackColor
        [_codeTF.layer addSublayer:lineLayerOne];
        
    }
    return _codeTF;
}


-(UITextField *)phoneTF{
    
    if (!_phoneTF) {
        
        _phoneTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_phoneTF];
        _phoneTF.moveView = self.backScrollView;
        
        
        WS(weakSelf);
        
        [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.navgationView.mas_bottom).offset(SPACEING*2);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
        }];
        
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imagView.image = [UIImage imageNamed:@""];
        _phoneTF.leftView = imagView;
        _phoneTF.contentMode = UITextFieldViewModeAlways;
        _phoneTF.placeholder = @"请输入手机号";
        
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
        [_phoneTF.layer addSublayer:lineLayerOne];
        
    }
    return _phoneTF;
}


-(UIView *)navgationView{
    if (!_navgationView) {
        
        _navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [self.view addSubview:_navgationView];
        
        UILabel * registerLabel = [[UILabel alloc] init];
        registerLabel.center = CGPointMake(_navgationView.center.x, _navgationView.center.y+10);
        registerLabel.bounds = CGRectMake(0, 0, 100, 40);
        registerLabel.text =  @"找回密码";
        registerLabel.textColor = [UIColor whiteColor];
        registerLabel.textAlignment = NSTextAlignmentCenter;
        [_navgationView addSubview:registerLabel];
        
    }
    return _navgationView;
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