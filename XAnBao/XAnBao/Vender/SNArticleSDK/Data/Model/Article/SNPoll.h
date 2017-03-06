//
//  Poll.h
//  SinaNews
//
//  Created by wangjianfei on 14-7-30.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNPollAnswer : NSObject

@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *percent;
@property (nonatomic, strong) NSString *count;      //显示用
@property (nonatomic, strong) NSString *realCount;

@end

@interface SNPollQuestion : NSObject

@property (nonatomic, strong) NSString *qid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state; //0多选；1单选
@property (nonatomic, strong) NSArray *answers;

@end

//一个投票会包含几个问题
@interface SNPoll : NSObject

@property (nonatomic, strong) NSString *pollNumber;//参与人数
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *vid; //vote id
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, assign) BOOL polled;//是否已经参与投票
@property (nonatomic, assign) BOOL isPKStyle;//是否已经参与投票
@property (nonatomic, strong) NSString *allJsonData;
@property (nonatomic, assign) BOOL pollstate;//是否展示该投票

-(void)refreshWithResult:(NSArray *)dic;

+(NSArray *)parserQuestionsWithDic:(NSArray *)dic;

@end
