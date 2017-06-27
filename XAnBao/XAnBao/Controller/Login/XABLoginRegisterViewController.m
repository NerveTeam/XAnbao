//
//  XABLoginRegisterViewController.m
//  XAB
//
//  Created by 韩森 on 2017/3/8.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "XABLoginRegisterViewController.h"
#import "Masonry.h"
#import "UITextField+CHTHealper.h"
#import "XABLoginMacro.h"
#import "NSString+Check.h"
#import "XABUserLogin.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABUserProtocolViewController.h"
@interface XABLoginRegisterViewController ()<UITextViewDelegate>
{
    UIButton *_codeBtn;     // 发送验证码按钮
    
    UIButton *_registerBtn; // 注册按钮
    
    UIButton *_isCheck;     // 是否打勾
    
    BOOL      _isCheckYesOrNo;// No 是不允许注册的
    
    NSTimer  * _timer;
    
    int        _seconds;
}
@property (nonatomic,strong) UIScrollView  *backScrollView;
@property (nonatomic,strong) UIView        *navgationView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIImageView   *imgView;
@property (nonatomic,strong) UILabel       *signaLabel;
@property (nonatomic,strong) UITextField   *nameTF;
@property (nonatomic,strong) UITextField   *phoneTF;
@property (nonatomic,strong) UITextField   *passwordTF;
@property (nonatomic,strong) UITextField   *rPasswordTF;
@property (nonatomic,strong) UITextField   *codeTF;

@property (nonatomic,strong) UITextView    *prtrolTextView;              // 用户注册协议
@property (nonatomic,copy) NSString *html_str;
@end

