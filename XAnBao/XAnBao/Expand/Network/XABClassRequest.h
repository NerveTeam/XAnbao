//
//  XABClassRequest.h
//  XAnBao
//
//  Created by Minlay on 17/5/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseDataRequest.h"
// 班级关注列表
@interface ClassFollowList : BaseDataRequest

@end
// 班级通知
@interface ClassNoticeList : BaseDataRequest

@end

// 班级发送通知
@interface ClassPostNotice : BaseDataRequest

@end

// 获取班级组
@interface ClassGetStudentGroup : BaseDataRequest

@end

//获取班级学生列表
@interface ClassGetStudentList : BaseDataRequest

@end

//新建学生组
@interface ClassNewGroupRequest : BaseDataRequest

@end
