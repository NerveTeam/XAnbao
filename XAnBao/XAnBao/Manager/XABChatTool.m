//
//  XABChatTool.m
//  XAnBao
//
//  Created by 韩森 on 2017/4/22.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatTool.h"
#import "XABChatRequest.h"
#import "XABUserLogin.h"
static NSString *const RC_APPKEY = @"8brlm7uf8p353";
//@"z3v5yqkbvyyd0";

@interface XABChatTool ()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation XABChatTool


static XABChatTool *_instance;
+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XABChatTool alloc]init];
    });
    return _instance;
}

#pragma mark - 初始化融云SDK
-(void)initWithRCIM{
    
    [[RCIM sharedRCIM] initWithAppKey:RC_APPKEY];

}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
//获取到从服务端获取的 Token，通过 RCIM 的单例 建立与服务器的连接
-(void)connectRCServer{
    
    NSString *token = [XABUserLogin getInstance].userInfo.token;
    NSLog(@"服务端获取的token=== %@", token);
    
    if (!token) {
        return;
    }

    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)token,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSLog(@"URLDecoded后的token== %@", decodedString);

//    token = @"qtejl54l1Y7fpye//ml8MUjGoZhD4ld2MINFTlvxb2ZCz8oSbC//HSqORjPwUyXd/W9krV2pCBETtYahoIqi/N6zcR2j4Z+r";
    
    [[RCIM sharedRCIM] connectWithToken:decodedString   success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        //设置当前用户信息
        [self configUserInfoWithUserID:userId];
        
        
        //设置用户信息源和群组信息源

        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
       
       
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", status);
        //重新获取token
//        [self connectRCServer];

        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        //重新获取token
        
//        [self connectRCServer];

    }];
}

#pragma mark - 配置 当前用户信息 （昵称、头像）
-(void)configUserInfoWithUserID:(NSString *)userId{
    
    RCUserInfo *userRC = [[RCUserInfo alloc]initWithUserId:userId name:UserInfo.name portrait:@"http://www.qqzhi.com/uploadpic/2014-09-26/064131688.jpg"];
    [RCIM sharedRCIM].currentUserInfo = userRC;
    [RCIMClient sharedRCIMClient].currentUserInfo = userRC;
    [[RCIM sharedRCIM] setReceiveMessageDelegate:[XABChatTool getInstance]];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    
}


#pragma mark RCIMUserInfoDataSource

//根据 聊天的列表  对方的userID  配置 对方的姓名、头像
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    if ([userId isEqualToString:@"123"]) {
        
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"小明" portrait:@"http://img2.woyaogexing.com/2017/04/23/5ed38c1314635aea!400x400_big.jpg"];
        return completion(userInfo);
    }else if ([userId isEqualToString:@"321"]){
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"小微" portrait:@"http://img2.woyaogexing.com/2017/04/24/7d807ccba1f4bab0!400x400_big.jpg"];
        return completion(userInfo);

    }
    return completion(nil);
}


#pragma mark - 获取群组信息并显示

-(void)configGroupInfoWithGroupId:(NSString *)groupId{
    
    [self getGroupInfoWithGroupId:groupId completion:^(RCGroup *groupInfo) {
       
        if (groupId) {
            
        }
    }];
}
/*!   有群组 消息来了 会调用 此方法，返回也会刷新
 获取群组信息
 
 @param groupId                     群组ID
 @param completion                  获取群组信息完成之后需要执行的Block
 @param groupInfo(in completion)    该群组ID对应的群组信息
 @discussion SDK通过此方法获取用户信息并显示，请在completion的block中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    
    for (NSInteger i = 0; i < self.groupsArray.count; i++) {
        RCGroup *aGroup = self.groupsArray[i];
        if ([groupId isEqualToString:aGroup.groupId]) {
            completion(aGroup);
            break;
        }
    }
    
}




#pragma mark - 校内群讨论群列表接口
-(void)getChatSchoolGroupWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    NSLog(@"校内群讨论群列表接口 传入的参数 == %@",dict);

    __block NSArray *sourceArray = nil;
    __block NSError *error = nil;
    [XABChatSchoolGroupRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"校内群讨论群列表接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];

        if (response.code == CODE_SUCCESS) {
            
            sourceArray = [XABChatSchoolGroupModel mj_objectArrayWithKeyValuesArray:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceArray, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"校内群讨论群列表接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);

    }];
}
#pragma mark - 校内群讨论群 融云组用户接口
-(void)getChatSchoolGroupMembersWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    NSLog(@"校内群讨论群融云组用户接口 传入的参数 == %@",dict);
    
    __block NSArray *sourceArray = nil;
    __block NSError *error = nil;
    [XABChatSchoolGroupMembersRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"校内群讨论群融云组用户接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            sourceArray = [XABChatSchoolGroupMembersModel mj_objectArrayWithKeyValuesArray:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceArray, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"校内群讨论群融云组用户接口口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];
};


#pragma mark - 班级群-列表接口
-(void)getChatClassGroupWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    
    __block NSArray *sourceArray = nil;
    __block NSError *error = nil;
    [XABChatClassGroupRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"班级群列表接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            sourceArray = [XABChatClassGroupModel mj_objectArrayWithKeyValuesArray:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceArray, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级群列表接口列表接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];
}

#pragma mark - 班级 - 班级老师
/*
 mobilePhone	是	string	用户手机
 classId	    是	string	班级id
 */
