//
//  XABSchoolGroupMembersViewController.h
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XABSchoolGroupMembersViewController : UIViewController

@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,strong) NSString *isJumpDetailVC;// 为 0的 时候  不需要调整到详情
@end
