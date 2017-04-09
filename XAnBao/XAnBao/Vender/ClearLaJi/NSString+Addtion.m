//
//  NSString+Addtion.m
//  易聊
//
//  Created by 张毛 on 15-7-23.
//  Copyright (c) 2015年 ZM. All rights reserved.
//

#import "NSString+Addtion.h"

@implementation NSString (Addtion)
//获取路径
+ (NSString* )getFilePath:(NSString* )filePath
{
    //filePath = chatscache/1/chat.plist
    //通过拆分得到一个个路径
    NSArray* array = [filePath componentsSeparatedByString:@"/"];
    NSString* fileName = [array lastObject];
    //找到chat.plist在这个chatscache/1/chat.plist字符串的位置
    NSRange range = [filePath rangeOfString:fileName];
    //根据位置range把这个位置的字符替换掉
    filePath = [filePath stringByReplacingCharactersInRange:range withString:@""];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"成功");
        }
    }
    
    filePath = [filePath stringByAppendingString:fileName];
    return filePath;
}
//获取文件大小
+ (float)getFileSizeWithPath:(NSString* )filePath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //不存在，直接返回0
        return 0;
    }
    
    //array放的是这个路径下的所有子路径
    NSArray* array = [[NSFileManager defaultManager] subpathsAtPath:filePath];
    //把一个array转化为枚举(取一个，少一个)
    NSEnumerator* enumerator = [array objectEnumerator];
    
    float length = 0;
    NSString* path = [enumerator nextObject];
    while (path) {
        NSString* subFilePath = [NSString stringWithFormat:@"%@/%@",filePath,path];
        length = length + [[[[NSFileManager defaultManager] attributesOfItemAtPath:subFilePath error:nil] objectForKey:NSFileSize] floatValue];
        //再次取出下一个
        path = [enumerator nextObject];
    }
    return length / (1000.0*1000.0);
}
@end
