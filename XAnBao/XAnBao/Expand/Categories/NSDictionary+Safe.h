//
//  NSDictionary+Safe.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)
/*!
 *  通过key取值，若为空返回nil
 *
 *  @param key 键值
 */
- (BOOL)isNull:(id)value;
- (id)objectForKeyNotNull:(id)key;
- (id)objectForKeySafely:(id)aKey;
@end

@interface NSMutableDictionary (SetValue)

/*!
 *  向当前字典中添加非空键值对
 *
 *  @param obj 需要设置的对象
 *  @param key 需要设置的键值
 */
- (void)setSafeObject:(id)obj forKey:(NSString *)key;

/*!
 *  向当前字典中添加键值对，如果要添加的指定对象为空，则删除其在当前字典中的key和value。
 *
 *  @param obj 需要设置的对象
 *  @param key 需要设置的键值
 */
- (void)rm_setSafeObject:(id)obj forKey:(NSString*)key;
@end