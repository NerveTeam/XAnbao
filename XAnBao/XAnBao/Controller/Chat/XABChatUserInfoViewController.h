//
//  XABChatUserInfoViewController.h
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XABParamModel.h"
@interface XABChatUserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *keMuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zuoJiLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobliePhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (nonatomic,strong) XABChatSchoolGroupMembersModel *model;

@end
