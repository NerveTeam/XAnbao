//
//  SchoolNewsModel.h
//  XAB
//
//  Created by wyy on 17/3/9.
//  Copyright © 2017年 王园园. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolNewsAndArticleModel : NSObject
- (id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *showtime;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *thumbnail;
@property(nonatomic,copy)NSString *school;
@end
