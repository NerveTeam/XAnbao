//
//  XABCalendar.h
//  XAnBao
//
//  Created by Minlay on 17/3/16.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XABCalendarDelegate <NSObject>
- (void)calendarSelectDate:(NSString *)date;

@end
@interface XABCalendar : UIView
@property(nonatomic, weak)id<XABCalendarDelegate> delegate;
@property(nonatomic, strong)NSDate *currenDate;
@property(nonatomic, copy)NSString *subjectId;
@property(nonatomic, copy)NSString *studentId;
- (void)realod;
@end
