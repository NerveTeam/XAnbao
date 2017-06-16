//
//  XABChatRequest.h
//  XAnBao
//
//  Created by 韩森 on 2017/5/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseDataRequest.h"

//校内群讨论群列表接口
@interface XABChatSchoolGroupRequest : BaseDataRequest

@end

//校内群 融云组 用户
@interface XABChatSchoolGroupMembersRequest : BaseDataRequest

@end

//班级群接口列表接口
@interface XABChatClassGroupRequest : BaseDataRequest

@end



#pragma mark - 课程表

@interface XABClassGradeCurriculumRequest : BaseDataRequest

@end