@implementation XABLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSubViews];
    
    [self getUserPortocol];
}
-(void)getUserPortocol{
    
    [XABRegisterProtocolRequest requestDataWithParameters:@{@"itemId" : @"10004"} successBlock:^(BaseDataRequest *request) {
        
        if (request) {
            
            NSString *html = [request.responseObject objectForKey:@"data"];
            
            self.html_str = html;
        }
        
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}
#pragma mark - 注册
-(void)registerClick{
    
    [self.view endEditing:YES];
    
    if(_isCheckYesOrNo == NO) return  [self showMessage:@"您同意用户协议才可以注册哟!"];
    NSString *rpassword = [self.rPasswordTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *password = [self.passwordTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![rpassword isEqualToString:password] ) {
                 
        [self showMessage:@"两次输入的密码不一致"];
        return;
    }
    //先验证 短信验证码是否正确
    [[XABUserLogin getInstance] verifyCodeResult:self.codeTF.text callBack:^(BOOL success,NSString *message) {
        
        if (success) {
            
            // 进行注册
            [[XABUserLogin getInstance] userPostRegisterName:self.nameTF.text password:rpassword callBack:^(BOOL success, XABUserModel *user) {
                if (success) {
                    [self loginJump];
                }
            }];
        
            
        }else{
            [self showMessage:@"验证码有误"];
        }
        
    }];
    
   
    
//    [self loginJump];
    
}


#pragma mark - 发送验证码

-(void)codeClick:(id)sender{
    
    if (![self.phoneTF.text isMobileNumber]) {
        
        [self showMessage:@"手机号码有误"];

        return;
    }
    
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(tmierCountDown:) object:sender];
    [self performSelector:@selector(tmierCountDown:) withObject:sender afterDelay:0.2f];
    
    //先判断是否注册了
    [[XABUserLogin getInstance] isResister:self.phoneTF.text callBack:^(BOOL success,NSString*message) {
        
        if (!success) {//该账户未注册
            
            //获取验证码
            [[XABUserLogin getInstance] requestVerifyCode:self.phoneTF.text callBack:^(BOOL success,NSString*message) {
                
                if (success) {
                    // 提示该获取验证码成功
                    [self showMessage:@"验证码获取成功"];

                }else{
                    
                    // 提示该获取验证码失败
                    [self showMessage:@"验证码获取失败"];

                }
                
            }];
            
        }else{
            
            if (message) {
                
                // 提示该帐号已注册
                [self showMessage:message];

            }else{
                [self showMessage:@"请求失败"];

            }
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

#pragma mark - 点击服务协议
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"protocol"]) {
     
        XABUserProtocolViewController *vc = [[XABUserProtocolViewController alloc] init];
        vc.html_str = self.html_str;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    
    [textView resignFirstResponder  ];

}

#pragma mark - 是否对  服务协议  打勾
-(void)checkBtnClick{
    
    _isCheck.selected = !_isCheck.selected;
    
    if (_isCheck.selected) {
        
        _isCheckYesOrNo = YES;
    }else{
        _isCheckYesOrNo = NO;

    }
}


- (void)popVc {
    self.spring = YES;
    [self popViewcontrollerAnimationType:UIViewAnimationTypeSlideOut];
}
- (void)loginJump {
    [self popViewControllerAnimated:YES];
}

-(void)endEditing{
    
    [self.backScrollView endEditing:YES];
}

-(void)initSubViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.frame];;
    imgView.image = [UIImage imageNamed:@""];
    [self.view addSubview:imgView];

    self.navgationView.backgroundColor = kColorWithRGB(47, 132, 213, 1.0f);
    self.backScrollView.backgroundColor = [UIColor clearColor];
//    [self imgView];
//    [self signaLabel];
    [self nameTF];
    [self phoneTF];
    [self passwordTF];
    [self rPasswordTF];
    [self codeTF];
    
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_codeBtn addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backScrollView addSubview:_codeBtn];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _codeBtn.layer.cornerRadius = 3.0f;
    _codeBtn.backgroundColor = kColorWithRGB(46, 132, 213, 1.0f);
    
    
    WS(weakSelf);
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf.codeTF);
        make.right.equalTo(weakSelf.codeTF).offset(10);
        make.width.offset(95);
        make.height.offset(TFHEIGHT-2);
    }];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.backgroundColor = kColorWithRGB(46, 132, 213, 1.0f);
    _registerBtn.layer.cornerRadius = 3.0f;
    [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backScrollView addSubview:_registerBtn];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.rPasswordTF.mas_bottom).offset(SPACEING);
        make.right.equalTo(weakSelf.codeTF).offset(10);
        make.left.offset(LEFTSPACEING - 10);
        make.height.offset(TFHEIGHT/4*5);
    }];
    
    [self prtrolLabel];
    
}

-(UITextView *)prtrolLabel{
    
    if (!_prtrolTextView) {
        
        _prtrolTextView = [[UITextView alloc] init];
        _prtrolTextView.backgroundColor = [UIColor clearColor];
        _prtrolTextView.font = [UIFont systemFontOfSize:12];
        _prtrolTextView.textColor = [UIColor darkGrayColor];
        [self.backScrollView addSubview:_prtrolTextView];
        [_prtrolTextView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_registerBtn.mas_bottom).offset(15);
            make.centerX.equalTo(_registerBtn.mas_centerX);
            make.width.offset(230);
            make.height.offset(25);
        }];
        
//        _prtrolTextView.selectable = NO;
        _prtrolTextView.editable = NO;
        _prtrolTextView.scrollEnabled = NO;
        _prtrolTextView.delegate = self;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString
                                                        
                                                        alloc]initWithString:@"同意使用 《校安保APP使用与服务协议》"];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"protocol://"
                                 range:[[attributedString string] rangeOfString:@"《校安保APP使用与服务协议》"]];
         NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor],};
        [attributedString setAttributes:attributes range:NSMakeRange(0,4)];
        
        _prtrolTextView.attributedText = attributedString;
        _prtrolTextView.linkTextAttributes = @{ NSForegroundColorAttributeName:kColorWithRGB( 251, 175, 68, 1.0f),
                                                  NSUnderlineColorAttributeName: [UIColor clearColor],
                                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
 

        _isCheck = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isCheck setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateSelected];
        [_isCheck setImage:[UIImage imageNamed:@"duigou_no"] forState:UIControlStateNormal];
        [self.backScrollView addSubview:_isCheck];
        
        [_isCheck addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_isCheck setSelected:YES];
        //默认 为 YES
        _isCheckYesOrNo = YES;
        [_isCheck mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(_prtrolTextView.mas_centerY).offset(2);
            make.right.equalTo(_prtrolTextView.mas_left).offset(2);
            make.width.offset(17);
            make.height.offset(17);
        }];
        
        _isCheck.selected = YES;
    }
    return _prtrolTextView;
}