-(void)getClassGradeTeachersWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    NSLog(@"班级老师接口传入参数==%@",dict);
    
    __block NSArray *sourceArray = nil;
    __block NSError *error = nil;
    [XABChatClassGradeTeachersRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"班级老师接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            sourceArray = [XABChatClassGradeTeachersModel mj_objectArrayWithKeyValuesArray:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceArray, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级老师接口列表接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];
    
};

#pragma mark - 班级 - 班级老师 - 详情
-(void)getClassGradeTeachersDetailWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(XABChatClassGradeTeachersDetailModel *model,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    NSLog(@"班级老师- 详情 接口传入参数==%@",dict);
    
    __block XABChatClassGradeTeachersDetailModel *detailModel = nil;
    __block NSError *error = nil;
    [XABChatClassGradeTeachersDetailRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"班级老师-详情 接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            detailModel = [XABChatClassGradeTeachersDetailModel mj_objectWithKeyValues:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(detailModel, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级老师- 详情 接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];

};

#pragma mark - 班级 - 班级学生
-(void)getClassGradeStudentsWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock{
    NSDictionary *dict = [model toJSON];
    
    __block NSArray *sourceArray = nil;
    __block NSError *error = nil;
    [XABChatClassGradeStudentsRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"班级学生列表接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            sourceArray = [XABChatClassGradeStudentsModel mj_objectArrayWithKeyValuesArray:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceArray, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级学生列表接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];
    
};
#pragma mark - 班级 - 班级家长
-(void)getClassGradePatriarchWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    
    NSLog(@"班级家长列表接口==%@",dict);
    
    __block NSArray *sourceArray = nil;
    __block NSError *error = nil;
    [XABChatClassGradeParentsRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        NSLog(@"班级家长列表接口==%@",request);
        
        NSLog(@"班级家长列表接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            sourceArray = [XABChatClassGradeStudentsParentsModel mj_objectArrayWithKeyValuesArray:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceArray, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级群列表接口列表接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];
    
};

#pragma mark - 班级 - 班级家长 - 详情
-(void)getClassGradeParentsDetailWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(XABChatClassGradeStudentsParentsDetailModel *model,NSError *error))resultBlock{
    
    NSDictionary *dict = [model toJSON];
    NSLog(@"班级家长- 详情 接口传入参数==%@",dict);
    
    __block XABChatClassGradeStudentsParentsDetailModel *parentDetailModel = nil;
    __block NSError *error = nil;
    [XABChatClassGradeParentsDetailRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"班级家长-详情 接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            parentDetailModel = [XABChatClassGradeStudentsParentsDetailModel mj_objectWithKeyValues:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(parentDetailModel, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级家长- 详情 接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];
    
};


#pragma mark - 清楚 融云 的缓存信息 （用户缓存、群组缓存）
/*!
 清空SDK中所有的用户信息缓存
 */
- (void)clerRCUserInfo{
    
    [[RCIM sharedRCIM] clearUserInfoCache];
}

/*!
 清空SDK中所有的群组信息缓存
 */
- (void)clearRCGroupInfoCache{
    
    [[RCIM sharedRCIM] clearGroupInfoCache];
}









/*******************************************************************************************************************/
#pragma mark - 课程表
-(void)getClassCurriculumsWithRequestModel:(XABParamModel *)model esultBlock:(void (^)( XABClassGradeCurriculumModel*model,NSError *error))resultBlock
{
    
    NSDictionary *dict = [model toJSON];
    
    NSLog(@"班级课程表 参数==%@",dict);

    __block XABClassGradeCurriculumModel*sourceModel = nil;
    __block NSError *error = nil;
    [XABClassGradeCurriculumRequest requestDataWithParameters:dict headers:Token successBlock:^(BaseDataRequest *request) {
        
        NSLog(@"班级课程表接口==%@",request.responseObject);
        XABResponseModel *response = [XABResponseModel responseFromKeyValues:request.responseObject];
        
        if (response.code == CODE_SUCCESS) {
            
            sourceModel = [XABClassGradeCurriculumModel mj_objectWithKeyValues:response.data];
            
        } else {
            if (response.message.length == 0) { response.message = @"服务器未成功返回数据!"; }
            error = [NSError errorWithDomain:@"error" code:-100 userInfo:[NSDictionary dictionaryWithObject:response.message forKey:@"error"]];
        }
        
        if (resultBlock) resultBlock(sourceModel, error);
        
    } failureBlock:^(BaseDataRequest *request) {
        NSLog(@"班级课程接口-ERROR==%@",request.error);
        if (resultBlock) resultBlock(nil, request.error);
        
    }];

};



@end
