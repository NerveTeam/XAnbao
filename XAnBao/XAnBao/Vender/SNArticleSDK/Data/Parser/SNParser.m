//
//  SNParser.m
//  SNArticleDemo
//
//  Created by Boris on 15/12/28.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "SNParser.h"

@implementation SNParser

- (NSDictionary *)parseBaseDataWithDict:(NSDictionary *)dict
{
    NSDictionary * data = nil;
    
    if ( dict == nil
        || ![dict isKindOfClass:[NSDictionary class]]
        || status_success != [[dict objectForKeySafely:@"status"] intValue] )
    {
        self.hasError = YES;
        
        if ( [dict isKindOfClass:[NSDictionary class]] )
        {
            id tempData = [dict objectForKeySafely:@"data"];
            if ( [tempData isKindOfClass:[NSDictionary class]] )
            {
                // 进一步处理失败
                NSString * errorCode = SNString([tempData objectForKeySafely:@"errorCode"],@"");
                if (errorCode && [errorCode intValue] > 0)
                {
                    self.errorCode = [errorCode intValue];
                    self.errorMessage = SNString([tempData objectForKeySafely:@"message"],@"");
                    
                    // TODO
                    data = tempData;
                }
            }
        }
    }
    else
    {
        id tempData = [dict objectForKeySafely:@"data"];
        if ( [tempData isKindOfClass:[NSDictionary class]] )
        {
            data = tempData;
        }
        else
        {
            self.hasError = YES;
        }
    }
    return data;
}

@end