-(UITextField *)codeTF{
    
    if (!_codeTF) {
        
        _codeTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_codeTF];
        _codeTF.moveView = self.backScrollView;

        WS(weakSelf);
        
        [_codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.phoneTF.mas_bottom).offset(10);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
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
        [linePath addLineToPoint:CGPointMake(TFWIDTH+10,TFHEIGHT)];// 40+70+20+35+40 +
        
        CAShapeLayer *lineLayerOne = [CAShapeLayer layer];
        
        lineLayerOne.lineWidth = 0.3;
        lineLayerOne.strokeColor = [UIColor lightGrayColor].CGColor;
        lineLayerOne.path = linePath.CGPath;
        lineLayerOne.fillColor = nil; // 默认为blackColor
        [_codeTF.layer addSublayer:lineLayerOne];
        
    }
    return _codeTF;
}


-(UITextField *)rPasswordTF{
    
    if (!_rPasswordTF) {
        
        _rPasswordTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_rPasswordTF];
        _rPasswordTF.moveView = self.backScrollView;

        
        WS(weakSelf);
        
        [_rPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.passwordTF.mas_bottom).offset(10);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
        }];
        
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imagView.image = [UIImage imageNamed:@""];
        _rPasswordTF.leftView = imagView;
        _rPasswordTF.contentMode = UITextFieldViewModeAlways;
        _rPasswordTF.placeholder = @"请再次输入密码";
        
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
            
            make.top.equalTo(weakSelf.codeTF.mas_bottom).offset(10);
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


-(UITextField *)phoneTF{
    
    if (!_phoneTF) {
        
        _phoneTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_phoneTF];
        _phoneTF.moveView = self.backScrollView;

        
        WS(weakSelf);
        
        [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.nameTF.mas_bottom).offset(10);
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


-(UITextField *)nameTF{
    
    if (!_nameTF) {
        
        _nameTF =[[UITextField alloc] init];
        
        [self.backScrollView addSubview:_nameTF];
        _nameTF.moveView = self.backScrollView;

        
        WS(weakSelf);
        
        [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(SPACEING_register);
            make.width.offset(TFWIDTH);
            make.left.offset(LEFTSPACEING);
            make.height.offset(TFHEIGHT);
        }];
        
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imagView.image = [UIImage imageNamed:@""];
        _nameTF.leftView = imagView;
        _nameTF.contentMode = UITextFieldViewModeAlways;
        _nameTF.placeholder = @"请输入姓名";
        
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
        [self.nameTF.layer addSublayer:lineLayerOne];
        
    }
    return _nameTF;
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
        
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.backgroundColor = kColorWithRGB(156, 230, 189, 1.0f);
        [self.backScrollView addSubview:_imgView];

        WS(weakSelf);

        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.offset(SPACEING);
            make.centerX.equalTo(weakSelf.backScrollView);
            make.width.offset(3*IMAGE_HEIGHT);
            make.height.offset(IMAGE_HEIGHT);
            
        }];
    }
    return _imgView;
}
//初始化导航按钮
-(UIView *)navgationView
{
    if (!_navgationView) {
        
        _navgationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        [self.view addSubview:_navgationView];
        _navgationView = [_navgationView topBarWithTintColor:ThemeColor title:@"注册" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
