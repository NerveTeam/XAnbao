//
//  GAppDefine.h
//  iOSAppConst
//
//  Created by kaoke on 16/1/18.
//  Copyright © 2016年 WT. All rights reserved.
//

#ifndef CRAppDefine_h
#define CRAppDefine_h

#pragma mark -
#pragma mark Hardware & OS

#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc_weak) && (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#define __weak_delegate __weak
#else
#define weak_delegate unsafe_unretained
#define __weak_delegate __unsafe_unretained
#endif

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#define CR_iOS
typedef CGRect NSRect;
typedef CGSize NSSize;
#else
#define CR_OSX
typedef NSView UIView;
#endif

#ifdef CR_iOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#endif


#pragma mark -
#pragma mark foundation
//==================object==================
#define CRNull [NSNull null]
//==================string==================
#define CRString(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]
#define CRStringNum(number) CRString(@"%ld", (long)number)
#define $str(...)   [NSString stringWithFormat:__VA_ARGS__]
//==================array==================
#define CRMArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
//==================date==================
#define CRCOMPS_DATE NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define CRCOMPS_TIME NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
//==================range==================
#define CRRangeZero NSMakeRange(0, 0)



#pragma mark -
#pragma mark notification
#define CRRegisterNotification(sel, nam)            CRRegisterNotification3(sel, nam, nil)
#define CRRegisterNotification3(sel, nam, obj)      CRRegisterNotification4(self, sel, nam, obj)
#define CRRegisterNotification4(obs, sel, nam, obj) [[NSNotificationCenter defaultCenter] addObserver:obs selector:sel name:nam object:obj]
#define CRUnregisterNotification(obs)               CRUnregisterNotification2(obs, nil)
#define CRUnregisterNotification2(obs, nam)         CRUnregisterNotification3(obs, nam, nil)
#define CRUnregisterNotification3(obs, nam, obj)    [[NSNotificationCenter defaultCenter] removeObserver:obs name:nam object:obj]
#define CRPostNotification(name)                    CRPostNotification2(name, nil)
#define CRPostNotification2(name, obj)              CRPostNotification3(name, obj, nil)
#define CRPostNotification3(name, obj, info)        [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]


#pragma mark -
#pragma mark image
//==================image==================
#define CRImageNamed(name)         [UIImage imageNamed:name]
#define CRImageFormated(fmt, ...)  CRImageNamed(CRString(fmt, ##__VA_ARGS__))
#define CRImageFiled(path)         [UIImage imageWithContentsOfFile:path]
#define CRImageViewNamed(name)     [[UIImageView alloc] initWithImage:CRImageNamed(name)]
#define CRImageViewFormated(fmt,...)  [[UIImageView alloc] initWithImage:CRImageFormated(fmt, ##__VA_ARGS__)]
#define CRImageViewFiled(path)        [[UIImageView alloc] initWithImage:CRImageFiled(path)]


#pragma mark -
#pragma mark device
#ifdef CR_iOS
//==================model==================
#define IS_IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_BEFORE_iOS8 ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)

#endif

#define AppWindow [UIApplication sharedApplication].keyWindow


#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//application status
#define CRAPP_IN_BACKGROUND (CRSharedApp.applicationState==UIApplicationStateBackground)
#define CRDisableAppIdleTimer(flag) CRSharedApp.idleTimerDisabled=(flag)

//==================network==================
#define CRDisplayNetworkIndicator(flag) [CRSharedApp setNetworkActivityIndicatorVisible:(flag)]



#pragma mark -
#pragma mark system
//==================system version==================
#define CROSVersionEqualTo(v)           ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define CROSVersionGreaterThan(v)       ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define CROSVersionNotLessThan(v)       ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define CROSVersionLessThan(v)          ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define CROSVersionNotGreaterThan(v)    ([[CRCurrentDevice systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define CRAppDisplayName                [CRBundle infoDictionary][@"CFBundleDisplayName"]
#define CRAppBuild                      [CRBundle infoDictionary][(NSString *)kCFBundleVersionKey]
#define CRAppVersionShort               [CRBundle infoDictionary][@"CFBundleShortVersionString"]






#pragma mark -
#pragma mark App Default
#define CRSharedApp             [UIApplication sharedApplication]
#define CRAppDelegate           [CRSharedApp delegate]
#define CRNotificationCenter    [NSNotificationCenter defaultCenter]
#define CRCurrentDevice         [UIDevice currentDevice]
#define CRBundle                [NSBundle mainBundle] //the main bundle
#define CRMainScreen            [UIScreen mainScreen]
#define CRCurrentLanguage       [NSLocale preferredLanguages][0]
#define CRScreenScaleFactor     [CRMainScreen scale]
#define CRFileMgr               [NSFileManager defaultManager]

