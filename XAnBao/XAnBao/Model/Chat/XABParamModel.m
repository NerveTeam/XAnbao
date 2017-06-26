//
//  XABParamModel.m
//  XAnBao
//
//  Created by 韩森 on 2017/5/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABParamModel.h"

/*
 
 服务器那边 请求的参数 键  字母 首字母小写  ，返回数据 也是  首字母小写  ，不用写 MJCodingImplementation
 
 */
@implementation XABParamModel

//MJCodingImplementation

- (NSDictionary *)toJSON {
    
    NSDictionary *JSON = [self mj_keyValues];
    return JSON;
}

#pragma mark -校内群讨论组 的请求 参数

+ (instancetype)paramWithUserId:(NSString *)userId{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.userId = userId;
    return param;
}
#pragma mark -校内群的融云组用户 的请求 参数
+ (instancetype)paramChatSchoolGroupMembersWithGroupId:(NSString *)groupId{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.groupId = groupId;
    return param;
}

#pragma mark -班级成员-班级教师 的请求 参数
+ (instancetype)paramClassGradeTeachersWithClassId:(NSString *)classId{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.classId = classId;
    return param;
}

#pragma mark -班级成员-班级学生 的请求 参数
//+ (instancetype)paramClassGradeStudentsWithClassId:(NSString *)classId mobilePhone:(NSString *)mobilePhone{
//    
//    XABParamModel *param = [[XABParamModel alloc] init];
//    param.studentId = classId;
//    param.mobilePhone = mobilePhone;
//    return param;
//}
#pragma mark -班级成员-班级家长 的请求 参数
+ (instancetype)paramClassGradePatriarchWithStudentId:(NSString *)studentId{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.studentId = studentId;
    return param;
}
#pragma mark -班级群组 的请求 参数
+ (instancetype)paramClassGroupWithClassId:(NSString *)classId{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.classId = classId;
    return param;
}



#pragma mark - 课程表 的请求 参数
+ (instancetype)paramClassGradeCurriculumWithClassId:(NSString *)classId{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.classId = classId;
    return param;
}

+ (instancetype)paramChatSchoolGroupMembersWithId:(NSString *)id pass:(NSString *)pass{
    
    XABParamModel *param = [[XABParamModel alloc] init];
    param.id = id;
    param.pass = pass;
    return param;
}
@end


#pragma mark - 输出参数

#pragma mark 服务器返回数据主体
@implementation XABResponseModel

MJCodingImplementation
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    
//    return @{
//             
//             @"code" : @"Code",
//             @"message" : @"Message",
//             @"data" : @"Data"
//             
//             };
//}

//+ (NSDictionary *)mj_objectClassInArray {
//    
//    return @{
//             @"data" : @"NSDictionary"
//             
//             };
//}

+ (instancetype)responseFromKeyValues:(id)keyValues {
    
    XABResponseModel *response = [XABResponseModel mj_objectWithKeyValues:keyValues];
    
    return response;
}

@end

@implementation XABChatSchoolGroupModel

//MJCodingImplementation

@end

@implementation XABChatSchoolGroupMembersModel


@end

//班级 - 成员列表

@implementation XABChatClassGradeTeachersModel


@end


@implementation XABChatClassGradeTeachersDetailModel


@end

@implementation XABChatClassGradeStudentsModel


@end

@implementation XABChatClassGradeStudentsParentsModel

@end

@implementation XABChatClassGradeStudentsParentsDetailModel

@end

//班级群
@implementation XABChatClassGroupModel

//MJCodingImplementation

@end



#pragma mark -课程表

@implementation XABClassGradeCurriculumModel
//MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"curriculums":@"curriculums",
             };
}

+(NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"curriculums" : [XABCurriculumsModel class]
             };
}
@end

@implementation XABCurriculumsModel

@end
