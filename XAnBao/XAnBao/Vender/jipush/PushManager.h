//
//  PushManager.h
//  新版微经分
//
//  Created by 王伟 on 2017/3/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushManager : NSObject
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) BOOL isPresent;
+ (PushManager *)shareManager;

@end
