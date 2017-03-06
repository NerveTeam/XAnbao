//
//  SNGlobalUtil.h
//  SinaNews
//
//  Created by frost on 14-3-13.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SNCommonGlobalUtil : NSObject

+ (NSString*) trimString:(NSString*)str;

+ (BOOL)isSinaDomainH5:(NSString*)url;

+ (NSString*)getResolution;

+ (BOOL)hasRect:(CGRect)rect;

+ (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes;

+ (BOOL)isAllocLocal;

+ (NSDateComponents *)currentDateComponents;
@end

///-----------------------------------------------------------------------------
/// Global utility method

NSNumber* SNNumber(id obj, NSNumber *defaultValue);

NSDictionary* SNDictionary(id obj, NSDictionary* defaultValue);

NSArray* SNArray(id obj, NSArray* defaultValue);

int SNInt(id obj, int defaultValue);

NSInteger SNInteger(id obj, NSInteger defaultValue);

double SNDouble(id obj, double defaultValue);

float SNFloat(id obj, float defaultValue);

BOOL SNBool(id obj, BOOL defaultValue);

/**
 * @return returns obj if it passes CHECK_VALID_STRING test otherwise defaultString is returned
 */
NSString * SNString(NSString * value, NSString * defaultString);


///-----------------------------------------------------------------------------
@interface SNWeakObject : NSObject
@property(nonatomic, weak, readonly) id object;
- (instancetype)initWithObject:(id)obj;
@end

///-----------------------------------------------------------------------------
@interface UIGestureRecognizer (SNUtils)

- (void)cancelGesture;

@end
