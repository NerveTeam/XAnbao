//
//  XABChatUserInfoViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatUserInfoViewController.h"
#import "UIImageView+WebCache.h"
@interface XABChatUserInfoViewController ()

@end

@implementation XABChatUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详细信息";
    self.nameLabel.text = self.model.name;
    self.mobliePhoneLabel.text = self.model.mobilePhone;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrit] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
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
