//
//  NSString+Extension.h
//  SinaRadio
//
//  Created by lina on 11-11-29.
//  Copyright (c) 2011年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString ( Extension )

//生成sign验证值
+ (NSString *) sign:(NSString *)sourceStr;
//生成一个 form  to 的随机数 
+ (NSString *) randomNumberStringFrom:(NSInteger)from to:(NSInteger)to;
+ (NSString *) MD5:(NSString *)sourceStr;
- (NSString *) md5;


- (NSString *) subStringToTextNumber:(int)textNumber;

// 按字符数截断（100个字符以内）
- (NSString *)subStringToCharacterNumber:(int)number;
- (int)characterNumber;

- (CGSize)stringSizeWithFont:(UIFont *)font
              constrainWidth:(NSInteger)width;

- (NSInteger) calculateTextNumber;

// html
- (NSString *) htmlEntityDecoding;
- (NSString *) htmlImgPath;
//- (NSString *) htmlImgPathWithSkin;
+ (NSString *) htmlImgPath;
//+ (NSString *) htmlImgPathWithSkin;

- (NSString *)urlStringByAddParameter:(NSString *)parameter;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

// UDID ? Mac Address
+ (NSString *) getMacAddress;

/* 通过 dic 拼接 string */
+ (NSString *)urlParametersStringFromDictionary:(NSDictionary *)info;

/* 在string中通过 key 找到 value */

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

- (BOOL)containsString:(NSString *)searchString;

- (NSArray *)words;

+ (NSString*)formatPlayTime:(long long)seconds;

- (NSMutableDictionary *)dictionaryFromQueryComponents;

@end

@interface NSString (urlEncoding)

+ (NSString *)URLEncodedString:(NSString *)string;
- (NSString *) urlEncoding;
- (NSString *) urlDecoding;

@end

@interface NSString (email)

+(BOOL) isValidEmail:(NSString *)checkString;

@end

@interface NSString (SpecialCharacterCalculate)

/*
 for 410 version
 汉字和大写字母算两个字符，小写字母和数字算一个字符
 如果全部都是两个字符的字符串，通过isAllDouble返回YES,否则返回NO
 */
- (NSUInteger)spc_getCharacterNumberAndIsAllDoubleByteCharacter:(BOOL*)isAllDouble;
- (NSString *)spc_stringToCharacterNumber:(int)number;

@end

@interface NSString (Number2String)
/*
 把数字转换成x万
 */
+ (NSString *)numberToXWan:(NSInteger)target;

/*
 正文围观数据,数字转换成x万(以1w为界限，小于1w显示原始数字)
 */
+ (NSString *)numberToWan:(NSInteger)target;

@end

@interface NSString (Trim)
//除去字符串中的空格和换行
+ (NSString *)trimWithDirtyString:(NSString *)dirtyString;
@end


@interface NSString (RemoveHtml)
//移除string中的html标签
+ (NSString *)stringByRemoveHTML:(NSString *)htmlCode;

@end

