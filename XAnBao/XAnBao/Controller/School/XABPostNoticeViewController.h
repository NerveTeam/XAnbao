//
//  XABPostNoticeViewController.h
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBBaseViewController.h"

typedef NS_ENUM(NSUInteger, NoticeType) {
    NoticeTypeClass,
    NoticeTypeSchool,
};
@interface XABPostNoticeViewController : YBBaseViewController
@property(nonatomic, copy)NSString *schoolId;
@property(nonatomic, copy)NSString *classId;
@property(nonatomic, assign)NoticeType noticeType;
@end
