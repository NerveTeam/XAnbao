//
//  XABClassMembersDetailnfoVC.h
//  XAnBao
//
//  Created by 韩森 on 2017/6/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XABClassMembersDetailnfoVC : UIViewController

@property (nonatomic,copy) NSString *isTeacherOrParent; //点进去的是 教师详情还是家长详情 1  是teacher  0是 parent
@property (nonatomic,copy) NSString *id;
@property(nonatomic, assign)NSInteger type;//判断当前是身份 教师还是家长   1  是家长 2是 教师

@end
