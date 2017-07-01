//
//  CurriculumTableView.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurriculumTableViewDelegate <NSObject>
// 定义协议
- (void)curriculumTableViewSelectedRowAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)senderID withName:(NSString *)senderName;
@optional
- (void)curriculumTableViewBackStudentList:(NSArray *)senderArr withStudentId:(NSString *)senderId;
@end

@interface CurriculumTableView : UITableView 

- (void)setDefaultSelected;

@property (strong, nonatomic) NSArray *datalist;

- (void)refreshCurriculumList:(NSDictionary *)parameters urlString:(NSString *)string isUp:(BOOL)isUp;
//定义代理
@property (weak, nonatomic) id<CurriculumTableViewDelegate> curriculumDelegate;


@end
