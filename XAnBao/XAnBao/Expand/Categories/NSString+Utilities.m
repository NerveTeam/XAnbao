//
//  NSString+Utilities.m
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "NSString+Utilities.h"
#import "NSArray+Safe.h"
#import "NSDate+Utilities.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation NSString (Utilities)
- (NSString *)formatCommentDate:(NSDate *)date {
    return [date commentDateString];
}
@end

@implementation NSString (Intercept)
- (NSString *)subStringFontWidth:(CGFloat)fontW maxWidth:(CGFloat)maxW {
    
    NSUInteger fromIndex = (unsigned long)maxW / fontW;
    
    if (fromIndex > self.length) {
        fromIndex = self.length;
    }
    NSString *subStr = [self substringToIndex:fromIndex];
    NSMutableString *tempStr = [NSMutableString stringWithString:subStr];
    
    for (NSUInteger i = fromIndex; i < self.length; i++) {
        
        [tempStr appendString:[self substringWithRange:NSMakeRange(i, 1)]];
        
        CGSize size =  [tempStr sizeWithFont:[UIFont systemFontOfSize:fontW] constrainedToSize:CGSizeMake(MAXFLOAT, fontW)];
        
        
        if (size.width >= maxW) {
            tempStr = (NSMutableString *)[tempStr substringToIndex:tempStr.length -1];
            break;
        }
    }
    return tempStr.copy;
}
@end

@implementation NSString (Attribute)
- (NSAttributedString *)attributeSpace:(CGFloat)space {
    
    if (!self || self.length==0 || [self isEqualToString:@" "]) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedString;
}
@end

@implementation NSString ( Extension )

//- (NSString *)urlStringByAddParameter:(NSString *)parameter
//{
//    if ([self rangeOfString:@"?"].location == NSNotFound)
//    {
//        self = [self stringByAppendingString:@"?"];
//    }
//
//    if ([[self substringFromIndex:[self length] - 1] isEqualToString:@"?"])
//    {
//        self = [self stringByAppendingFormat:@"%@",parameter];
//    }
//    else
//    {
//        self = [self stringByAppendingFormat:@"&%@",parameter];
//    }
//
//    return self;
//}



+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            continue;
        }
        NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query]);
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString *)sign:(NSString *)sourceStr
{
    NSString *md5Str = [self MD5:sourceStr];
    NSString *prefix5 = [md5Str substringToIndex:5];
    NSString *suffix5 = [md5Str substringFromIndex:[md5Str length] -5];
    return [NSString stringWithFormat:@"%@%@",suffix5,prefix5];
}

+ (NSString *)randomNumberStringFrom:(NSInteger)from to:(NSInteger)to
{
    return [NSString stringWithFormat:@"%d",(int)(from + (arc4random() % (to - from + 1)))]; //+1,result is [from to]; else is [from, to)!!!!!!!
}

+ (NSString *) MD5:(NSString *)sourceStr
{
    const char* str = [sourceStr UTF8String];
    unsigned char result[16];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]            ];
}

- (NSString *) md5
{
    const char* str = [self UTF8String];
    unsigned char result[16];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]            ];
}



- (NSString *)subStringToTextNumber:(int)textNumber
{
    NSInteger i, n = [self length], l = 0, a = 0, b = 0;
    unichar c;
    for(i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c))
        {
            b++;
        } else if (isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
        
        if ((l+(int)ceilf((float)(a+b)/2.0)) > textNumber) {
            break;
        }
    }
    
    if(a == 0 && l == 0) return nil;
    return [self substringToIndex:i];
}

- (NSString *)subStringToCharacterNumber:(int)number {
    unichar cs[1024*2] = {};
    
    /*  系统截取会多符号
     int i = 0;
     int n = 0;
     while (n < number && i < self.length) {
     cs[i] = [self characterAtIndex:i];
     if (cs[i] > 255) {
     n += 2;
     }
     else {
     n += 1;
     }
     
     i ++;
     }
     
     if (n < number) {
     return self;
     }
     
     return [NSString stringWithCharacters:cs length:n];*/
    
    int n = 0;
    for (int i = 0; i < self.length; i ++) {
        int step = ([self characterAtIndex:i] > 255) ? 2 : 1;
        
        if (n + step > number) {
            break;
        }
        else {
            cs[i] = [self characterAtIndex:i];
            n += step;
        }
    }
    
    return [NSString stringWithCharacters:cs length:n];
}

- (int)characterNumber
{
    int n = 0;
    for (int i = 0; i < self.length; i ++) {
        int step = ([self characterAtIndex:i] > 255) ? 2 : 1;
        
        n += step;
    }
    
    return n;
}

- (CGSize)stringSizeWithFont:(UIFont *)font
              constrainWidth:(NSInteger)width
{
    NSAttributedString *attributedText = nil;
    if (font)
    {
        NSDictionary *dic = @{NSFontAttributeName:font};
        if ([dic isKindOfClass:[NSDictionary class]])
        {
            attributedText = [[NSAttributedString alloc] initWithString:self attributes:dic];
        }else
        {
            return CGSizeZero;
        }
    }
    else
    {
        return CGSizeZero;
    }
    
    if (nil != attributedText)
    {
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width,0}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return rect.size;
    }
    
    return CGSizeZero;
}

