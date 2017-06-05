//
//  XABChatTool.h
//  XAnBao
//
//  Created by 韩森 on 2017/4/22.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import "XABParamModel.h"


//#define RCAppKey @"vnroth0krtt2o"   //正式：z3v5yqkbvyyd0  测试2：z3v5yqkbvyyd0  生产环境： vnroth0krtt2o       babysitter 开发环境 8brlm7uf8p353

@interface XABChatTool : NSObject

@property (nonatomic, strong) NSMutableArray *friendsArray;//好友数组
@property (nonatomic, strong) NSMutableArray *groupsArray; //群组数组

+ (instancetype)getInstance;

//初始化融云SDK
-(void)initWithRCIM;

//获取到从服务端获取的 Token，通过 RCIM 的单例 建立与服务器的连接
-(void)connectRCServer;


-(void)configGroupInfoWithGroupId:(NSString *)groupId;

#pragma mark - 校内群讨论群列表接口
-(void)getChatSchoolGroupWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock;

#pragma mark - 校内群讨论群 融云组用户接口
-(void)getChatSchoolGroupMembersWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock;

#pragma mark - 班级群-列表接口
-(void)getChatClassGroupWithRequestModel:(XABParamModel *)model resultBlock:(void (^)(NSArray *sourceArray,NSError *error))resultBlock;






#pragma mark - 清楚 融云 的缓存信息 （用户缓存、群组缓存）
/*!
 清空SDK中所有的用户信息缓存
 */
- (void)clerRCUserInfo;
/*!
 清空SDK中所有的群组信息缓存
 */
- (void)clearRCGroupInfoCache;


/*******************************************************************************************************************/
#pragma mark - 课程表
-(void)getClassCurriculumsWithRequestModel:(XABParamModel *)model esultBlock:(void (^)(XABClassGradeCurriculumModel*model,NSError *error))resultBlock;



@end
