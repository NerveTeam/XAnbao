//
//  NSString+Addtion.h
//  易聊
//
//  Created by 张毛 on 15-7-23.
//  Copyright (c) 2015年 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addtion)

//获取路径
+ (NSString* )getFilePath:(NSString* )filePath;
//获取文件大小
+ (float)getFileSizeWithPath:(NSString* )filePath;
@end
