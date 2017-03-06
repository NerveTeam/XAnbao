//
//  Comment.m
//  SinaNews
//
//  Created by na li on 12-6-13.
//  Copyright (c) 2012年 sina. All rights reserved.
//


#import "SNComment.h"

@implementation SNCommentResult

@end

@implementation SNCommentList

- (void)dealloc
{

}

- (id)init
{
    self = [super init];
    if (self) {
        _hotComments = [[NSMutableArray alloc] init];
        _newestComments = [[NSMutableArray alloc] init];
        _vComments = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end

#define kCommentSet_Count      @"kCommentSet_Count"  
#define kCommentSet_Id         @"kCommentSet_Id"

@implementation SNCommentSet

- (void)dealloc
{

}

/*
 * encode  and coder
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.commentSetId forKey:kCommentSet_Id];
    [aCoder encodeInteger:self.commentSetCount forKey:kCommentSet_Count];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.commentSetId = [aDecoder decodeObjectForKey:kCommentSet_Id];
        self.commentSetCount = [aDecoder decodeIntegerForKey:kCommentSet_Count];

    }
    return self;
}

@end

@implementation SNComment

- (void)dealloc
{
    
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = NO;
    
    if ([object isKindOfClass:[SNComment class]]) {
        if (object == self) {
            isEqual = YES;
        } else {
            SNComment *comment = (SNComment *)object;
            if ([self.userName isEqual:comment.userName]
                && [self.content isEqual:comment.content]
                && [self.publishDate isEqualToDate:comment.publishDate]) {
                isEqual = YES;
            }
        }
    }
    
    return isEqual;
}

@end

@implementation SNCommentItem

- (void)dealloc
{

}

- (NSMutableArray *)replyList
{
    if (_replyList == nil) {
        _replyList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return _replyList;
}

@end


@implementation SNCommentAboutMeItem

- (void)dealloc
{
}

@end

