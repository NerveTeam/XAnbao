//
//  NSDictionary+Helper.h
//  SinaNews
//
//  Created by bond on 14-2-10.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SNArticle)

- (BOOL)isNull:(id)value;
- (id)objectForKeySafely:(id)aKey;
//获取aKey下的data字段,若aKey对应的字段非NSDictionary,则返回aKey对应的指,否则反悔data值
- (id)objectDataForKeySafely:(id)aKey;
- (id)valueForKeySafely:(NSString *)key;
- (id)valueForKeyPathSafely:(NSString *)keyPath;
- (NSArray *)allKeysSorted;
- (NSMutableDictionary *)deepMutableCopy NS_RETURNS_RETAINED;

@end

@interface NSMutableDictionary (SafeExtensions)
- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)safeSetValue:(id)value forKey:(NSString *)key;
@end
