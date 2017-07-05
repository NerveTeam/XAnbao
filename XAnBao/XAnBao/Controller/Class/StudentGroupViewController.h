//
//  StudentGroupViewController.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/9.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudentGroupViewDelegate <NSObject>

// 新建学生名单分组
- (void)studentGroupViewGreatNewGroup;
// 选择组别
- (void)studentGroupViewChooseGroupAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface StudentGroupViewController : UIViewController

- (void)show:(NSArray *)studentGroup;

@property (weak, nonatomic) id <StudentGroupViewDelegate> studentGroupDelegate;

@end
