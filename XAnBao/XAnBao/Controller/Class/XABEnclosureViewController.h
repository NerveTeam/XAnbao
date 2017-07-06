//
//  XABEnclosureViewController.h
//  XAnBao
//
//  Created by Minlay on 17/3/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBBaseViewController.h"
#define AddEnclosureDidFinish @"AddEnclosureDidFinish"
@interface XABEnclosureViewController : YBBaseViewController
@property(nonatomic, copy)NSString *classId;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, strong)NSArray *attachments;
@property(nonatomic, copy)NSString *className;
@end
