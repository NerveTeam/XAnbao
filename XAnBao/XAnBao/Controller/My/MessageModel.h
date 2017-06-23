//
//  MessageModel.h
//  XAnBao
//
//  Created by wyy on 17/6/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
- (id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *alert;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *noticeid;
@property(nonatomic,copy)NSString *jiazhangid;

@end
