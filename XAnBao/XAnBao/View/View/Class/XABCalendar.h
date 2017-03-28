//
//  XABCalendar.h
//  XAnBao
//
//  Created by Minlay on 17/3/16.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XABCalendarDelegate <NSObject>
- (void)calendarSelectDate:(NSDate *)date;

@end
@interface XABCalendar : UIView
@property(nonatomic, weak)id<XABCalendarDelegate> delegate;
@end
