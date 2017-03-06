//
//  NSDictionary+Helper.m
//  SinaNews
//
//  Created by bond on 14-2-10.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "NSDictionary+SNArticle.h"

@implementation NSDictionary (SNArticle)

+ (NSDictionary *)dictionaryClassSafeWith:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [self dictionaryWithDictionary:object];
    }else{
        return nil;
    }
}

- (NSArray *)allKeysSorted
{
    NSArray *array = [self allKeys];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSString *key in array) {
        [temp addObject:key];
    }
    return [temp sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if ([obj2 integerValue] > [obj1 integerValue])
        {
            return NSOrderedAscending;
        }
        else if ([obj2 integerValue] == [obj1 integerValue])
        {
            return NSOrderedSame;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
}

- (BOOL)isNull:(id)value
{
    if(([NSNull null] == (NSNull *)value) || ([value isKindOfClass:[NSString class]] && [value length] == 0))
    {
        return YES;
    }

    return NO;
}

- (id)objectForKeySafely:(id)aKey
{
    if ([self isNull:[self objectForKey:aKey]])
    {
        return nil;
    }
    return [self objectForKey:aKey];
}

//获取aKey下的data字段,若aKey对应的字段非NSDictionary,则返回aKey对应的指,否则返回data值
- (id)objectDataForKeySafely:(id)aKey
{
    if ([self isNull:[self objectForKey:aKey]])
    {
        return nil;
    }
    if([[self objectForKey:aKey] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = [self objectForKey:aKey];
        if ([self isNull:[dict objectForKey:@"data"]])
        {
            return dict;
        }
        else
        {
            return [dict objectForKey:@"data"];
        }
    }
    return [self objectForKey:aKey];
}

- (id)valueForKeySafely:(NSString *)key
{
    if ([self isNull:[self valueForKey:key]])
    {
        return nil;
    }
    return [self valueForKey:key];
}

- (id)valueForKeyPathSafely:(NSString *)keyPath
{
    if ([self isNull:[self valueForKeyPath:keyPath]])
    {
        return nil;
    }
    return [self valueForKeyPath:keyPath];
}

- (NSMutableDictionary *)deepMutableCopy;
{
    NSMutableDictionary *newDictionary;
    NSEnumerator *keyEnumerator;
    id anObject;
    id aKey;
	
    newDictionary = [self mutableCopy];
    // Run through the new dictionary and replace any objects that respond to -deepMutableCopy or -mutableCopy with copies.
    keyEnumerator = [[newDictionary allKeys] objectEnumerator];
    while ((aKey = [keyEnumerator nextObject])) {
        anObject = [newDictionary objectForKey:aKey];
        if ([anObject respondsToSelector:@selector(deepMutableCopy)]) {
            anObject = [anObject deepMutableCopy];
            [newDictionary setObject:anObject forKey:aKey];
        } else if ([anObject respondsToSelector:@selector(mutableCopyWithZone:)]) {
            anObject = [anObject mutableCopyWithZone:nil];
            [newDictionary setObject:anObject forKey:aKey];
        } else {
			[newDictionary setObject:anObject forKey:aKey];
		}
    }
	
    return newDictionary;
}

@end

@implementation NSMutableDictionary (SafeExtensions)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey)
    {
        [self setObject:anObject forKey:aKey];
    }
    else
    {
        
    }
}

- (void)safeSetValue:(id)value forKey:(NSString *)key
{
    if (key)
    {
        [self setValue:value forKey:key];
    }
    else
    {
        
    }
}

@end
