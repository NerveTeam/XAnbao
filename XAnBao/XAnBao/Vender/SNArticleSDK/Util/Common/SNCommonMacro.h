//
//  SNCommonMacro.h
//  SinaNews
//
//  Created by frost on 14-3-7.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#ifndef SinaNews_SNCommonMacro_h
#define SinaNews_SNCommonMacro_h

#import <Foundation/NSObjCRuntime.h>

//macro for ARC
#if __has_feature(objc_arc)
#define SN_SAFE_ARC_RELEASE(__POINTER)             ((__POINTER) = nil)
#define SN_SAFE_ARC_RETAIN(__POINTER)              (__POINTER)
#define SN_SAFE_ARC_AUTORELEASE(__POINTER)         (__POINTER)
#define SN_SAFE_ARC_SUPER_DEALLOC()
#else
#define SN_SAFE_ARC_RELEASE(__POINTER)             ({ [(__POINTER) release]; (__POINTER) = nil; })
#define SN_SAFE_ARC_RETAIN(__POINTER)              ([(__POINTER) retain])
#define SN_SAFE_ARC_AUTORELEASE(__POINTER)         ([(__POINTER) autorelease])
#define SN_SAFE_ARC_SUPER_DEALLOC()                ([super dealloc])
#endif

/** Warnings **/
#define SN_UNUSED_VAR(x) (void)(x)

#define SN_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/**
 * Indicates any overrided impl in subclasses should invoke super call
 */
#if __has_attribute(objc_requires_super)
#define SN_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
#define SN_REQUIRES_SUPER
#endif

/**
 * mark a property or a method be deprecated
 */
#if __has_attribute(deprecated)
#define SN_DEPRECATED __attribute__((deprecated))
#else
#define SN_DEPRECATED
#endif


/** Colors **/
#define SN_COLOR_RGBA(r, g, b, a) 	[UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define SN_COLOR_RGB(r, g, b) 		SN_COLOR_RGBA(r, g, b, 1.0f)
#define SN_COLOR_HEX(rgb) 			SN_COLOR_RGB((rgb) >> 16 & 0xff, (rgb) >> 8 & 0xff, (rgb) & 0xff)


/** Singleton **/
#undef	SN_DEF_SINGLETON
#define SN_DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance;


#undef	SN_IMP_SINGLETON
#define SN_IMP_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

/** String **/
#define SN_EMPTRY_STRING                              (@"");
#define SN_SAFE_STRING(__string)                      ((__string && [__string isKindOfClass:[NSString class]]) ? __string :@"")


/** VALID CHECKING**/
#define CHECK_VALID_STRING(__string)               (__string && [__string isKindOfClass:[NSString class]] && [__string length])
#define CHECK_VALID_NUMBER(__aNumber)               (__aNumber && [__aNumber isKindOfClass:[NSNumber class]])
#define CHECK_VALID_ARRAY(__aArray)                 (__aArray && [__aArray isKindOfClass:[NSArray class]] && [__aArray count])
#define CHECK_VALID_DICTIONARY(__aDictionary)       (__aDictionary && [__aDictionary isKindOfClass:[NSDictionary class]] && [__aDictionary count])

#define kStringArray [NSArray arrayWithObjects:@"举报", nil]
#define kImageArray [NSArray arrayWithObjects:[UIImage skinImageNamed:@"commentReport_icon_normal"], nil]
#define kTipCommentPopViewTitle @"评论操作"



// block self
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(strongSelf, weakSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

#define WEAKSELF WeakSelf(weakSelf)
#define STRONGSELF StrongSelf(strongSelf, weakSelf)

#endif
