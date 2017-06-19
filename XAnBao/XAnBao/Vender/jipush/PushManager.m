//
//  PushManager.m
//  新版微经分
//
//  Created by 王伟 on 2017/3/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "PushManager.h"

@implementation PushManager

+ (PushManager *)shareManager {
    static PushManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PushManager alloc]init];
        manager.hasLogin = NO;
        manager.isPresent = NO;
    });
    return manager;
}
@end
