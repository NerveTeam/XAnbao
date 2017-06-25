//
//  SelfModel.h
//  XAnBao
//
//  Created by wyy on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelfModel : NSObject
- (id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *portrit;


@end
