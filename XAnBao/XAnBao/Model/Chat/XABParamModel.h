//
//  XABParamModel.h
//  XAnBao
//
//  Created by 韩森 on 2017/5/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "XABUserLogin.h"

#pragma mark 具体参数模型
/**
 向服务器发送的参数模型
 */
@interface XABParamModel : NSObject

@property (copy, nonatomic) NSString *userId;  //用户ID
@property (copy, nonatomic) NSString *groupId; //班级ID
@property (copy, nonatomic) NSString *classId; //班级ID
@property (copy, nonatomic) NSString *mobilePhone;//用户手机号
@property (copy, nonatomic) NSString *studentId; // 学生ID
@property (copy, nonatomic) NSString *id;  //用户ID
@property (copy, nonatomic) NSString *pass;  //用户ID


- (NSDictionary *)toJSON;

#pragma mark -校内群讨论组 的请求 参数

+ (instancetype)paramWithUserId:(NSString *)userId;
#pragma mark - 校内群 的融云组用户 参数
+ (instancetype)paramChatSchoolGroupMembersWithGroupId:(NSString *)groupId;

#pragma mark -班级成员-班级教师 的请求 参数
+ (instancetype)paramClassGradeTeachersWithClassId:(NSString *)classId;
#pragma mark -班级成员-班级学生 的请求 参数
//+ (instancetype)paramClassGradeStudentsWithClassId:(NSString *)classId mobilePhone:(NSString *)mobilePhone;
#pragma mark -班级成员-班级家长 的请求 参数
+ (instancetype)paramClassGradePatriarchWithStudentId:(NSString *)studentId;

#pragma mark -班级群组 的请求 参数
+ (instancetype)paramClassGroupWithClassId:(NSString *)classId;
#pragma mark - 课程表 的请求 参数
+ (instancetype)paramClassGradeCurriculumWithClassId:(NSString *)classId;

+ (instancetype)paramChatSchoolGroupMembersWithId:(NSString *)id pass:(NSString *)pass;
@end

#pragma mark - 输出参数

#pragma mark 服务器返回数据主体

@interface XABResponseModel : NSObject

// 数据访问是否成功的  Code 码
@property (assign, nonatomic) NSInteger code;

// 备注信息
@property (copy, nonatomic) NSString *message;

// 数据条数
//@property (strong, nonatomic) NSNumber *count;

// 数据体, JSON(NSDictionary)组成的数组、也可能是字典
@property (strong, nonatomic) id data;

+ (instancetype)responseFromKeyValues:(id)keyValues;

@end


#pragma mark 校内群讨论组 模型

@interface XABChatSchoolGroupModel : NSObject

@property (copy, nonatomic) NSString *groupId; //融云组ID
@property (nonatomic,copy) NSString *name;     //名称
@end

#pragma mark 校内群讨论组 - 成员- 模型
@interface XABChatSchoolGroupMembersModel : NSObject

@property (copy, nonatomic) NSString *portrit;    //头像地址
@property (nonatomic,copy) NSString *name;        //名字
@property (nonatomic,copy) NSString *sex;         //性别
@property (nonatomic,copy) NSString *available;   //
@property (nonatomic,copy) NSString *mobilePhone; //电话

@end

#pragma mark - 成员列表

#pragma mark 班级教师 模型

@interface XABChatClassGradeTeachersModel : NSObject

@property (copy, nonatomic) NSString *id;         //老师id
@property (nonatomic,copy) NSString *name;        //姓名
@property (nonatomic,copy) NSString *subjectId;   //老师科目Id
@property (nonatomic,copy) NSString *subject;     //科目


@end


@interface XABChatClassGradeStudentsModel : NSObject

@property (copy, nonatomic) NSString *id;         //学生id
@property (nonatomic,copy) NSString *name;        //姓名



@end
#pragma mark 班级群 模型

@interface XABChatClassGroupModel : NSObject

@property (copy, nonatomic) NSString *groupId; //融云组ID
@property (nonatomic,strong) NSString *name;   //名称
@end










#pragma mark - 课程表 模型
@class XABCurriculumsModel;
@interface XABClassGradeCurriculumModel : NSObject
@property (nonatomic,strong) NSString *kname;         // 课程表名称
@property (nonatomic,strong) NSString *content;      // 课程表说明
@property (nonatomic,strong) NSArray <XABCurriculumsModel *>*curriculums;  // 课程


@end


@interface XABCurriculumsModel : NSObject

@property (nonatomic,strong) NSString *name;        // 课程名称
@property (nonatomic,assign) int dayOfTheWeek; // 周几
@property (nonatomic,assign) int lessonNumber; // 第几节课
@end












