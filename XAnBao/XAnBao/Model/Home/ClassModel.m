//
//  ClassModel.m
//  XAB
//
//  Created by wyy on 17/3/10.
//  Copyright © 2017年 王园园. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
- (id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self)
    {
        self.name=[dic objectForKey:@"name"];
        self.type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        self.school=[dic objectForKey:@"school"];
    }
    return self;
}
@end
