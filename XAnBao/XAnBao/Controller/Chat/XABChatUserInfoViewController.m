//
//  XABChatUserInfoViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatUserInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
@interface XABChatUserInfoViewController ()
@property (nonatomic,strong) UIView *topBarView;
@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation XABChatUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, StatusBarHeight+10, 200, 30)];
    titleLabel.text = @"详细信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topBarView addSubview:titleLabel];
    
    self.nameLabel.text = self.model.name;
    self.mobliePhoneLabel.text = self.model.mobilePhone;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrit] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
        _topBarView.backgroundColor = ThemeColor;
        
        [self.view addSubview:_topBarView];
    }
    return _topBarView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
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
