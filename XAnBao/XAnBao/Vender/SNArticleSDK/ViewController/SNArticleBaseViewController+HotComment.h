//
//  ArticleViewController+HotComment.h
//  SinaNews
//
//  Created by li na on 13-6-12.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import "SNArticleBaseViewController.h"

typedef enum {
    SNCommentTypeFamous = 1,
    SNCommentTypeHot = 2
} SNCommentType;

@interface SNArticleBaseViewController (HotComment)

@property (nonatomic,retain) NSArray * famousComments;
@property (nonatomic,retain) NSArray * hotComments;
@property (nonatomic, retain) NSNumber *commentStatus;//-1,不可评论; 0,可以评论

- (void)refreshCommentUsingJS;

@end
