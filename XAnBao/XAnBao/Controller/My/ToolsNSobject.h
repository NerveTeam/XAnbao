//
//  ToolsNSobject.h
//  NewESOP
//
//  Created by Apex on 16/4/21.
//  Copyright © 2016年 Apex. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __BASE64( text )        [Base64codeFunc text2pass:text]
/******base64（通过DES解密）转字符串******/
#define __TEXT( base64 )        [Base64codeFunc textFromBase64String:base64]
@interface ToolsNSobject : NSObject

+ (NSString *)text2pass:(NSString *)text;

+ (NSString *)textFromBase64String:(NSString *)base64;

+(NSString *)textMd5:(NSString *)text;

//// 地市编码转汉字
+(NSString *)code2region:(NSString *)code;

@end
