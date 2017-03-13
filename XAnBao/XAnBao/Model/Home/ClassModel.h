//
//  ClassModel.h
//  XAB
//
//  Created by wyy on 17/3/10.
//  Copyright © 2017年 王园园. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
- (id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *school;
@end
