//
//  Poll.m
//  SinaNews
//
//  Created by wangjianfei on 14-7-30.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SNPoll.h"
#import "NSDictionary+SNArticle.h"
#import "SNCommonMacro.h"

@implementation SNPollAnswer

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_aid forKey:@"aid"];
    [encoder encodeObject:_percent   forKey:@"percent"];
    [encoder encodeObject:_name      forKey:@"name"];
    [encoder encodeObject:_count     forKey:@"count"];
    [encoder encodeObject:_realCount forKey:@"realCount"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.aid   = [decoder decodeObjectForKey:@"aid"];
        self.percent   = [decoder decodeObjectForKey:@"percent"];
        self.name      = [decoder decodeObjectForKey:@"name"];
        self.count     = [decoder decodeObjectForKey:@"count"];
        self.realCount = [decoder decodeObjectForKey:@"realCount"];
    }
    
    return self;
}

@end

@implementation SNPollQuestion

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_qid     forKey:@"qid"];
    [encoder encodeObject:_state   forKey:@"state"];
    [encoder encodeObject:_name    forKey:@"name"];
    [encoder encodeObject:_answers forKey:@"answers"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.qid     = [decoder decodeObjectForKey:@"qid"];
        self.state   = [decoder decodeObjectForKey:@"state"];
        self.name    = [decoder decodeObjectForKey:@"name"];
        self.answers = [decoder decodeObjectForKey:@"answers"];
    }
    
    return self;
}

@end

@implementation SNPoll

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeBool:_isPKStyle forKey:@"isPKStyle"];
    [encoder encodeObject:_pollNumber forKey:@"pollNumber"];
    [encoder encodeObject:_vid        forKey:@"vid"];
    [encoder encodeObject:_pid        forKey:@"pid"];
    [encoder encodeObject:_name       forKey:@"name"];
    [encoder encodeObject:_questions  forKey:@"questions"];
    [encoder encodeBool:_polled       forKey:@"polled"];
    [encoder encodeObject:_allJsonData       forKey:@"allJsonData"];
    [encoder encodeBool:_pollstate       forKey:@"pollState"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.polled    = [decoder decodeBoolForKey:@"polled"];
        self.isPKStyle    = [decoder decodeBoolForKey:@"isPKStyle"];
        self.pollNumber       = [decoder decodeObjectForKey:@"pollNumber"];
        self.pid       = [decoder decodeObjectForKey:@"pid"];
        self.vid       = [decoder decodeObjectForKey:@"vid"];
        self.name      = [decoder decodeObjectForKey:@"name"];
        self.questions = [decoder decodeObjectForKey:@"questions"];
        self.allJsonData = [decoder decodeObjectForKey:@"allJsonData"];
        self.pollstate    = [decoder decodeBoolForKey:@"pollState"];
    }
    
    return self;
}

-(void)refreshWithResult:(NSArray *)pollresult
{
    NSArray *questions = [SNPoll parserQuestionsWithDic:pollresult];
    self.questions = questions;
}

+(NSArray *)parserQuestionsWithDic:(NSArray *)questions
{
    NSMutableArray *allQuestions = [NSMutableArray array];
    for (NSDictionary *aQuestion in questions) {
        SNPollQuestion *pollQue = [[SNPollQuestion alloc] init];
        pollQue.qid =[NSString stringWithFormat:@"%@", [aQuestion objectForKeySafely:@"questionId"]];
        pollQue.name = [NSString stringWithFormat:@"%@", [aQuestion objectForKeySafely:@"question"]];
        pollQue.state = [NSString stringWithFormat:@"%@", [aQuestion objectForKeySafely:@"questionState"]];
        
        // 获取answers
        NSArray *answers = [aQuestion objectForKey:@"answer"];
        NSMutableArray *allAnswer = [NSMutableArray array];
        for (NSDictionary *aAnswer in answers) {
            SNPollAnswer *pollAns = [[SNPollAnswer alloc] init];
            pollAns.aid = [NSString stringWithFormat:@"%@", [aAnswer objectForKeySafely:@"answerId"]];
            pollAns.name = [NSString stringWithFormat:@"%@", [aAnswer objectForKeySafely:@"name"]];
            pollAns.percent = [NSString stringWithFormat:@"%@", [aAnswer objectForKeySafely:@"percent"]];
            pollAns.count = [NSString stringWithFormat:@"%@", [aAnswer objectForKeySafely:@"varCount"]];
            pollAns.realCount = [NSString stringWithFormat:@"%@", [aAnswer objectForKeySafely:@"trustDigit"]];
            [allAnswer addObject:pollAns];
            SN_SAFE_ARC_RELEASE(pollAns);
        }
        pollQue.answers = [NSArray arrayWithArray:allAnswer];
        [allQuestions addObject:pollQue];
        SN_SAFE_ARC_RELEASE(pollQue);
    }
    return allQuestions;
}

@end
