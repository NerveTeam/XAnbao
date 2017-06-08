//
//  XABNewGroupViewController.h
//  XAnBao
//
//  Created by Minlay on 17/5/25.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBBaseViewController.h"
#define NewGroupDidFinish @"NewGroupDidFinish"
@interface XABNewGroupViewController : YBBaseViewController
@property(nonatomic, copy)NSString *schoolId;
@property(nonatomic, copy)NSString *classId;
@property(nonatomic, assign)BOOL isScholl;
@property(nonatomic, strong)NSArray *memberList;
@end
