//
//  NSDictionary+Safe.m
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)
- (BOOL)isNull:(id)value
{
    if(([NSNull null] == (NSNull *)value) || ([value isKindOfClass:[NSString class]] && [value length] == 0))
    {
        return YES;
    }
    
    return NO;
}
- (id)objectForKeyNotNull:(id)key
{
    id obj = [self objectForKey:key];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}
- (id)objectForKeySafely:(id)aKey
{
    if ([self isNull:[self objectForKey:aKey]])
    {
        return nil;
    }
    return [self objectForKey:aKey];
}
@end
@implementation NSMutableDictionary (SetValue)
- (void)setSafeObject:(id)obj forKey:(NSString *)key
{
    if (obj == nil || key == nil)
        return;
    
    [self setObject:obj forKey:key];
}

- (void)rm_setSafeObject:(id)obj forKey:(NSString *)key
{
    if (!obj)
    {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:obj forKey:key];
}

@end