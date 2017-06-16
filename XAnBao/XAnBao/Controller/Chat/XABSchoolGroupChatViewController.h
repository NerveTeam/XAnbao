//
//  XABSchoolGroupChatViewController.h
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface XABSchoolGroupChatViewController : RCConversationViewController

@property (nonatomic,copy) NSString *groupName;
@property (strong, nonatomic) NSString *senderGroupId;
@property (assign, nonatomic) BOOL isMember;

@end
