//
//  XABSchoolRequest.h
//  XAnBao
//
//  Created by Minlay on 17/4/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseDataRequest.h"

//菜单列表
@interface SchoolMenuList : BaseDataRequest

@end
//图文列表
@interface SchoolFeedList : BaseDataRequest

@end

//轮播图接口
@interface SchoolFoucsMap : BaseDataRequest

@end

//关注学校列表
@interface SchoolFollowList : BaseDataRequest

@end

//文章统计接口
@interface SchoolVisitLog : BaseDataRequest

@end

//获取留言老师
@interface SchoolMessageTeacher : BaseDataRequest

@end

//留言老师
@interface SchoolPostMessageTeacher : BaseDataRequest

@end

//搜索
@interface SchoolSearchListTeacher : BaseDataRequest

@end

//判断是否可以进入内网
@interface SchoolEnterIntranetJudgeTeacher : BaseDataRequest

@end

//添加关注
@interface SchoolAddFollow : BaseDataRequest

@end

//取消关注
@interface SchoolCancelFollow : BaseDataRequest

@end

//添加关注
@interface SchoolDefaultFollow : BaseDataRequest

@end

//内网公告
@interface SchoolIntranetNotice : BaseDataRequest

@end

//发布内网公告
@interface SchoolPostIntranetNotice : BaseDataRequest

@end

//获取学校教师组
@interface SchoolGetTeacherGroup : BaseDataRequest

@end

//获取学校教师列表
@interface SchoolGetTeacherList : BaseDataRequest

@end

//新建老师组
@interface SchoolNewGroupRequest : BaseDataRequest

@end
