//
//  XABClassContentView.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassContentView.h"
#import "XABClassItem.h"
#import "NSArray+Safe.h"
#import "XABUserLogin.h"

@interface XABClassContentView ()
@property(nonatomic,strong)NSArray *data;
@property(nonatomic, assign)BOOL isTeacher;
@end
@implementation XABClassContentView
static int number = 3;

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)click:(XABClassItem*)sender {
    if ([_delegate respondsToSelector:@selector(clickItemWithClass:)]) {
        [_delegate clickItemWithClass:[[self.data safeObjectAtIndex:sender.tag] objectForKey:@"class"]];
    }
}

- (void)reloadItem:(NSNotification *)noti {
    self.isTeacher = [[noti.userInfo objectForKeySafely:@"isTeacher"] boolValue];
    [self removeAllSubviews];
    [self setup];
}


- (void)setup {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadItem:) name:@"ClassChangeRole" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadItem:) name:UserLoginSuccess object:nil];
    [self initData];
    
    self.backgroundColor = RGBCOLOR(225, 225, 235);
    CGFloat marginW = 10;
    CGFloat marginH = 15;
    CGFloat itemMargin = 5;
    CGFloat itemWidth = (SCREEN_WIDTH - (2*marginW) - (number - 1)*itemMargin)/number;
    CGFloat itemHeight = 80;
    for (int i = 0; i < self.data.count; i++) {
        NSInteger col = i % number;
        NSInteger row = i / number;
        NSString *intro = [[self.data safeObjectAtIndex:i]objectForKey:@"intro"];
        NSString *img = [[self.data safeObjectAtIndex:i]objectForKey:@"img"];
        XABClassItem *item = [XABClassItem buttonWithIntro:intro image:img];
        [item addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        item.frame = CGRectMake(marginW + col * (itemWidth + itemMargin), marginH + row *(itemHeight + itemMargin), itemWidth, itemHeight);
        item.tag = i;
    }
}

- (void)initData {
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@{@"intro":@"班级成员",@"img":@"myClass_member",@"class":@"XABClassMemberViewController"}];
    [items addObject:@{@"intro":@"班级通知",@"img":@"myClass_class_notice",@"class":@"XABClassNoticeViewController"}];
    
    if (self.isTeacher) {
        [items addObject:@{@"intro":@"留作业",@"img":@"myClass_job",@"class":@"XABHomeworkViewController"}];
        [items addObject:@{@"intro":@"检查作业",@"img":@"myClass_job",@"class":@"XABCheckJobViewController"}];
    }else {
        [items addObject:@{@"intro":@"今日学业",@"img":@"myClass_job",@"class":@"XABCheckJobViewController"}];
    }
    [items addObjectsFromArray:@[@{@"intro":@"课程表",@"img":@"myClass_schedule",@"class":@"XABClassScheduleViewController"},
                                 @{@"intro":@"班级文件",@"img":@"myClass_class_file",@"class":@"XABClassFileViewController"},
//                                 @{@"intro":@"我的好友",@"img":@"myClass_friends",@"class":@"XABClassFriendsViewController"},
                                 @{@"intro":@"班级讨论",@"img":@"myClass_discussion",@"class":@"XABClassChatViewController"}]];
    self.data = items.copy;
}

@end
