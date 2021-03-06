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

//获取七牛域名token
@interface GetQiNiuTokenAndDomin : BaseDataRequest

@end

//搜索老师
@interface ClassSearchTeacher : BaseDataRequest

@end

//搜索学生
@interface ClassSearchStudent : BaseDataRequest

@end

//学生详情
@interface ClassStudentDetail : BaseDataRequest

@end

//关注学生
@interface ClassFollowStudent : BaseDataRequest

@end

//取消关注学生
@interface ClassCancelFollowStudent : BaseDataRequest

@end

//获取老师科目
@interface ClassGetSubjectRequest : BaseDataRequest

@end

//获取老师科目
@interface ClassPostHomeworkRequest : BaseDataRequest

@end

//家长确认
@interface ClassReceivedNoticeRequest : BaseDataRequest

@end

//家长确认
@interface ClassFoucsMapRequest : BaseDataRequest

@end

//统计班级
@interface ClassStatisReceivedRequest : BaseDataRequest

@end

//查看统计
@interface ClassCatStatisRequest : BaseDataRequest

@end

//作业班级列表
@interface HomeworkClassListRequest : BaseDataRequest

@end

//作业学生列表完成情况
@interface HomeworkStudentListRequest : BaseDataRequest

@end

//作业列表
@interface HomeworkListRequest : BaseDataRequest

@end

//所有科目
@interface HomeworkClassAllSubjectRequest : BaseDataRequest

@end

//获取日历完成情况
@interface HomeworkGetResultRequest : BaseDataRequest

@end

//家长标记完成
@interface HomeworkFinishRequest : BaseDataRequest

@end

//家长添加附件
@interface HomeworkAddEnclosureRequest : BaseDataRequest

@end
