//
//  XABChatStorage.m
//  XAnBao
//
//  Created by 韩森 on 2017/5/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatStorage.h"

@implementation XABChatStorage

+ (XABChatStorage *)shareInstance{
    static XABChatStorage *resource = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == resource) {
            resource = [[XABChatStorage alloc]init];
        }
    });
    return resource;
    
}

+ (void)setRCToken:(NSString *)rctoken
{
    [[NSUserDefaults standardUserDefaults] setObject:rctoken forKey:@"rctoken"];
}

+ (NSString *)getRCtoken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"rctoken"];
}


+ (void)setRCFriends:(NSArray *)arr {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    if (!arr.count) {
        data = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_friends_list"];
}
+ (NSArray *)getRCFriends {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_friends_list"];
    if (data == nil) {
        return nil;
    }
    
    NSArray *arrFriends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return arrFriends;
}


+ (void)setRCGroups:(NSArray *)arr {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    if (!arr.count) {
        data = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_groups_list"];
    
}
+ (NSArray *)getRCGroups {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_groups_list"];
    if (data == nil) {
        return nil;
    }
    NSArray *arrGroups = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return arrGroups;
}

@end