//==================user defaults==================
#define CRUserDefaults              [NSUserDefaults standardUserDefaults]
#define CRUserObj(key)              [CRUserDefaults objectForKey:(key)]
#define CRUserBOOL(key)             [CRUserDefaults boolForKey:(key)]
#define CRUserInteger(key)          [CRUserDefaults integerForKey:(key)]
#define CRUserSetObj(obj, key)      [CRUserDefaults setObject:(obj) forKey:(key)]
#define CRUserSetInteger(i, key)    [CRUserDefaults setObject:@(i) forKey:(key)]
#define CRUserSetBOOL(boo, key)     [CRUserDefaults setBool:boo forKey:(key)]
#define CRUserRemoveObj(key)        [CRUserDefaults removeObjectForKey:(key)]


#pragma mark -
#pragma mark GCD
//==================block==================
#define CRBackgroundGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define CRMainGCD(block)       dispatch_async(dispatch_get_main_queue(), block)
#define CRWeekRef(obj)         __weak typeof(obj) __##obj = obj
#define CRBlockRef(obj)        __block typeof(obj) __##obj = obj

//==================selector==================
#define CRIfReturn(con)     if(con) return
#define CRNilReturn(obj)    if(!obj) return
#define CRReturnNil         return nil;
#define SELE(sel)           @selector(sel)

//==================singleton==================
#ifndef CRSingleton
#define CRSingleton(classname, method)                      \
+ (classname *)shared##method {                             \
static dispatch_once_t pred;                            \
__strong static classname *shared##classname = nil;     \
dispatch_once(&pred, ^{                                 \
shared##classname = [[self alloc] init];            \
});                                                     \
return shared##classname;                               \
}
#endif

#define CRManager(classname) CRSingleton(classname, Manager)



#pragma mark -
#pragma mark color
//==================color==================
#define CRCOLOR_CLEAR           [UIColor clearColor]
#define CRCOLOR_WHITE           [UIColor whiteColor]
#define CRCOLOR_BLACK           [UIColor blackColor]
#define CRCOLOR_RED             [UIColor redColor]
#define CRCOLOR_BACKGROUND      [UIColor colorFromHexRGB:@"dedede"]
#define CRColorPattern(name)    [UIColor colorWithPatternImage:UIIMAGE_NAMED(name)]

//r, g, b range from 0 - 1.0
#define CRRGB_F(r,g,b)     CRRGBA_F(r, g, b, 1.0)
#define CRRGBA_F(r,g,b,a)  [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
//r, g, b range from 0 - 255
#define CRRGB(r,g,b)       CRRGBA(r, g, b, 1.0)
#define CRRGBA(r,g,b,a)    CRRGBA_F((r)/255.f, (g)/255.f,(b)/255.f, a)
//rgbValue is a Hex vaule without prefix 0x
#define CRRGB_X(rgb)       CRRGBA_X(rgb, 1.0)
#define CRRGBA_X(rgb, a)   CRRGBA((float)((0x##rgb & 0xFF0000) >> 16), (float)((0x##rgb & 0xFF00) >> 8), (float)(0x##rgb & 0xFF), (a))




#pragma mark -
#pragma mark log
//==================log==================
#ifndef __OPTIMIZE__
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif


#ifdef DEBUG //debug
#   define CRLog(fmt, ...) NSLog((@"%@->%@ <Line %d>: " fmt), NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, ##__VA_ARGS__)

#   define _ptp(point) DLOG(@"CGPoint: {%.0f, %.0f}", (point).x, (point).y)
#   define _pts(size) DLOG(@"CGSize: {%.0f, %.0f}", (size).width, (size).height)
#   define _ptr(rect) DLOG(@"CGRect: {{%.1f, %.1f}, {%.1f, %.1f}}", (rect).origin.x, (rect).origin.y, (rect).size.width, (rect).size.height)
#   define _pto(obj) DLOG(@"object %s: %@", #obj, [(obj) description])
#   define _ptb(boo) DLOG(@"boolean value %s: %@", #boo, boo?@"YES":@"NO")
#   define _pti(i) DLOG(@"integer value %s: %ld", #i, (long)i)
#   define _ptm    NSLog(@"\nmark called %s, at line %d", __PRETTY_FUNCTION__, __LINE__)
#   define _if(con)     if(con) NSLog(@"\ncondition matched %s, at line %d", __PRETTY_FUNCTION__, __LINE__)

#   define ULOG(fmt, ...)  { \
NSString *title = [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__]; \
NSString *msg = [NSString stringWithFormat:fmt, ##__VA_ARGS__];     \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title       \
message:msg         \
delegate:nil         \
cancelButtonTitle:@"OK"       \
otherButtonTitles:nil];       \
[alert show]; \
}
#else //release
#   define CRLog(...)
#   define ULOG(...)
#   define _ptp(point)
#   define _pts(size)
#   define _ptr(rect)
#   define _ptb(boo)
#   define _pti(i)
#   define _pto(obj)
#   define _ptm
#   define _if(con)
#endif

#endif /* GAppDefine_h */
