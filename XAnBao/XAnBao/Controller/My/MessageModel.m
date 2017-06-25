//
//  MessageModel.m
//  XAnBao
//
//  Created by wyy on 17/6/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
- (id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self)
    {
        self.alert=[dic objectForKey:@"alert"];
        self.url=[dic objectForKey:@"url"];
         self.type=[dic objectForKey:@"type"];
         self.noticeid=[dic objectForKey:@"noticeid"];
        self.jiazhangid=[dic objectForKey:@"jiazhangid"];
        
            }
    return self;
}
@end
