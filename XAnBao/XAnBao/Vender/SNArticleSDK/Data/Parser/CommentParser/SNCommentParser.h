//
//  CommentParser.h
//  SinaNews
//
//  Created by frost on 14-12-5.
//  Copyright (c) 2014年 sina. All rights reserved.
//
//============================================================
//  Modified History
//  Modified by liming20 on 15-4-30 ARC Refactor
//
//   Reviewd by wangxiang5 on 15-5-6 14:30--15:00
//
#import <Foundation/Foundation.h>
#import "SNParser.h"
#import "SNComment.h"

@interface SNCommentParser : SNParser

//评论列表
- (SNCommentList*)parseCommentList:(NSDictionary*) dic;

@end