- (NSInteger) calculateTextNumber
{
    // Source: http://www.cocoachina.com/macdev/cocoa/2011/0110/2552.html
    NSInteger i, n = [self length], l = 0, a = 0, b = 0;
    unichar c;
    for(i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c))
        {
            b++;
        } else if (isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
    }
    if(a == 0 && l == 0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

- (NSString *) htmlEntityDecoding
{
    // 常用转义字符：http://114.xixik.com/character/
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"<",@"&lt;",@">",@"&gt;",@"\"",@"&quot;",@"&",@"&amp;",@" ",@"&nbsp;" ,nil];
    NSArray * array = [dic allKeys];
    NSString * htmlStr = self;
    for (NSString * aStr in array )
    {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:aStr withString:[dic objectForKey:aStr]];
    }
    
    return htmlStr;
}

//- (NSString *) htmlImgPathWithSkin
//{
//    //    NSBundle * bundle = [NSBundle mainBundle];
//    NSString * resPath = [[SNSkinEngine sharedEngine] currentSkinResourcePath];//[bundle resourcePath];
//
//    // 判断scale
//    //    BOOL isHD = ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])?(([[UIScreen mainScreen] scale] == 2)?YES:NO):NO;
//    NSArray * splitArray = [self componentsSeparatedByString:@"."];
//    NSString * hdImgName = [NSString stringWithFormat:@"%@@2x.%@",[splitArray objectAtIndex:0],[splitArray objectAtIndex:1]];
//    //    resPath = [resPath stringByAppendingPathComponent:(isHD)?hdImgName:self];
//
//    resPath = [resPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    resPath = [resPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//    resPath = [NSString stringWithFormat:@"file:/%@//%@",resPath, hdImgName];//(isHD)?hdImgName:self];
//    return resPath;
//
//}

- (NSString *) htmlImgPath
{
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * resPath = [bundle resourcePath];
    
    // 判断scale
    //    BOOL isHD = ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])?(([[UIScreen mainScreen] scale] == 2)?YES:NO):NO;
    NSArray * splitArray = [self componentsSeparatedByString:@"."];
    NSString * hdImgName = [NSString stringWithFormat:@"%@@2x.%@",[splitArray safeObjectAtIndex:0],[splitArray safeObjectAtIndex:1]];
    //    resPath = [resPath stringByAppendingPathComponent:(isHD)?hdImgName:self];
    
    resPath = [resPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    resPath = [resPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    resPath = [NSString stringWithFormat:@"file:/%@//%@",resPath, hdImgName];//(isHD)?hdImgName:self];
    return resPath;
}

+ (NSString *) htmlImgPath
{
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * resPath = [bundle resourcePath];
    resPath = [resPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    resPath = [resPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    resPath = [NSString stringWithFormat:@"file:/%@//",resPath];
    return resPath;
    
}
//
//+ (NSString *) htmlImgPathWithSkin
//{
//    NSString * resPath = [[SNSkinEngine sharedEngine] currentSkinResourcePath];
//
//    resPath = [resPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    resPath = [resPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//    resPath = [NSString stringWithFormat:@"file:/%@//",resPath];
//    return resPath;
//
//}

+ (NSString *) getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        //        NSLog(@"Error: %@", errorFlag);
        free(msgBuffer);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    //    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}


+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasPrefix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

+ (NSString *)urlParametersStringFromDictionary:(NSDictionary *)info
{
    __block NSMutableString * body = [NSMutableString stringWithCapacity:100];
    [info enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop)
     {
         @autoreleasepool
         {
             if ([body length] > 0)
             {
                 [body appendString:@"&"];
             }
             NSString * value = [NSString stringWithFormat:@"%@",[info objectForKey:key]];
             [body appendFormat:@"%@=%@",[key urlEncoding],[value urlEncoding]];
         }
     }];
    
    return body;
}

- (BOOL)containsString:(NSString *)searchString
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString].length > 0;
}

/*
 * http://my.oschina.net/yongbin45/blog/149549
 */
- (NSArray *)words
{
#if ! __has_feature(objc_arc)
    NSMutableArray *words = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray *words = [[NSMutableArray alloc] init];
#endif
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    char *word;
    for (int i = 0; i < strlen(str);) {
        int len = 0;
        if (str[i] >= 0xFFFFFFFC) {
            len = 6;
        } else if (str[i] >= 0xFFFFFFF8) {
            len = 5;
        } else if (str[i] >= 0xFFFFFFF0) {
            len = 4;
        } else if (str[i] >= 0xFFFFFFE0) {
            len = 3;
        } else if (str[i] >= 0xFFFFFFC0) {
            len = 2;
        } else if (str[i] >= 0x00) {
            len = 1;
        }
        word = malloc(sizeof(char) * (len + 1));
        for (int j = 0; j < len; j++) {
            word[j] = str[j + i];
        }
        word[len] = '\0';
        i = i + len;
        NSString *oneWord = [NSString stringWithCString:word encoding:NSUTF8StringEncoding];
        free(word);
        [words addObject:oneWord];
    }
    
    return words;
    
}

+ (NSString*)formatPlayTime:(long long)seconds
{
    NSInteger h=0,s=0,m=0;
    s = seconds%60;
    if (seconds >= 60)
    {
        m = (seconds/60)%60;
        if (seconds/60 >= 60)
        {
            h = (seconds/60)/60;
        }
    }
    
    NSString *formatedString = @"";
    if (h > 0)
    {
        formatedString = [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)h,(long)m,(long)s];
    }
    else
    {
        formatedString = [NSString stringWithFormat:@"%02ld:%02ld",(long)m,(long)s];
    }
    
    return formatedString;
}

