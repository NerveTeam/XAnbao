//
//  BaseModel.h
//  YueBallSport
//
//  Created by Minlay on 16/11/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "DataRequest.h"
#import "NSDictionary+Safe.h"
typedef void(^Success)(NSArray *dataList);
typedef void(^Error)();
@interface BaseModel : NSObject

@end
