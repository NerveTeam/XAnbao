//
//  SchoolNewsModel.m
//  XAB
//
//  Created by wyy on 17/3/9.
//  Copyright © 2017年 王园园. All rights reserved.
//

#import "SchoolNewsAndArticleModel.h"

@implementation SchoolNewsAndArticleModel

- (id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self)
    {
        self.title=[dic objectForKey:@"title"];
        self.showtime=[dic objectForKey:@"showtime"];
        self.url=[dic objectForKey:@"url"];
        self.thumbnail=[dic objectForKey:@"thumbnail"];
     
    }
    return self;
}
@end
