//
//  XABChatStorage.h
//  XAnBao
//
//  Created by 韩森 on 2017/5/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XABChatStorage : NSObject

+ (XABChatStorage *)shareInstance;

+ (void)setRCToken:(NSString *)rctoken;
+ (NSString *)getRCtoken;

+ (void)setRCFriends:(NSArray *)arr;
+ (NSArray *)getRCFriends;

+ (void)setRCGroups:(NSArray *)arr;
+ (NSArray *)getRCGroups;

@end
