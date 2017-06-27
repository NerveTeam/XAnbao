//
//  XABClassChatViewController.h
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@interface XABClassChatViewController : RCConversationViewController
@property(nonatomic, copy)NSString *classId;
@property(nonatomic, copy)NSString *className;
@property(nonatomic, assign)NSInteger type;

@end
