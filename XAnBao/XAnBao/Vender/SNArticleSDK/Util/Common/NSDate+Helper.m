//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSDate+Helper.h"
#include <pthread.h>
#import "SNCommonSystemConstant.h"
#import <UIKit/UIKit.h>

static NSCalendar *calendar;
static NSDateFormatter *displayFormatter;
static NSDateFormatter *newsDateFormatter;
static NSDateFormatter *dataFromatter;
static NSDateFormatter *dateAndTimeFromatter;
static NSDateFormatter *timeStampNoSecFormatter;

//互斥锁
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

@implementation NSDate (Helper)

//+ (void)load {
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    calendar = [[NSCalendar currentCalendar] retain];
//    displayFormatter = [[NSDateFormatter alloc] init];
//    
//	[pool drain];
//}

- (NSInteger)getDaysByStartDate:(NSDate *)start endDate:(NSDate *)end
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger days = [calendar daysWithinEraFromDate:start toDate:end];
    
    [calendar release];
    return days;
}
/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];
	
	return (long)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%lu days ago", (unsigned long)daysAgo];
	}
	return text;
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSDate *)dateFromStringNoSec:(NSString *)string
{
    if (nil == timeStampNoSecFormatter )
    {
        timeStampNoSecFormatter = [[NSDateFormatter alloc] init];
        [timeStampNoSecFormatter setDateFormat:[NSDate timestampWithoutSecondFormatString]];
    }
    NSDate *date = [timeStampNoSecFormatter dateFromString:string];
	return date;
}

