//
//  FSResource.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/29.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HKUserType @"user_type"
#define HKUserId @"user_id"
#define HKSchoolId @"school_id"
#define HKClassId @"class_id"

#define HKUserName @"user_name"

#define HKIsTeacher @"is_teacher"


@interface FSResource : NSObject

+ (FSResource *)shareInstance;

+ (void)setTokenQN:(NSString *)str;
+ (NSString *)getTokenQN;

+ (void)setAbleenter:(NSString *)str;
+ (NSString *)getAbleenter;
+ (void)setTel:(NSString *)tel;
+ (NSString *)getTel;

+ (void)setMessage:(NSInteger)msg;
+ (NSInteger)getMessage;

+ (void)setNotice:(NSInteger)notice;
+ (NSInteger)getNotice;

+ (void)setSex:(NSInteger)sex;
+ (NSInteger)getSex;

+ (void)setAdress:(NSString *)string;
+ (NSString *)getAdress;

+ (void)setIdentityDual:(NSInteger)isDual;
+ (NSInteger)getIdentityDual;

+ (void)setHeadmaster:(NSInteger)isHeadmaster;
+ (NSInteger)getHeadmaster;

+ (void)setRCToken:(NSString *)rctoken;
+ (NSString *)getRCtoken;

+ (void)setUserImage:(NSString *)stringImage;
+ (NSString *)getUserImage;

+ (void)setUserId:(NSString *)stringId;
+ (NSString *)getUserId;
+ (void)setDefaultSchoolId:(NSString *)stringId;
+ (NSString *)getDefaultSchoolId;
+ (void)setSchoolId:(NSString *)stringId;
+ (NSString *)getSchoolId;
+ (void)setClassId:(NSString *)stringId;
+ (NSString *)getClassId;

+ (void)setUserName:(NSString *)string;
+ (NSString *)getUserName;

+ (void)setUserType:(NSInteger)isTeacher;
+ (NSInteger)getUserType;

+ (void)setCarouselImg:(NSArray *)arr;
+ (NSArray *)getCarouselImg;

+ (void)setTopBarTitleArr:(NSArray *)arr;
+ (NSArray *)getTopBarTitleArr;

+ (void)setDotArr:(NSArray *)arr;
+ (NSArray *)getDotArr;

+ (void)setClassStudents:(NSArray *)arr;
+ (NSArray *)getClassStudents;

+ (void)setClassCarouselImg:(NSArray *)arr;
+ (NSArray *)getClassCarouselImg;

+ (void)setSchoolData:(NSMutableArray *)arr;
+ (NSMutableArray *)getSchoolData;

+ (void)setRCFriends:(NSArray *)arr;
+ (NSArray *)getRCFriends;
+ (void)setRCGroups:(NSArray *)arr;
+ (NSArray *)getRCGroups;
//+ (void)setCourseArr:(NSArray *)arr;
//+ (NSArray *)getCourseArr;

+ (void)setAddCourse:(NSArray *)arr;
+ (NSArray *)getAddCourse;
+ (void)setAddRoles:(NSArray *)arr;
+ (NSArray *)getAddRoles;
#pragma mark  提示消息
//- (UIAlertController *)alertControllerWithTitle:(NSString *)titleStr subtitle:(NSString *)subStr sure:(NSString *)sureStr cancel:(NSString *)cancelStr  withBlock:(void(^)(void))block;
//- (UIAlertController *)alertControllerWithTitle:(NSString *)titleStr subtitle:(NSString *)subStr sure:(NSString *)sureStr withBlock:(void(^)(void))block;
//- (UIAlertController *)alterActionTitle:(NSString *)mainTitle message:(NSString *)subTitle cancelTitle:(NSString *)cancelTitle Array:(NSArray *)sheetArr withBlock:(void(^)(NSString *chooseStr))block;

+(id)dictionaryValue:(NSDictionary*)dic forKey:(NSString*)key;
+(id)safetyArrayValue:(NSArray *)arr index:(NSInteger)num;
//- (void)showComplete: (NSString *)msg Time: (CGFloat)time;
//+ (UIImage *)loadImage:(NSString *)loadStr;
+ (NSString *)getFilePathName:(NSString *)urlStr;
//+ (NSString *)getPathWithFileName:(NSString *)fileName Image:(UIImage *)image;

@end
