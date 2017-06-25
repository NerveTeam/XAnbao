//
//  LiuYanModel.h
//  XAnBao
//
//  Created by wyy on 17/6/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiuYanModel : NSObject
- (id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *teacherName;
@property(nonatomic,copy)NSString *id;

@end
