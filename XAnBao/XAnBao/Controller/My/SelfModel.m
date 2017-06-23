//
//  SelfModel.m
//  XAnBao
//
//  Created by wyy on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "SelfModel.h"

@implementation SelfModel
- (id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self)
    {
        self.name=[dic objectForKey:@"name"];
        self.username=[dic objectForKey:@"username"];
        self.sex=[dic objectForKey:@"sex"];
        self.portrit=[dic objectForKey:@"portrit"];
    }
    return self;
}
@end
