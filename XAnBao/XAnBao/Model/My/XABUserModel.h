//
//  XABUserModel.h
//  XAnBao
//
//  Created by 韩森 on 2017/3/12.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseModel.h"

@interface XABUserModel : BaseModel

@property(nonatomic, copy) NSString      *name;
@property(nonatomic, assign) NSInteger    uid;
@property(nonatomic, copy) NSString      *token;
@property(nonatomic, copy) NSString      *icon;
@property(nonatomic, assign)NSInteger     classId;
@property(nonatomic, assign)NSInteger     sex;
@property(nonatomic, copy) NSString       *personality;

@end
