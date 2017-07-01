//
//  XABCalendar.m
//  XAnBao
//
//  Created by Minlay on 17/3/16.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABCalendar.h"
#import "FSCalendar.h"


@interface XABCalendar ()
<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (strong, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) UIButton *previousButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;
@end
@implementation XABCalendar

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    [self addSubview:self.calendar];
    [self addSubview:self.previousButton];
    [self addSubview:self.nextButton];
    self.currenDate = self.calendar.today;
}


- (void)previousClicked
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy/MM/dd";
    NSString *key = [dateFormatter1 stringFromDate:date];
    if ([key isEqualToString:@"2017/04/16"]) {
        return [UIColor redColor];
    }
    return nil;
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.currenDate = date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateformatter stringFromDate:date];
    if ([_delegate respondsToSelector:@selector(calendarSelectDate:)]) {
        [_delegate calendarSelectDate:dateStr];
    }
}


- (FSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _calendar.appearance.todayColor = [UIColor greenColor];
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    }
    return _calendar;
}


- (UIButton *)previousButton {
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousButton.frame = CGRectMake(0, 5, 95, 34);
        _previousButton.backgroundColor = [UIColor whiteColor];
        _previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_previousButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previousClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _previousButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(CGRectGetWidth(self.frame)-95, 5, 95, 34);
        _nextButton.backgroundColor = [UIColor whiteColor];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _nextButton;
}
@end
