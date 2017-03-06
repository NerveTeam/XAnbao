//
//  Comment.h
//  SinaNews
//
//  Created by na li on 12-6-13.
//  Copyright (c) 2012年 sina. All rights reserved.
//  评论，只有最后可以看的到正文的有评论

//============================================================
//  Modified History
//  Modified by liming20 on 15-4-30 ARC Refactor
//
//  Reviewd by wangxiang5 on 15-5-6 14:30--15:00
//

#import <UIKit/UIKit.h>

@interface SNCommentResult : NSObject

@property (nonatomic, assign) BOOL  comment;
@property (nonatomic, assign) BOOL  share;

@end

@interface SNCommentList : NSObject

@property (nonatomic, strong) NSString  *newsTitle;
@property (nonatomic, strong) NSString  *newsUrl;

@property (nonatomic, strong) NSMutableArray   *hotComments;
@property (nonatomic, strong) NSMutableArray   *newestComments;
@property (nonatomic, strong) NSMutableArray   *vComments; //大V评论

@property (nonatomic, strong) NSNumber *commentStatus; //-1：评论关闭；0：正常

@property (nonatomic, strong) NSNumber *commentCount;   // 评论数

@end


#pragma mark - CommentSet
@interface SNCommentSet : NSObject <NSCoding>


@property (nonatomic,assign) NSInteger  commentSetCount;
@property (nonatomic,strong) NSString * commentSetId;

@end

#pragma mark - Comment
@interface SNComment : NSObject


@property (nonatomic, assign) NSInteger  parentId;
@property (nonatomic, assign) NSInteger  mId;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *iconURL;
@property (nonatomic, strong) NSString  *source;
@property (nonatomic, strong) NSString  *level;
@property (nonatomic, strong) NSString  *area;//v4.4,地点
@property (nonatomic, assign) NSInteger wbVerifiedType;//微博认证类型（0：名人，1：政府，2：企业，3：媒体，4：校园，5：网站，6：应用，7：团体，其中0是黄V，1～7是蓝V）
@property (nonatomic, assign) NSInteger wbVerified;//1是，0否
@property (nonatomic, strong) NSString  *wbVerifyInfo;//认证信息
@property (nonatomic, assign) NSInteger  wbUserID;//认证信息
@property (nonatomic, assign) NSInteger  supportNum;
@property (nonatomic, strong) NSDate    *publishDate;
@property (nonatomic, assign) NSInteger isXiaoBian;              // 是否是小编回复（特殊标签显示）

@end

@interface SNCommentItem : NSObject

@property (nonatomic, strong) SNComment           *comment;
@property (nonatomic, strong) NSMutableArray    *replyList;

@end

@interface SNCommentAboutMeItem : NSObject

//文章的标题。
@property (nonatomic, strong) NSString  *abstractTitle;

//我的评论显示的标题规则。
//"【原文】+ 文章的标题"
@property (nonatomic, strong) NSString  *newsTitle;
@property (nonatomic, strong) NSString  *newsId;
@property (nonatomic, strong) NSString  *newsUrl;
@property (nonatomic, strong) NSString  *commentSetId;

@property (nonatomic, strong) SNCommentItem       *commentItem;

@end

