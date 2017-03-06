//
//  SNGlobalUtil.m
//  SinaNews
//
//  Created by frost on 14-3-13.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SNCommonGlobalUtil.h"
#import "SNCommonMacro.h"
#import <CoreLocation/CoreLocation.h>
@implementation SNCommonGlobalUtil

+ (NSString*) trimString:(NSString*)str
{
    if (!str)
        return nil;
    
    NSMutableString* mstring = [NSMutableString stringWithString:str];
    CFStringTrimWhitespace((CFMutableStringRef)mstring);
    return [mstring copy];
}

+ (BOOL)isSinaDomainH5:(NSString*)url
{
    BOOL isSinaDomainH5 = NO;
    if (CHECK_VALID_STRING(url))
    {
        if ( ([url rangeOfString:@"sina.cn"].location != NSNotFound) ||
             ([url rangeOfString:@"sina.com.cn"].location != NSNotFound) ||
             ([url rangeOfString:@"weibo.cn"].location != NSNotFound) ||
             ([url rangeOfString:@"weibo.com"].location != NSNotFound) )
        {
            isSinaDomainH5 = YES;
        }
    }
    return isSinaDomainH5;
}

+ (NSString*)getResolution
{
    static NSString *resolutionString = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        float scale = [[UIScreen mainScreen] scale];
        CGSize size = rect.size;
        int width = (int)size.width*scale;
        int height = (int)size.height*scale;
        resolutionString = [NSString stringWithFormat:@"%dx%d",width,height];
    });

    return resolutionString;
}

+ (BOOL)hasRect:(CGRect)rect
{
    return !CGRectEqualToRect(rect, CGRectZero) && !CGRectIsNull(rect) && !CGRectIsEmpty(rect);
}

+ (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}

+ (BOOL)isAllocLocal
{
    if(![CLLocationManager locationServicesEnabled]){
        //NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
        return NO;
    }else{
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            //NSLog(@"定位失败，请开启定位:设置 > 隐私 > 位置 > 定位服务 下 XX应用");
            return NO;
        }
    }
    return YES;
}
/*
 *返回当前时间。可以通过[comps year]获得当前年份。[comps hour]当前小时。以此类推。
 */
+ (NSDateComponents *)currentDateComponents
{
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    return comps;
}

@end

NSNumber* SNNumber(id obj, NSNumber *defaultValue)
{
    if ([obj isKindOfClass:[NSNumber class]])
        return obj;
    
    return defaultValue;
}

NSDictionary* SNDictionary(id obj, NSDictionary* defaultValue)
{
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        return obj;
    }
    
    return defaultValue;
}

NSArray* SNArray(id obj, NSArray* defaultValue)
{
    if ([obj isKindOfClass:[NSArray class]])
    {
        return obj;
    }
    
    return defaultValue;
}

int SNInt(id obj, int defaultValue)
{
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj intValue];
    
    return defaultValue;
}

NSInteger SNInteger(id obj, NSInteger defaultValue)
{
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj integerValue];
    
    return defaultValue;
}

double SNDouble(id obj, double defaultValue)
{
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj doubleValue];
    
    return defaultValue;
}

float SNFloat(id obj, float defaultValue)
{
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj floatValue];
    
    return defaultValue;
}

BOOL SNBool(id obj, BOOL defaultValue)
{
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj boolValue];
    
    return defaultValue;
}

NSString * SNString(NSString * value, NSString * defaultString)
{
    if (CHECK_VALID_STRING(value))
        return value;
    
    if (defaultString && ![defaultString isKindOfClass:[NSString class]])
    {
        defaultString = @"";
    }
    
    return defaultString;
}


///-----------------------------------------------------------------------------
@implementation SNWeakObject

- (instancetype)initWithObject:(id)obj
{
    self = [super init];
    if (self)
    {
        _object = obj;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[SNWeakObject class]]) return NO;
    
    SNWeakObject *weakObject = object;
    return (weakObject.object == self.object || [weakObject.object isEqual:self.object]);
}

- (NSUInteger)hash
{
    return [self.object hash];
}
@end

///-----------------------------------------------------------------------------
@implementation UIGestureRecognizer (SNUtils)

- (void)cancelGesture
{
    if (self.enabled)
    {
        //It's a documented behavior to cancel a gesture by resetting its enabled state
        self.enabled = NO;
        self.enabled = YES;
    }
}

@end
