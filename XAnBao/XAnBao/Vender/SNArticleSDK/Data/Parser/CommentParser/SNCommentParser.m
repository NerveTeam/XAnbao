//
//  CommentParser.m
//  SinaNews
//
//  Created by frost on 14-12-5.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "SNCommentParser.h"

@implementation SNCommentParser

- (SNComment *)commentWithDictionary:(NSDictionary *)obj
{
    SNComment *comment = [[SNComment alloc] init];
    comment.parentId = [[obj objectForKeySafely:@"parent"] longValue];
    comment.mId = [[obj objectForKeySafely:@"mid"] longValue];
    comment.userName = [obj objectForKeySafely:@"userName"];
    comment.content = [obj objectForKeySafely:@"commentContent"];
    comment.publishDate = [NSDate dateFromTimestamp:[obj objectForKeySafely:@"time"]];
    comment.supportNum = [[obj objectForKeySafely:@"support"] intValue];
    comment.iconURL = [obj objectForKeySafely:@"headIcon"];
    comment.level = [NSString stringWithFormat:@"%d", [[obj objectForKeySafely:@"level"] intValue]];
    comment.source = [obj objectForKeySafely:@"userType"];
    comment.area = [obj objectForKeySafely:@"area"];
    comment.wbVerified = [[NSString stringWithFormat:@"%@", [obj objectForKeySafely:@"wbVerified"]] intValue];
    comment.wbUserID = [[obj objectForKeySafely:@"uid"] longValue];
    if ([obj objectForKeySafely:@"wbDescription"] != nil) {
        comment.wbVerifyInfo = [NSString stringWithFormat:@"%@", [obj objectForKeySafely:@"wbDescription"]];
    } else {
        comment.wbVerifyInfo = nil;
    }
    comment.wbVerifiedType = [[NSString stringWithFormat:@"%@", [obj objectForKeySafely:@"wbVerifiedType"]] intValue];
    return comment;
}

//评论列表
- (SNCommentList*)parseCommentList:(NSDictionary*) dict
{
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if ( self.hasError  )
    {
        return nil;
    }
    
    SNCommentList *commentList = [[SNCommentList alloc] init];
    
    // 5.0 接口重构进行修改,更新字段名
    commentList.newsTitle = [data objectForKeySafely:@"newsTitle"];
    commentList.newsUrl = [data objectForKeySafely:@"newsUrl"];
    commentList.commentStatus = [data objectForKeySafely:@"cmntStatus"];
    commentList.commentCount = SNNumber([data objectForKeySafely:@"cmntCount"], @0);
    NSArray * commentListArray = [data objectForKeySafely:@"cmntHotList"];
        /**
         "parent": "50EEB460-A492135-9B4AF405-920-894",               ----(string),叠楼梯中被回复的原评论编号
         "mid": "50EECB45-D3893B17-0-920-91F",                        ----(string),当前评论的编号
         "nick": "手机用户",                                           ----(string),昵称
         "content": "哦",                                             ----(string),内容
         "time": 1357826886,                                          ----(int),时间
         "agree" : "",                                                ----(string),支持数
         "wb_profile_img": ""
         */
    [commentListArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SNCommentItem * commentItem = [[SNCommentItem alloc] init];
        commentItem.comment = [self commentWithDictionary:obj];
        
        NSArray * replyList = [obj objectForKeySafely:@"replylist"];
        [replyList enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
            [commentItem.replyList addObject:[self commentWithDictionary:dict]];
        }];
        
        [commentList.hotComments addObject:commentItem];
    }];
    
    commentListArray = [data objectForKeySafely:@"cmntlist"];
    /**
     "parent": "50EEB460-A492135-9B4AF405-920-894",               ----(string),叠楼梯中被回复的原评论编号
     "mid": "50EECB45-D3893B17-0-920-91F",                        ----(string),当前评论的编号
     "nick": "手机用户",                                           ----(string),昵称
     "content": "哦",                                             ----(string),内容
     "time": 1357826886,                                          ----(int),时间
     "agree" : "",                                                ----(string),支持数
     "wb_profile_img": ""
     */
    [commentListArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SNCommentItem * commentItem = [[SNCommentItem alloc] init];
        commentItem.comment = [self commentWithDictionary:obj];
        
        NSArray * replyList = [obj objectForKeySafely:@"replylist"];
        [replyList enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
            [commentItem.replyList addObject:[self commentWithDictionary:dict]];
        }];
        
        [commentList.newestComments addObject:commentItem];
    }];
    
    commentListArray = [data objectForKeySafely:@"vlist"];
    [commentListArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SNCommentItem * commentItem = [[SNCommentItem alloc] init];
        commentItem.comment = [self commentWithDictionary:obj];
        
        NSArray * replyList = [obj objectForKeySafely:@"replylist"];
        [replyList enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
            [commentItem.replyList addObject:[self commentWithDictionary:dict]];
        }];
        
        [commentList.vComments addObject:commentItem];
    }];
    
    return commentList;
}

@end
