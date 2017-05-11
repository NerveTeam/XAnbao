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
