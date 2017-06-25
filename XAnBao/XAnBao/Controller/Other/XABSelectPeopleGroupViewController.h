//
//  XABSelectPeopleGroupViewController.h
//  XAnBao
//
//  Created by Minlay on 17/5/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBBaseViewController.h"
#define KSelectGroupListDidFinish @"KSelectGroupListDidFinish"
@interface XABSelectPeopleGroupViewController : YBBaseViewController
@property(nonatomic, copy)NSString *schoolId;
@property(nonatomic, copy)NSString *classId;
@property(nonatomic, assign)BOOL isScholl;
@property(nonatomic, strong)NSDictionary *selectedInfo;
@end
