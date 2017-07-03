//
//  StatusTaskView.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusTaskCell.h"

@protocol StatusTaskViewDelegate <NSObject>

- (void)statusTaskViewCheckLink:(NSArray *)fileArray;
- (void)statusTaskViewTaskContent:(NSString *)content;

@end
@interface StatusTaskView : UITableView

- (void)refreshStatusaskList:(NSDictionary *)parameters urlString:(NSString *)string isTeacher:(BOOL)isTeacher;

@property (weak, nonatomic) id <StatusTaskViewDelegate> statusDelegate;
@property(nonatomic, copy)NSString *studentId;
@end