+ (NSDate *)dateFromTimestamp:(NSNumber *)timestamp
{
    if ([timestamp isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    }
    if ([timestamp isKindOfClass:[NSString class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    }
    return nil;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime
{
    /* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
		if ([date compare:lastweek] == NSOrderedDescending) {
            if (displayTime)
                [displayFormatter setDateFormat:@"EEEE h:mm a"]; // Tuesday
            else
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];			
			if (thatYear >= thisYear) {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d"];
			} else {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    // preserve prior behavior
	return [self stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	} 
	
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	[componentsToSubtract release];
	
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	[componentsToAdd release];
	
	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)timestampWithoutSecondFormatString
{
    return @"yyyy-MM-dd HH:mm";
}

+(NSString*)dateAndtimesFormatString
{
     return @"MM-dd HH:mm";
}
// preserving for compatibility
+ (NSString *)dbFormatString {	
	return [NSDate timestampFormatString];
}

- (NSDateComponents *)dateComponents
{   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    return components;
}

- (BOOL)isTheSameDayCompareWithDate:(NSDate *)date
{
    NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:date options:0];
    [calendar release];
	return [components day] == 0;
}

- (NSString *)day
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
    df.locale = loc;
    [loc release];
    df.dateFormat = @"dd";
    return [df stringFromDate:self];
}

- (NSString *)month
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
    df.locale = loc;
    [loc release];
    df.dateFormat = @"mm";
    return [df stringFromDate:self];
}

- (NSString *)week
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
    df.locale = loc;
    [loc release];
    df.dateFormat = @"EEEE";
    return [df stringFromDate:self];
}

- (NSString *)year
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
    df.locale = loc;
    [loc release];
    df.dateFormat = @"yyyy";
    return [df stringFromDate:self];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;

    NSDateComponents *components = [calendar components:unitFlags fromDate:self];

    NSInteger hour = [components hour];
    
    return hour;
    
}

- (NSString *)stringWithNewsDateFormat
{
    NSString * str = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        newsDateFormatter = [[NSDateFormatter alloc] init];
    });
    
    //iOS6以及以下才需要加锁保证线程安全
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(IOS_6_0))
    {
        //加锁
        pthread_mutex_lock(&mutex);
    }
    
    [newsDateFormatter setDateFormat:@"MM-dd HH:mm"];
    str = [newsDateFormatter stringFromDate:self];
    
    //iOS6以及以下才需要加锁保证线程安全
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(IOS_6_0))
    {
        //解锁
        pthread_mutex_unlock(&mutex);
    }
    
	return str;
}

- (NSString *)stringWithDateFormat
{
    NSString * str = nil;
    if ( nil == dataFromatter )
    {
        dataFromatter = [[NSDateFormatter alloc] init];
       
    }
    [dataFromatter setDateFormat:[NSDate dateFormatString]];
    str = [dataFromatter stringFromDate:self];
	return str;
}

-(NSString *)stringWithDateAndTime
{
    NSString * str = nil;
    if ( nil == dateAndTimeFromatter )
    {
        dateAndTimeFromatter = [[NSDateFormatter alloc] init];
    }
    [dateAndTimeFromatter setDateFormat:[NSDate dateAndtimesFormatString]];
    str = [dateAndTimeFromatter stringFromDate:self];
	return str;
}

- (NSString *)stringWithTimeStampNoSecFormat
{
    NSString * str = nil;
    if ( nil == timeStampNoSecFormatter )
    {
        timeStampNoSecFormatter = [[NSDateFormatter alloc] init];
        [timeStampNoSecFormatter setDateFormat:[NSDate timestampWithoutSecondFormatString]];
    }
    str = [timeStampNoSecFormatter stringFromDate:self];
	return str;
}

- (NSString *)commentDateString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];

    [calendar release];
    
    NSString *formattedString = nil;
    if ([nowComponents year] == [dateComponents year] &&
        [nowComponents month] == [dateComponents month] &&
        [nowComponents day] == [dateComponents day])				// 今天.
    {
        
        int diff = [self timeIntervalSinceNow];
        
        if (diff <= 0 && diff > -60 * 60)							// 一小时之内.
        {
            int min = -diff / 60;
            
            if (min == 0)
            {
                min = 1;
            }
            
            formattedString = [NSString stringWithFormat:@"%d分钟前", min];
        }
        else if (diff > 0)
        {
            formattedString = [NSString stringWithFormat:@"%d分钟前", 1];
        }
        else
        {
            [dateFormatter setDateFormat:@"'今天 'HH:mm"];
            
            formattedString = [dateFormatter stringFromDate:self];
        }
    }
    else
    {
        NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:mainlandChinaLocale];
        [mainlandChinaLocale release];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
        
        formattedString = [dateFormatter stringFromDate:self];
    }
    
    [dateFormatter release];
    
    return formattedString;
}

+ (NSDate *)systemTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
}

-(NSString*)stringFromDateToSubscribe
{
	time_t pubdate = [self timeIntervalSince1970];
	struct tm* pubDate = localtime((const time_t*)&pubdate);
	struct tm stPubDate = *pubDate;
	
	int yearOfPubDate = pubDate->tm_year + 1900;
	int monOfPubDate = pubDate->tm_mon + 1;
	int dayOfPubDate = pubDate->tm_mday;
    
    time_t now = time(0);
	struct tm* today = localtime((const time_t*)&now);
	int yearOfToday = today->tm_year + 1900;
	long times = now - pubdate;
	
	NSString* s = nil;
	if (times < 60 * 60)
	{
		s = [NSString stringWithFormat:@"%@", @"刚刚"];
	}
	else if (times >= 60 * 60 && times < 60 * 60 * 24)
	{
        s = [NSString stringWithFormat:@"%ld小时前", times / (60 * 60)];
	}
	else if (times >= 60 * 60 * 24)
	{
        if (yearOfToday != yearOfPubDate)
		{
            s = [NSString stringWithFormat:@"%d年%d月%d日", yearOfPubDate, monOfPubDate, dayOfPubDate];
        }else
        {
            s = [NSString stringWithFormat:@"%d月%d日", stPubDate.tm_mon + 1,stPubDate.tm_mday];
        }
    }
	return s;
}


@end

@implementation NSCalendar (MySpecialCalculations)

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{
    NSInteger startDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                       inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                     inUnit: NSEraCalendarUnit forDate:endDate];
    return endDay-startDay;
}


@end
