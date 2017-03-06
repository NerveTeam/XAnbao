//
//  DataRequest.h
//  MLTools
//
//  Created by Minlay on 16/9/23.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataRequest.h"

@interface TestRequest : BaseDataRequest

@end
@interface NewsSportListRequest : BaseDataRequest

@end

@interface HotNewsSportListRequest : BaseDataRequest

@end

@interface HotNewsFoucsRequest : BaseDataRequest

@end

@interface ReplayCommentRequest : BaseDataRequest

@end

@interface ThirdLoginRequest : BaseDataRequest

@end

@interface PlatformLoginRequest : BaseDataRequest

@end

@interface PlatformRegisterRequest : BaseDataRequest

@end

@interface ModifyPasswordRequest : BaseDataRequest

@end

@interface UserRegisterStatusRequest : BaseDataRequest

@end

//获取好友列表
@interface FriendListRequest : BaseDataRequest

@end

//查询用户->添加好友->删除好友
@interface AddFriendRequest : BaseDataRequest

@end
//创建群聊把群聊ID加入数据库
@interface AddChatIdRequest : BaseDataRequest

@end
//获取群聊详情(群聊好友列表)
@interface ChatGroupDetailRequest : BaseDataRequest

@end
// 新闻评论列表页
@interface NewsCommentList : BaseDataRequest

@end
