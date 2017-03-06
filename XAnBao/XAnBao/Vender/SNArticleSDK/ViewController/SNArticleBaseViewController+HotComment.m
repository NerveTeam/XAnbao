//
//  ArticleViewController+HotComment.m
//  SinaNews
//
//  Created by li na on 13-6-12.
//  Copyright (c) 2013年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-4-28 16:00~16:10 ARC Refactor
//
//  Reviewd by zhiping3 on 15-4-29 15:30~16:00
//

#import "SNArticleBaseViewController+HotComment.h"
#import <objc/runtime.h>
#import "NSDate+SNArticle.h"

#define kArticleViewController_HotView  @"kArticleViewController_HotView"

@implementation SNArticleBaseViewController (HotComment)

@dynamic hotComments;
@dynamic commentStatus;

#pragma mark Dynamic Properties

- (void)setFamousComments:(NSArray *)famousComments
{
    objc_setAssociatedObject(self, @"SNFamousComment", famousComments, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)famousComments
{
    return objc_getAssociatedObject(self, @"SNFamousComment");
}

- (void)setHotComments:(NSArray *)hotComments
{
    objc_setAssociatedObject(self, @"SNHotComment", hotComments, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)hotComments
{
    return objc_getAssociatedObject(self, @"SNHotComment");
}

- (void)setCommentStatus:(NSNumber *)commentStatus
{
    objc_setAssociatedObject(self, @"SNCommentStatus", commentStatus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)commentStatus
{
    return objc_getAssociatedObject(self, @"SNCommentStatus");
}

#pragma mark - JS

- (NSString *)getCommentJS:(SNCommentType)commentType
{
    NSString *htmlNodeId;
    NSArray *commentList;
    NSString *title;
    NSString *type;
    switch (commentType) {
        case SNCommentTypeFamous:
        {
            htmlNodeId = @"people_comments";
            commentList = self.famousComments;
            title = @"大V评论";
            type = @"people_comments";
        }
        break;
        case SNCommentTypeHot:
        {
            htmlNodeId = @"hot_comments";
            commentList = self.hotComments;
            title = @"热门评论";
            type = @"hot_comments";
        }
        break;
        default:
        return @"";
    }
    
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendFormat:@"var uls = document.getElementById('%@');",htmlNodeId];
    [javascript appendString:@"uls.innerHTML = '"];
    [javascript appendFormat:@"<div class=\"M_tag\"><span>%@</span></div>",title];
    [javascript appendFormat:@"<ul>"];
    
    for(int i = 0;i<[commentList count]; i++)
    {
        SNCommentItem *commentItem = [commentList objectAtIndexSafely:i];
        SNComment *comment = commentItem.comment;
        
        // v标示
        NSString *icon = @"";
        if(comment.wbVerified == 1)
        {
            if(comment.wbVerifiedType == 0)
            {
                icon = @"images/v_y.png";
            }
            else
            {
                icon = @"images/v_b.png";
            }
        }
        
        // 发布日期，NSDateFormatter耗时
        NSString *publishDateDescription = [comment.publishDate commentDateString];
        
        [javascript appendFormat:@"<li>"];
        [javascript appendFormat:@"<div class=\"user\">"];
        if(comment.iconURL)
        {
            [javascript appendFormat:@"<img src=\"%@\" width=\"25\" height=\"25\">",comment.iconURL];
        }
        if(comment.wbVerified != kWeiboTypeUnknown)
        {
            [javascript appendFormat:@"<span class=\"icon\">"];
            [javascript appendFormat:@"<img src=\"%@\" data-src=\"\" width=\"32\" height=\"32\" style=\"\">",icon];
            [javascript appendFormat:@"</span>"];            
        }
        [javascript appendFormat:@"</div>"];
        
        [javascript appendFormat:@"<div class=\"userInfo\">"];
        [javascript appendFormat:@"<div class=\"tit\">%@</div>",comment.userName];
        [javascript appendFormat:@"<div class=\"time\">%@</div>",publishDateDescription];
        [javascript appendFormat:@"</div>"];
        
        [javascript appendFormat:@"<div class=\"mark\">%@</div>",comment.wbVerifyInfo?comment.wbVerifyInfo:@""];
        
        //显示多层楼
//        if([commentItem.replyList count] > 0)
//        {
//            [javascript appendFormat:@"<div class=\"replay\" data-role=\"hot_cmnt_floor_box\">"];
//            
//            for(int i = 0;i < commentItem.replyList.count;i++ )
//            {
//                SNComment *originalComment = [commentItem.replyList objectAtIndex:i];
//                [javascript appendFormat:@"<div class=\"floor\" data-role=\"hot_cmnt_floor\">"];
//                [javascript appendFormat:@"<p class=\"f_tit\">%@<span><txt>%d</txt>楼</span></p>",originalComment.userName,i+1];
//                [javascript appendFormat:@"<div>"];
//                [javascript appendFormat:@"<p class=\"txt f_txt\" textlimit-role=\"text\" ui-textlimit=\"\">%@</p>",originalComment.content];
//                [javascript appendFormat:@"<p class=\"txt\" style=\"display:none;\">%@</p>",originalComment.content];
//                [javascript appendFormat:@"<p class=\"f_more\" click-type=\"comment-content-all\" style=\"display:none;\">全文</p>"];
//                [javascript appendFormat:@"</div>"];
//                [javascript appendFormat:@"</div>"];
//            }
//        }
//        
        if([commentItem.replyList count] > 0)
        {
            SNComment *originalComment = [commentItem.replyList firstObject];
            
            [javascript appendFormat:@"<div class=\"floor\">"];
            [javascript appendFormat:@"<p class=\"f_tit\">%@<span><txt>1</txt>楼</span></p>",originalComment.userName];
            [javascript appendFormat:@"<div>"];
            [javascript appendFormat:@"<p class=\"txt f_txt\" textlimit-role=\"text\" ui-textlimit=\"\">%@</p>",originalComment.content];
            [javascript appendFormat:@"<p class=\"txt\" style=\"display:none;\">%@</p>",originalComment.content];
            [javascript appendFormat:@"<p class=\"f_more\" click-type=\"comment-content-all\" style=\"display:none;\">全文</p>"];
            [javascript appendFormat:@"</div>"];
            [javascript appendFormat:@"</div>"];
        }
        [javascript appendFormat:@"<div class=\"js_floor\">"];
        [javascript appendFormat:@"<div class=\"txt f_txt\" textlimit-role=\"text\" ui-textlimit=\"\">%@</div>",comment.content];
        [javascript appendFormat:@"<div class=\"txt\" style=\"display:none;\">%@</div>",comment.content];
        [javascript appendFormat:@"<p class=\"f_more\" click-type=\"comment-content-all\" style=\"display:none;\">全文</p>"];
        [javascript appendFormat:@"</div>"];
        
        [javascript appendFormat:@"<div class=\"source\">"];
        NSString *sourceString = @"";
        if(comment.source)
        {
            sourceString = [NSString stringWithFormat:@"来自%@",comment.source];
        }
        
        NSString *areaString = @"";
        if(comment.area)
        {
            //默认样式
            areaString = [NSString stringWithFormat:@"<em></em><b>%@</b>",comment.area] ;
            
            //若有来源
            if([sourceString length] > 0)
            {
                //若地理信息长度大于7
                if([comment.area length] > 7)
                {
                    areaString = [NSString stringWithFormat:@"<em></em><b>%@...</b>",[comment.area substringToIndex:6]] ;
                }
            }
            else
            {
                //若地理信息长度大于11
                if([comment.area length] > 11)
                {
                    areaString = [NSString stringWithFormat:@"<em></em><b>%@...</b>",[comment.area substringToIndex:9]] ;
                }
            }
        }
        
        [javascript appendFormat:@"<span class=\"icon_location\">%@%@</span>",areaString,sourceString];
        [javascript appendFormat:@"<span class=\"icon_reply\" ui-link=\"method:comment_reply;type:%d;index:%d\"><em></em>回复</span>",commentType,i];
        [javascript appendFormat:@"<span data-pl=\"comment-like\" class=\"icon_praise\" click-type=\"comment-like\" ui-param=\"pos:1;type:%d;index:%d;mid:%d;\"><em></em>%@</span>",commentType,i,comment.mId,[NSString numberToXWan:comment.supportNum]];
        [javascript appendFormat:@"</div>"];
        [javascript appendFormat:@"</li>"];
    }
    
    [javascript appendFormat:@"</ul>"];
    
    //添加[更多]
    [javascript appendString:@"<div class=\"M_more\" ui-button=\"\" ui-link=\"method:hotCommentClick;\"><span>查看更多评论</span></div>"];
    
    [javascript appendString:@"';"];
    [javascript appendFormat:@"window.listener.trigger(\"content-load-success\",{data:{type:\"%@\"}});",type];
    return javascript;
}

//尝试通过JS刷新评论
- (void)refreshCommentUsingJS
{
    //名人评论
    if ([self.famousComments count] > 0)
    {
        NSString *javascript = [self getCommentJS:SNCommentTypeFamous];
        
        [self executeJs:javascript];
    }
    //热门评论
    else if ([self.hotComments count] > 0)
    {
        NSString *javascript = [self getCommentJS:SNCommentTypeHot];
        
        [self executeJs:javascript];
    }
}

@end
