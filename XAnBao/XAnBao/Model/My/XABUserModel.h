//
//  XABUserModel.h
//  XAnBao
//
//  Created by 韩森 on 2017/3/12.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseModel.h"

@interface XABUserModel : BaseModel
//用户ID
@property(nonatomic, copy) NSString      *id;
//登录名（手机号）
@property(nonatomic, copy) NSString      *username;
//
@property(nonatomic, copy) NSString      *token;
//用户姓名
@property(nonatomic, copy) NSString      *name;
//手机号
@property(nonatomic, copy)NSString       *mobile;
//默认关注学校ID
@property(nonatomic, copy) NSString      *defaultFocusSchoolId;


@end
