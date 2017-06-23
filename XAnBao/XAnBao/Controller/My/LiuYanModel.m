//
//  LiuYanModel.m
//  XAnBao
//
//  Created by wyy on 17/6/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "LiuYanModel.h"

@implementation LiuYanModel
- (id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self)
    {
        self.content=[dic objectForKey:@"content"];
        self.id=[dic objectForKey:@"id"];
        self.teacherName=[dic objectForKey:@"teacherName"];
    }
    return self;
}
@end