- (NSMutableDictionary *)dictionaryFromQueryComponents
{
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    for(NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2)
            continue;
        NSString *key = [[keyValuePairArray safeObjectAtIndex:0] urlDecoding];
        NSString *value = [[keyValuePairArray safeObjectAtIndex:1] urlDecoding];
        if(value != nil) {
            [queryComponents setObject:value forKey:key];
        }
    }
    return queryComponents;
}

@end


@implementation NSString (urlEncoding)

+ (NSString *)URLEncodedString:(NSString *)string withCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[string mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding)) ;
}

+ (NSString *)URLEncodedString:(NSString *)string
{
    return [self URLEncodedString:string withCFStringEncoding:kCFStringEncodingUTF8];
}


- (NSString*) urlEncoding
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
    return result;
}

- (NSString*) urlDecoding
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (email)

+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end

@implementation NSString (SpecialCharacterCalculate)

- (NSUInteger)spc_getCharacterNumberAndIsAllDoubleByteCharacter:(BOOL*)isAllDouble
{
    BOOL allDouble = YES;
    NSUInteger n = 0;
    NSUInteger length = [self length];
    for (int i = 0; i < length; ++i)
    {
        int step = 1;
        
        if ([self characterAtIndex:i] > 255
            || ([self characterAtIndex:i] >= 65 && [self characterAtIndex:i] <= 90))
        {
            step = 2;
        }
        else
        {
            step = 1;
            allDouble = NO;
        }
        
        n += step;
    }
    
    if (nil != isAllDouble)
    {
        *isAllDouble = allDouble;
    }
    
    return n;
}

- (NSString *)spc_stringToCharacterNumber:(int)number
{
    unichar cs[1024*2] = {};
    
    NSUInteger n = 0;
    NSUInteger length = [self length];
    for (int i = 0; i < length; ++i) {
        int step = 1;
        
        if ([self characterAtIndex:i] > 255
            || ([self characterAtIndex:i] >= 65 && [self characterAtIndex:i] <= 90)) {
            step = 2;
        }
        
        if (n + step > number) {
            break;
        }
        else {
            cs[i] = [self characterAtIndex:i];
            n += step;
        }
    }
    
    return [NSString stringWithCharacters:cs length:n];
}

@end

@implementation NSString (Number2String)

+ (NSString *)numberToXWan:(NSInteger)target
{
    NSString *result = @"";
    result = [result convertNumString:target value:100000];
    //    if (target < 0) {
    //        target = 0;
    //    }
    //
    //    if (target < 100000) {
    //        result = [NSString stringWithFormat:@"%ld", (long)target];
    //    }
    //    else if (target < 9990001) {
    //        result = [NSString stringWithFormat:@"%ld万", (long)(target/10000)];
    //    }
    //    else {
    //        result = @"999万+";
    //    }
    return result;
}

+ (NSString *)numberToWan:(NSInteger)target{
    NSString *result = @"";
    result = [result convertNumString:target value:10000];
    return result;
}

/*!
 *  @brief 将数字转换为xx万的格式
 *
 *  @param target 原始总数
 *  @param value 根据不同需求进行区分的临界值，比如评论中以10w作为临界，正文围观中以1w作为临界
 *
 *  @return NSString : xxx万
 */
- (NSString *)convertNumString:(NSInteger)target value:(NSInteger)value{
    if (target < 0) {
        target = 0;
    }
    NSString *result = nil;
    if (target < value) {
        result = [NSString stringWithFormat:@"%ld", (long)target];
    }else if (target < 9990001) {
        result = [NSString stringWithFormat:@"%ld万", (long)(target/10000)];
    }else {
        result = @"999万+";
    }
    return result;
}

@end

@implementation NSString (Trim)

+(NSString *)trimWithDirtyString:(NSString *)dirtyString
{
    NSString *cleanString = [dirtyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cleanString;
}
@end

@implementation NSString (RemoveHtml)

+ (NSString *)stringByRemoveHTML:(NSString *)htmlCode
{
    NSRange range;
    NSString *cleanString = htmlCode ;
    while ((range = [cleanString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        cleanString = [cleanString stringByReplacingCharactersInRange:range withString:@""];
    return cleanString;
}

@end