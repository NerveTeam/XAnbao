//
//  NSObject+CRBoost.h
//  ECO
//
//  Created by RoundTu on 12/27/13.
//  Copyright (c) 2013 Cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark NSObject
@interface NSObject (CRBoost)
- (void)tryMethod:(SEL)sel;
- (void)tryMethod:(SEL)sel arg:(id)arg;
- (void)tryMethod:(SEL)sel arg:(id)arg1 arg:(id)arg2;
- (id)nullToNil;
@end




#pragma mark -
#pragma mark NSString
extern NSString *const kPathFlagRetina;
extern NSString *const kPathFlagBig;
extern NSString *const kPathFlagHighlighted;
extern NSString *const kPathFlagSelected;

@interface NSString (CRBoost)
+ (NSString *)stringWithNumber:(NSInteger)number padding:(int)padding;
- (NSAttributedString *)underlineAttributeString;
- (NSString *)pathByAppendingFlag:(NSString *)flag; //appending between file name and extension
- (NSString *)join:(NSString *)path;
- (NSString *)joinExt:(NSString *)ext;
- (NSString *)joinPath:(NSString *)path;
- (NSString *)joinPath:(NSString *)path1 path:(NSString *)path2;
- (NSString *)deleteLastPathComponent;
- (NSString *)deletePathExtension;
- (BOOL)beginWith:(NSString *)string;
- (BOOL)endWith:(NSString *)string;
- (BOOL)containsString:(NSString *)aString;
#pragma --mark Path
+(CGPathRef)pathRefFromText:(NSString *)text animation:(BOOL)animated;

#pragma --mark MD%
+(NSString*)getMD5WithData:(NSData*)data;
+(NSString*)getmd5WithString:(NSString*)string;
+ (NSString*)getmd5_16WithString:(NSString *)string;
+(NSString*)getFileMD5WithPath:(NSString*)path;
+(BOOL) isDBNull:(id)value;
+(NSString *) valueToString:(id)value;
+(NSDate*) valueToDate:(id)value;
+(id) dateToValue: (NSDate *) date;
- (NSString *)decodeHTMLCharacterEntities;
- (NSString *)encodeHTMLCharacterEntities;

#pragma --mark URLEncode
+ (NSString *)StringEncode:(NSString*)str;
+ (NSString *)StringDecode:(NSString*)str;
+ (NSString *)URLEncode:(NSString*)baseUrl data:(NSDictionary*)dictionary;
+ (NSArray *)URLDecode:(NSString *)url;
+ (NSString*)getTimeString:(NSDate*)date;
@end

#pragma mark -
#pragma mark NSDate
/**
 * date formatter
 *
 * date format
 * 0: no separator
 * 1: use '/' as separator
 * 2: use '-' as separator
 *
 * time format
 * 0: use ':' as separator
 */
static NSString *const kDateTemplate0yyyyMMdd = @"yyyyMMdd";
static NSString *const kDateTemplate0hmma = @"h:mm a";

static NSString *const kDateTemplate1MMddyyyy = @"MM/dd/yyyy";
static NSString *const kDateTemplate1MMddyy = @"MM/dd/yy";
static NSString *const kDateTemplate1ddMMyyyy0HHmmss = @"dd/MM/yyyy HH:mm:ss";
static NSString *const kDateTemplate1ddMMyyyy0HHmm = @"dd/MM/yyyy HH:mm";
static NSString *const kDateTemplate1ddMM0HHmm = @"dd/MM HH:mm";

static NSString *const kDateTemplate2MMddyyyy = @"MM-dd-yyyy";
static NSString *const kDateTemplate2yyyyMMdd0HHmmss = @"yyyy-MM-dd HH:mm:ss";
static NSString *const kDateTemplate2yyyyMMdd0HHmm = @"yyyy-MM-dd HH:mm";
static NSString *const kDateTemplate2yyyyMMdd0HHmmssZZZ = @"yyyy-MM-dd HH:mm:ss ZZZ";
@interface NSDate (CRBoost)
+ (NSDate *)dateWithinYear;
+ (NSDate *)dateWithTimeIntervalSince1970Number:(NSNumber *)number;
+ (NSDate *)dateWithTimeIntervalSince1970String:(NSString *)string;
+ (NSDate *)dateWithString:(NSString *)date template:(NSString *)tmplate;
- (NSString *)stringWithTemplate:(NSString *)tmplate;
- (NSString *)timeIntervalSince1970String;
- (NSNumber *)timeIntervalSince1970Number;
- (BOOL)isSameDay:(NSDate *)date;
@end





#pragma mark -
#pragma mark NSMutableDictionary
@interface NSMutableDictionary (CRBoost)
- (void)safeSetObject:(id)obj forKey:(id<NSCopying>)key;
@end






#pragma mark -
#pragma mark NSMutableArray
@interface NSArray (CRBoost)
- (id)safeObjectAtIndex:(NSInteger)index;
@end





#pragma mark -
#pragma mark NSMutableArray
@interface NSMutableArray (CRBoost)
- (void)safeAddObject:(id)obj;
@end




#pragma mark -
#pragma mark NSAttributedString
@interface NSAttributedString (CRBoost)
+ (instancetype)stringWithJSON:(id)json;
+ (instancetype)stringWithJSONString:(NSString *)string;
+ (instancetype)stringWithString:(NSString *)string attribute:(NSString *)attribute;

- (id)dumpJSON;
- (id)attributeJSON; //dump only the attribte to json
- (NSString *)jsonString;
- (NSString *)attributeString; //json like
@end;




#pragma mark -
#pragma mark NSMutableAttributedString
@interface NSMutableAttributedString (CRBoost)

@end


