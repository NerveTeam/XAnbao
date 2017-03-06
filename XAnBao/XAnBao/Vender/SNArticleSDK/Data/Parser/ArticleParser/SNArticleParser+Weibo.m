//
//  ArticleParser+Weibo.m
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser+Weibo.h"
#import "SNArticleParser+Image.h"
#import "SNArticleManager+Tag.h"

@implementation SNArticleParser (Weibo)

#pragma mark - 微博

//单条微博
- (void)handleSingleWeiboListInOriginalArticle:(SNArticle *)article
{
    if(article.weiboDelete)
    {
        //替换内容为 微博被删除
        article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_SINGLEWEIBO_MODULE,1] withString:[SNArticleParser weiboDeletedHtml]];
        return;
    }
    
    int idx = 0;
    for (SNArticleWeibo * weibo in article.singleWeiboList )
    {
        NSString *singleWeiboHtml = @"";
        //微博正文
        if([article.category isEqualToString:ArticleCategoryWeibo])
        {
            singleWeiboHtml = [SNArticleParser singleWeiboHtmlWithWeiboArticleWeibo:weibo inArticle:article groupIndex:idx];
        }
        //普通正文
        else
        {
            singleWeiboHtml = [SNArticleParser singleWeiboHtmlWithArticleWeibo:weibo inArticle:article groupIndex:idx];
        }
        
        article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_SINGLEWEIBO_MODULE,idx+1] withString:singleWeiboHtml];
        
        idx++;
    }
}

- (SNArticleWeibo *)getSingleWeiboFromDict:(NSDictionary *)dict
{
    if(!dict)
        return nil;
    
    if(![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSDictionary *weiboDict = nil;
    SNArticleWeibo *originalArticleWeibo = [[SNArticleWeibo alloc] init];
    
    //是否有转发的微博存在
    BOOL hasRetweeted = NO;
    
    if([dict valueForKeySafely:@"retweetedStatus"])
    {
        if([[dict valueForKeySafely:@"retweetedStatus"] isKindOfClass:[NSDictionary class]])
        {
            hasRetweeted = YES;
        }
    }
    
    //若被转发的微博存在
    if(hasRetweeted)
    {
        //微博主体为被转发的微博
        weiboDict = [dict valueForKeySafely:@"retweetedStatus"];
        
        //转发的微博的内容为当前dict
        SNArticleWeibo *retweetWeibo = [[SNArticleWeibo alloc]init];
        retweetWeibo.weiboId = SNString([dict objectForKey:@"weiboId"], @"");
        retweetWeibo.text = SNString([dict objectForKey:@"text"], @"");
        retweetWeibo.picUrl = SNString([dict objectForKey:@"pic"], @"");
        NSDate * date = [NSDate dateFromTimestamp:[weiboDict objectForKeySafely:@"pubDate"]];
        retweetWeibo.pubDate = [date stringWithTimeStampNoSecFormat];
        retweetWeibo.wapUrl = [SNString([dict objectForKey:@"wapUrl"], @"") htmlEntityDecoding];
        retweetWeibo.weiboUserId = SNString([dict valueForKeyPathSafely:@"user.id"], @"") ;
        retweetWeibo.weiboUserName = SNString([dict valueForKeyPathSafely:@"user.name"], @"") ;
        retweetWeibo.weiboProfileImageUrl = [SNString([dict valueForKeyPathSafely:@"user.profileImageUrl"], @"") htmlEntityDecoding];
        retweetWeibo.pics = [dict valueForKeyPathSafely:@"pics"];
        retweetWeibo.isDeleted = SNBool([dict valueForKeyPathSafely:@"deleted"], NO);
        retweetWeibo.weiboType = SNInt([dict valueForKeyPathSafely:@"user.verifiedType"], -1);
        originalArticleWeibo.reweetWeibo = retweetWeibo;
    }
    else
    {
        //微博的主体为当前微博
        weiboDict = dict;
    }
    originalArticleWeibo.weiboId = SNString([weiboDict objectForKey:@"weiboId"], @"");
    originalArticleWeibo.text = SNString([weiboDict objectForKey:@"text"], @"");
    originalArticleWeibo.picUrl = SNString([weiboDict objectForKey:@"pic"], @"");
    NSDate * date = [NSDate dateFromTimestamp:[weiboDict objectForKeySafely:@"pubDate"]];
    originalArticleWeibo.pubDate = [date stringWithTimeStampNoSecFormat];
    originalArticleWeibo.wapUrl = [SNString([weiboDict objectForKey:@"wapUrl"], @"") htmlEntityDecoding];
    originalArticleWeibo.weiboUserId = SNString([weiboDict valueForKeyPathSafely:@"user.id"], @"");
    originalArticleWeibo.weiboUserName =  SNString([weiboDict valueForKeyPathSafely:@"user.name"],@"");
    originalArticleWeibo.weiboProfileImageUrl = [SNString([weiboDict valueForKeyPathSafely:@"user.profileImageUrl"],@"") htmlEntityDecoding];
    originalArticleWeibo.pics = [weiboDict valueForKeyPathSafely:@"pics"];
    originalArticleWeibo.isDeleted = SNBool([weiboDict valueForKeyPathSafely:@"deleted"], NO);
    originalArticleWeibo.weiboType = SNInt([weiboDict valueForKeyPathSafely:@"user.verifiedType"], -1);
    
    return originalArticleWeibo;
}

//原创正文单条微博
- (void)parseSingleWeiboListWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
//    NSArray *weiboModuleArray = [dict objectDataForKeySafely:@"singleWeibo"];
//    if ([weiboModuleArray isKindOfClass:[NSArray class]])
//    {
//        NSMutableArray *tempArray = [NSMutableArray array];
//        //遍历微博组微博
//        for (NSDictionary *listDictionary in weiboModuleArray)
//        {
//            if ([listDictionary isKindOfClass:[NSDictionary class]])
//            {
//                NSDictionary *data = [listDictionary objectForKeySafely:@"data"];
//                // 创建一个微博
//                SNArticleWeibo *originalArticleWeibo = [self getSingleWeiboFromDict:data];
//                [tempArray addObject:originalArticleWeibo];
//            }
//        }
//        article.singleWeiboList = [NSArray arrayWithArray:tempArray];
//    }
}

//模型化微博组
- (void)parseWeiboGroupWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
//    NSArray *weiboModuleArray = [dict objectDataForKeySafely:@"weiboGroup"];
//    if ([weiboModuleArray isKindOfClass:[NSArray class]])
//    {
//        NSInteger moduleCount = [weiboModuleArray count];
//        // 存在微博组
//        if (moduleCount > 0)
//        {
//            // 创建微博组数组
//            NSMutableArray *articleWeiboModuleArray = [[NSMutableArray alloc] initWithCapacity:[weiboModuleArray count]];
//            
//            // 遍历微博组数组,每一个dictionary代表一个微博组
//            for (NSDictionary *weiboModuleDictionary in weiboModuleArray)
//            {
//                if ([weiboModuleDictionary isKindOfClass:[NSDictionary class]])
//                {
//                    NSArray *listArray = [weiboModuleDictionary objectForKey:@"data"];
//                    if ([listArray isKindOfClass:[NSArray class]])
//                    {
//                        if ([listArray count] > 0)
//                        {
//                            // 创建一个微博组
//                            SNArticleWeiboGroup * oawGroup = [[SNArticleWeiboGroup alloc] init];
//                            if (nil == oawGroup.weiboGroup)
//                            {
//                                NSMutableArray * temp = [[NSMutableArray alloc] init];
//                                oawGroup.weiboGroup = temp;
//                            }
//                            
//                            //遍历微博组微博
//                            for (NSDictionary *listDictionary in listArray)
//                            {
//                                // 创建一个微博
//                                SNArticleWeibo *originalArticleWeibo = [[SNArticleWeibo alloc] init];
//                                originalArticleWeibo.weiboId = SNString([listDictionary objectForKey:@"weiboId"], @"");
//                                originalArticleWeibo.text = SNString([listDictionary objectForKey:@"text"], @"");
//                                originalArticleWeibo.picUrl = SNString([listDictionary objectForKey:@"pic"], @"");
//                                NSDate * date = [NSDate dateFromTimestamp:[listDictionary objectForKeySafely:@"pubDate"]];
//                                originalArticleWeibo.pubDate = [date stringWithTimeStampNoSecFormat];
//                                originalArticleWeibo.wapUrl = [SNString([listDictionary objectForKey:@"wapUrl"], @"") htmlEntityDecoding];
//                                originalArticleWeibo.weiboUserId = SNString([listDictionary valueForKeyPathSafely:@"user.id"],@"");
//                                originalArticleWeibo.weiboUserName = SNString([listDictionary valueForKeyPathSafely:@"user.name"],@"");
//                                originalArticleWeibo.weiboProfileImageUrl = [SNString([listDictionary valueForKeyPathSafely:@"user.profileImageUrl"],@"") htmlEntityDecoding];
//                                originalArticleWeibo.pics = [listDictionary valueForKeyPathSafely:@"pics"];
//                                originalArticleWeibo.weiboType = SNInt([listDictionary valueForKeyPathSafely:@"user.verifiedType"], -1);
//                                
//                                // 把微博加入微博组
//                                [oawGroup.weiboGroup addObject:originalArticleWeibo];
//                            }
//                            
//                            // 把微博组加入微博组数据
//                            [articleWeiboModuleArray addObject:oawGroup];
//                        }
//                    }
//                }
//                
//            }
//            
//            // 设置正文微博组数组
//            article.weiboModuleArray = articleWeiboModuleArray;
//        }
//    }
}

//处理微博组
- (void)handleWeiboGroupInArticle:(SNArticle *)conciseArticle
{
    // 有微博模块,进行替换
    if ([conciseArticle.weiboModuleArray count] > 0)
    {
        int idx = 0;
        for (SNArticleWeiboGroup * weiboGroup in conciseArticle.weiboModuleArray )
        {
            NSString *weiboGroupHtml = [SNArticleParser weiboGroupHtmlWithWeiboGroup:weiboGroup groupIndex:idx];
            
            conciseArticle.content = [conciseArticle.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_WEIBO_GROUP,idx+1] withString:weiboGroupHtml];
            
            idx++;
        }
    }
}

//获取微博组的html
+ (NSString *)weiboGroupHtmlWithWeiboGroup:(SNArticleWeiboGroup*)weiboGroup groupIndex:(int)groupIndex
{
    NSMutableString *weiboGroupHtml = [NSMutableString string];
    if (weiboGroup)
    {
        NSInteger weiboCount = [weiboGroup.weiboGroup count];
        if (weiboCount >0)
        {
            // section开始
            [weiboGroupHtml appendString:@"<section data-pl=\"weibo-group\" class=\"M_grouptxt\"><article class=\"grouptxt_w\" ui-slides>"];
            
            // ul开始
            [weiboGroupHtml appendFormat:@"<ul style=\"width:%ld%%;\">",(long)(weiboCount * 100)];
            
            // li
            SNArticleWeibo *articleWeibo = nil;
            CGFloat liWidth = 100.0 / weiboCount;
            NSString *liWidthString = [NSString stringWithFormat:@"%f", liWidth];
            for (int i = 0; i < weiboCount; ++i)
            {
                articleWeibo = [weiboGroup.weiboGroup objectAtIndexSafely:i];
                if (articleWeibo)
                {
                    // v标示
                    NSString *icon = @"";
                    WeiboCertifiedType type = [articleWeibo getWeiboCertifiedType];
                    switch (type)
                    {
                        case kWeiboTypeCertifiedUser:
                            icon = @"images/v_y.png";
                            break;
                            
                        case kWeiboTypeCertifiedCompany:
                            icon = @"images/v_b.png";
                        default:
                            break;
                    }
                    
                    // 头像
                    NSString *headUrl = articleWeibo.weiboProfileImageUrl;
                    if (!CHECK_VALID_STRING(headUrl))
                    {
                        headUrl = @"";
                    }
                    
                    NSString *iconHtml = @"";
                    //若非VIP
                    if(![icon isEqualToString:@""])
                    {
                        iconHtml = [NSString stringWithFormat:@"<span class=\"icon\"> <img src=\"%@\"></span>",icon];
                    }
                    
                    // 参数:宽度百分比：wap链接：头像：微博名：微博v类型：微博信息：发表日期
                    [weiboGroupHtml appendFormat:
                     @"<li style=\"width:%@%%;\" >\
                     <div class=\"txt\">\
                     <div class=\"ntxt\" ui-button=\"\" ui-link=\"method:weiboClick;wap_url:%@\">\
                     <div class=\"head\">\
                     <img src=\"%@\"/>\
                     %@\
                     </div>\
                     <div class=\"titile\">%@</div>\
                     <div class=\"time\">%@</div>\
                     <p textlimit-role=\"text\" ui-textlimit>%@</p>\
                     <dl class=\"bottombar\">\
                     <dd ui-link=\"method:weiboGroupRepost;groupIndex:%d;index:%d\"><span class=\"icon_forward\"></span>转发</dd>\
                     <dd class=\"boder\"></dd>\
                     <dd ui-link=\"method:weiboGroupComment;groupIndex:%d;index:%d\"><span class=\"icon_comment\"></span>评论</dd>\
                     </dl>\
                     </div>\
                     </div>\
                     </li>",liWidthString,articleWeibo.wapUrl,headUrl,iconHtml,articleWeibo.weiboUserName,articleWeibo.pubDate,articleWeibo.text,groupIndex,i,groupIndex,i];
                }
            }
            
            // ul关闭
            [weiboGroupHtml appendFormat:@"</ul>"];
            
            // section关闭
            [weiboGroupHtml appendString:@"</article></section>"];
        }
    }
    return weiboGroupHtml;
}

//单条微博的图片html
+ (NSString *)singleWeiboImageHtmlWithArticleWeibo:(SNArticleWeibo *) weibo
                                         inArticle:(SNArticle *)article
                                        groupIndex:(NSInteger)groupIndex
{
    NSMutableString *html = [[NSMutableString alloc]init];
    
    //只有一张配图
    if([weibo.pics count] == 1)
    {
        NSDictionary *pic = [weibo.pics objectAtIndexSafely:0];
        
        SNArticleImage * img = [[SNArticleImage alloc] init];
        
        if ([pic objectForKeySafely:@"height"] && [pic objectForKeySafely:@"width"])
        {
            //屏幕缩放比例
            float scale = [UIScreen mainScreen].scale;
            //宽
            CGFloat width = SNInt([pic objectForKey:@"width"], 0)/scale;
            //高
            CGFloat height = SNInt([pic objectForKey:@"height"], 0)/scale;
            
            //使用K服务后,服务器取不到图片尺寸返回默认尺寸后,会引起一些bug.这里统一,一旦发现是280,210,就认为是默认尺寸,则按常规长边截图展示.这样做会错杀真正的280*210的图片,但是影响不大.
            if(width == 280/scale && height == 210/scale)
            {
                //宽高按照常规长边展示
                img.height = COMMAN_IMAGE_LONG;
                img.width = COMMAN_IMAGE_LONG;
                //需要截图
                img.needCut = YES;
            }
            //若高度大于宽度
            else if(height > width)
            {
                //若长边与短边的比小于等于常规比例
                if(height/width <= RATE_COMMAN_IMAGE)
                {
                    //高度按照常规长边展示
                    img.height = COMMAN_IMAGE_LONG;
                    //宽度等比缩放
                    img.width = img.height/height*width;
                    
                }
                //非常规比例
                else
                {
                    img.height = COMMAN_IMAGE_LONG;
                    img.width = COMMAN_IMAGE_SHORT;
                    //需要截图
                    img.needCut = YES;
                }
            }
            else if(width > height)
            {
                //若长边与短边的比小于等于常规比例
                if(width/height <= RATE_COMMAN_IMAGE)
                {
                    //宽度按照常规长边展示
                    img.width = COMMAN_IMAGE_LONG;
                    //高度等比缩放
                    img.height = img.width/width*height;
                }
                //非常规比例
                else
                {
                    img.width = COMMAN_IMAGE_LONG;
                    img.height = COMMAN_IMAGE_SHORT;
                    //需要截图
                    img.needCut = YES;
                }
            }
            //宽高相等
            else
            {
                //宽度按照常规长边展示
                img.width = COMMAN_IMAGE_LONG;
                //高度等比缩放
                img.height = COMMAN_IMAGE_LONG;
                //需要截图
                img.needCut = YES;
            }
        }
        
        img.url = SNString([pic objectForKey:@"kpic"], @"");
        
        img.gifUrl = SNString([pic objectForKey:@"gif"], nil);
        img.tagId = [SNArticleManager tagIDWithSingleWeiboImageIndex:article.weiboImageIndex ++ ];
        
        [article.articleImageArray addObject:img];
        
        //gif的html节点
        NSString *gifNode = @"";
        
        //若gif存在
        if(img.gifUrl)
        {
            gifNode = @"<span class=\"icon\">GIF</span>";
        }
        
        NSString *greyStyle = @"";
        
        //若图片宽度小于80,则无法完全展示占为图,则让占为图为纯灰色
        if(img.width <= 80)
        {
            greyStyle = @" grey";
        }
        
        //若宽高不为空，则在style里设置宽高
        if(img.width!=0 && img.height!=0)
        {
            [html appendFormat:@"<div class=\"pic%@\" ui-imgbox ui-link=\"method:imgClick;pos:1;pic:%@\" style=\"width:%dpx;height:%dpx;\"><img src=\"[%@]\" data-src=\"%@\"  onerror=\"this.style.display='none'\" onload=\"this.style.display='inline';this.parentNode.style.height='auto';this.style.width='width:%dpx';this.style.height='%dpx;'\" style=\"width:%dpx;height:%dpx;\"/>%@</div>",greyStyle,img.tagId,img.width,img.height,img.tagId,img.tagId,img.width,img.height,img.width,img.height,gifNode];
        }
        else
        {
            [html appendFormat:@"<div class=\"pic%@\" ui-imgbox ui-link=\"method:imgClick;pos:1;pic:%@;\"><img src=\"[%@]\" data-src=\"%@\"  onerror=\"this.style.display='none'\" onload=\"this.style.display='inline';this.parentNode.style.height='auto'\" />%@</div>",greyStyle,img.tagId,img.tagId,img.tagId,gifNode];
        }
    }
    //多张配图
    else if([weibo.pics count] > 1)
    {
        [html appendFormat:@"<div class=\"picmore\">"];
        if([weibo.pics count] == 4)
        {
            [html appendFormat:@"<ul class=\"four\">"];
        }
        else
        {
            [html appendFormat:@"<ul>"];
        }
        
        for (int i = 0;i<[weibo.pics count];i++ )
        {
            NSDictionary * pic = [weibo.pics objectAtIndexSafely:i];
            SNArticleImage * img = [[SNArticleImage alloc] init];
            
            img.gifUrl = SNString([pic objectForKey:@"gif"], nil);
            img.url = SNString([pic objectForKey:@"kpic"], @"");
            img.width = OriginalSingleWeiboImage_Width;
            img.height = OriginalSingleWeiboImage_Height;
            img.tagId = [SNArticleManager tagIDWithSingleWeiboImageIndex:article.weiboImageIndex ++ ];
            //需要裁剪
            img.needCut = YES;
            [article.articleImageArray addObject:img];
            
            //gif的html节点
            NSString *gifNode = @"";
            //若gif存在
            if(img.gifUrl)
            {
                gifNode = @"<span class=\"icon\">GIF</span>";
            }
            
            [html appendFormat:@"<li>"];
            [html appendFormat:@"<div class=\"photo\" ui-imgbox=\"\" ui-link=\"tagId:%@;method:imageGroupClick;pos:1;pic:%@;groupIndex:%ld;index:%d;type:%d\">",img.tagId,img.tagId,(long)groupIndex,i,ArticlePicGroupTypeWeiboPicGroup];
            [html appendFormat:@"<img src=\"[%@]\" data-src=\"%@\"  onerror=\"this.style.display='none'\" onload=\"this.style.display='inline';this.parentNode.style.height='auto'\"/>",img.tagId,img.tagId];
            [html appendFormat:@"%@</div>",gifNode];
            
            [html appendFormat:@"</li>"];
        }
        [html appendFormat:@"</ul>"];
        //picmore结束
        [html appendFormat:@"</div>"];
    }
    return html;
}

+ (NSString *)weiboDeletedHtml
{
    return @"<section data-pl=\"weibo_article\"><div class=\"M_tips_error\">抱歉，引用微博正文已被删除</div></section>";
}

//微博正文单条微博的html
+ (NSString *)singleWeiboHtmlWithWeiboArticleWeibo:(SNArticleWeibo*)weibo
                                         inArticle:(SNArticle *)article
                                        groupIndex:(NSInteger)groupIndex
{
    NSMutableString *html = [[NSMutableString alloc]init];
    
    //若没有转发微博
    if(!weibo.reweetWeibo)
    {
        [html appendFormat:@"<section data-pl=\"weibo_article\">"];
        [html appendFormat:@"<h3>@%@</h3>",weibo.weiboUserName];
        [html appendFormat:@"<div class=\"M_pw\">%@</div>",weibo.text];
        
        //若小于等于3张配图
        if([weibo.pics count] <= 3)
        {
            for(NSDictionary *pic in weibo.pics)
            {
                //创建图片对象
                SNArticleImage * img = [[SNArticleImage alloc] init];
                
                img.gifUrl = SNString([pic objectForKey:@"gif"],nil);
                img.url = SNString([pic objectForKey:@"kpic"], @"");
                
                img.description = SNString([pic objectForKey:@"alt"], @"");
                img.tagId = [SNArticleManager tagIDWithSingleWeiboImageIndex:article.weiboImageIndex ++ ];
                
                //若有宽高
                if ([pic objectForKeySafely:@"width"] &&
                    [pic objectForKeySafely:@"height"] &&
                    [[pic objectForKeySafely:@"width"] integerValue] != 0 &&
                    [[pic objectForKeySafely:@"height"] integerValue] != 0)
                {
                    //宽
                    img.width = SNInt([pic objectForKey:@"width"], 0);
                    //高
                    img.height = SNInt([pic objectForKey:@"height"], 0);
                }
                [article.articleImageArray addObject:img];
                
                //获取图片对应标签
                NSString * imgTag = [SNArticleParser imgTagWithArticleImg:img];
                
                [html appendString:imgTag];
            }
        }
        else
        {
            // 创建一个图片组
            SNArticlePictureGroup * articlePicGroup = [[SNArticlePictureGroup alloc] init];
            if (nil == articlePicGroup.pictureGroup)
            {
                NSMutableArray * temp = [[NSMutableArray alloc] init];
                articlePicGroup.pictureGroup = temp;
            }
            
            //遍历图片组的图片
            for (NSDictionary *pictureDictionary in weibo.pics)
            {
                if ([pictureDictionary isKindOfClass:[NSDictionary class]])
                {
                    // 创建一个图片
                    SNArticlePicture *articlePicture = [[SNArticlePicture alloc] init];
                    
                    articlePicture.picUrl = SNString([pictureDictionary objectForKey:@"kpic"], @"");
                    
                    // 把图片加入图片组
                    [articlePicGroup.pictureGroup addObject:articlePicture];
                }
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:article.picsModuleList];
            [array addObject:articlePicGroup];
            // 把图片组加入图片组数组
            article.picsModuleList = array;
            
            //在微博html后追加一个图组的占位符
            [html appendFormat:PlaceHolder_PIC_MODULE,1];
            [html appendFormat:@"</section>"];
        }
    }
    //有转发微博
    else
    {
        NSString *icon = @"";
        WeiboCertifiedType type = [weibo.reweetWeibo getWeiboCertifiedType];
        switch (type)
        {
            case kWeiboTypeCertifiedUser:
                icon = @"images/v_y.png";
                break;
                
            case kWeiboTypeCertifiedCompany:
                icon = @"images/v_b.png";
            default:
                break;
        }
        
        /*   转发内容Start   */
        [html appendFormat:@"<section data-pl=\"weibo_article\">"];
        [html appendFormat:@"<h3>@%@</h3>",weibo.reweetWeibo.weiboUserName];
        [html appendFormat:@"<div class=\"M_pw\">%@</div>",weibo.reweetWeibo.text];
        
        /*   原文内容Start   */
        [html appendFormat:@"<section class=\"M_weiboboxm\">"];
        [html appendFormat:@"<article class=\"weibobox\">"];
        [html appendFormat:@"<div class=\"weibocont\">"];
        
        //若原微博被删除
        if(weibo.isDeleted)
        {
            [html appendString:@"<div class=\"tips_error\">抱歉，原文已被删除</div>"];
        }
        //原微博存在,则展示
        else
        {
            [html appendFormat:@"<article class=\"M_weibo\">"];
            [html appendFormat:@"<div class=\"hearder\">"];
            [html appendFormat:@"<div class=\"head\">"];
            [html appendFormat:@"<img src=\"%@\">",weibo.weiboProfileImageUrl];
            if(icon.length > 0)
            {
                [html appendFormat:@"<span class=\"icon\"><img src=\"%@\"></span>",icon];
            }
            //head end
            [html appendFormat:@"</div>"];
            [html appendFormat:@"<div class=\"titile\">%@</div>",weibo.weiboUserName];
            [html appendFormat:@"<div class=\"time\">%@</div>",weibo.pubDate];
            [html appendFormat:@"<div class=\"txt\">%@</div>",weibo.text];
            //单条微博的图片html
            NSString *imageHtml = [SNArticleParser singleWeiboImageHtmlWithArticleWeibo:weibo inArticle:article groupIndex:groupIndex];
            [html appendString:imageHtml];
            //header end
            [html appendFormat:@"</div>"];
            //M_weibo end
            [html appendFormat:@"</article>"];
            
        }
        
        //weibocont end
        [html appendFormat:@"</div>"];
        //weibobox end
        [html appendFormat:@"</article>"];
        //M_weiboboxm end
        [html appendFormat:@"</section>"];
        //weibo_article end
        [html appendFormat:@"</section>"];
        
        /*   原文内容End   */
    }
    
    return html;
}

//原创正文单条微博的html
+ (NSString *)singleWeiboHtmlWithArticleWeibo:(SNArticleWeibo*)weibo
                                    inArticle:(SNArticle *)article
                                   groupIndex:(NSInteger)groupIndex
{
    NSMutableString *html = [[NSMutableString alloc]init];
    
    //若没有转发微博
    if(!weibo.reweetWeibo)
    {
        NSString *icon = @"";
        WeiboCertifiedType type = [weibo getWeiboCertifiedType];
        switch (type)
        {
            case kWeiboTypeCertifiedUser:
                icon = @"images/v_y.png";
                break;
                
            case kWeiboTypeCertifiedCompany:
                icon = @"images/v_b.png";
            default:
                break;
        }
        
        [html appendFormat:@"<article data-pl=\"weibo\" class=\"M_weibo\" ui-link=\"method:weiboClick;wap_url:%@\">",weibo.wapUrl];
        [html appendFormat:@"<div class=\"M_wbcontent\" ui-button>"];
        [html appendFormat:@"<div class=\"hearder\">"];
        [html appendFormat:@"<div class=\"head\">"];
        
        
        [html appendFormat:@"<img src=\"%@\" data-src=\"%@\" />",weibo.weiboProfileImageUrl,weibo.weiboProfileImageUrl];
        if([icon length] > 0)
        {
            [html appendFormat:@"<span class=\"icon\">"];
            [html appendFormat:@"<img src=\"%@\"/>",icon];
            [html appendFormat:@"</span>"];
        }
        [html appendString:@"</div>"];
        [html appendFormat:@"<div class=\"titile\">"];
        [html appendFormat:@"%@",weibo.weiboUserName];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"<div class=\"time\">%@</div>",weibo.pubDate];
        [html appendFormat:@"<div class=\"txt\">%@</div>",weibo.text];
        
        //单条微博的图片html
        NSString *imageHtml = [SNArticleParser singleWeiboImageHtmlWithArticleWeibo:weibo inArticle:article groupIndex:groupIndex];
        [html appendString:imageHtml];
        
        //header end
        [html appendFormat:@"</div>"];
        //M_wbcontent end
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"bottombarf\">"];
        
        //4.3暂时不加转发评论功能
        [html appendFormat:@"<ul class=\"bottombar\">"];
        [html appendFormat:@"<li ui-button=\"\" ui-link=\"method:weiboRepost;groupIndex:%ld\">",(long)groupIndex];
        [html appendFormat:@"<span class=\"icon_forward\"></span>"];
        [html appendFormat:@"转发"];
        [html appendFormat:@"</li>"];
        [html appendFormat:@"<span class=\"boder\"></span>"];
        [html appendFormat:@"<li ui-button=\"\" ui-link=\"method:weiboComment;groupIndex:%ld\">",(long)groupIndex];
        [html appendFormat:@"<span class=\"icon_comment\"></span>"];
        [html appendFormat:@"评论"];
        [html appendFormat:@"</li>"];
        [html appendFormat:@"</ul>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</article>"];
    }
    //有转发微博
    else
    {
        NSString *icon = @"";
        WeiboCertifiedType type = [weibo.reweetWeibo getWeiboCertifiedType];
        switch (type)
        {
            case kWeiboTypeCertifiedUser:
                icon = @"images/v_y.png";
                break;
                
            case kWeiboTypeCertifiedCompany:
                icon = @"images/v_b.png";
            default:
                break;
        }
        
        /*   转发内容Start   */
        [html appendFormat:@"<article data-pl=\"weibo\" class=\"M_weibo\" ui-link=\"method:weiboClick;wap_url:%@\">",weibo.reweetWeibo.wapUrl];
        [html appendFormat:@"<div class=\"M_wbcontent\" ui-button>"];
        [html appendFormat:@"<div class=\"hearder\">"];
        [html appendFormat:@"<div class=\"head\">"];
        [html appendFormat:@"<img src=\"%@\" data-src=\"%@\" >",weibo.reweetWeibo.weiboProfileImageUrl,weibo.reweetWeibo.weiboProfileImageUrl];
        if([icon length] > 0)
        {
            [html appendFormat:@"<span class=\"icon\">"];
            [html appendFormat:@"<img src=\"%@\"/>",icon];
            [html appendFormat:@"</span>"];
        }
        [html appendFormat:@"</div>"];
        [html appendFormat:@"<div class=\"titile\">"];
        [html appendFormat:@"%@",weibo.reweetWeibo.weiboUserName];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"<div class=\"time\">%@</div>",weibo.reweetWeibo.pubDate];
        [html appendFormat:@"<div class=\"txt\">%@</div>",weibo.reweetWeibo.text];
        //header end
        [html appendFormat:@"</div>"];
        /*   转发内容End   */
        
        /*   原文内容Start   */
        [html appendFormat:@"<div class=\"picf\">"];
        [html appendFormat:@"<div class=\"picbox\">"];
        
        [html appendFormat:@"<div class=\"txt\">"];
        [html appendFormat:@"<span>@%@:</span>",weibo.weiboUserName];
        [html appendFormat:@"%@",weibo.text];
        [html appendFormat:@"</div>"];
        
        //单条微博的图片html
        NSString *imageHtml = [SNArticleParser singleWeiboImageHtmlWithArticleWeibo:weibo inArticle:article groupIndex:groupIndex];
        [html appendString:imageHtml];
        //picbox end
        [html appendFormat:@"</div>"];
        //picf end
        [html appendFormat:@"</div>"];
        //M_wbcontent end
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"bottombarf\">"];
        
        //转发评论功能
        [html appendFormat:@"<ul class=\"bottombar\">"];
        [html appendFormat:@"<li ui-button=\"\" ui-link=\"method:weiboRepost;groupIndex:%ld\">",(long)groupIndex];
        [html appendFormat:@"<span class=\"icon_forward\"></span>"];
        [html appendFormat:@"转发"];
        [html appendFormat:@"</li>"];
        [html appendFormat:@"<span class=\"boder\"></span>"];
        [html appendFormat:@"<li ui-button=\"\" ui-link=\"method:weiboComment;groupIndex:%ld\">",(long)groupIndex];
        [html appendFormat:@"<span class=\"icon_comment\"></span>"];
        [html appendFormat:@"评论"];
        [html appendFormat:@"</li>"];
        [html appendFormat:@"</ul>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</article>"];
        /*   原文内容End   */
    }
    
    return html;
}

//微博组的html
+ (NSString *)weiboGroupHtmlWithWeiboGroup:(SNArticleWeiboGroup*)weiboGroup
{
    NSMutableString *weiboGroupHtml = [NSMutableString string];
    if (weiboGroup)
    {
        NSInteger weiboCount = [weiboGroup.weiboGroup count];
        if (weiboCount >0)
        {
            // section开始
            [weiboGroupHtml appendString:@"<h3 class=\"M_title\"><span>微博热议</span></h3><section class=\"M_grouptxt\">\
             <article class=\"grouptxt_w\" ui-slides=\"\">"];
            
            // ul开始
            [weiboGroupHtml appendFormat:@"<ul style=\"width:%ld%%;\">",(long)((weiboCount * 100))];
            
            // li
            SNArticleWeibo *articleWeibo = nil;
            CGFloat liWidth = 100.0 / weiboCount;
            NSString *liWidthString = [NSString stringWithFormat:@"%f", liWidth];
            for (int i = 0; i < weiboCount; ++i)
            {
                articleWeibo = [weiboGroup.weiboGroup objectAtIndexSafely:i];
                if (articleWeibo)
                {
                    // v标示
                    NSString *icon = @"";
                    WeiboCertifiedType type = [articleWeibo getWeiboCertifiedType];
                    switch (type)
                    {
                        case kWeiboTypeCertifiedUser:
                            icon = @"images/v.png";
                            break;
                            
                        case kWeiboTypeCertifiedCompany:
                            icon = @"images/v_b.png";
                        default:
                            break;
                    }
                    
                    // 头像
                    NSString *headUrl = articleWeibo.weiboProfileImageUrl;
                    if (!CHECK_VALID_STRING(headUrl))
                    {
                        headUrl = @"";
                    }
                    
                    // 参数:宽度百分比：wap链接：头像：微博名：微博v类型：微博信息：发表日期
                    [weiboGroupHtml appendFormat:@"<li style=\"width:%@%%;\" ui-textlimit=\"\"><div class=\"txt\">\
                     <div class=\"ntxt\" ui-button=\"\" ui-link=\"method:weiboClick;wap_url:%@\">\
                     <p><em class=\"img\"><img src=\"%@\"/></em>\
                     <span>%@<img class=\"v_img\" src=\"%@\"/> : </span>\
                     <i textlimit-role=\"text\">%@</i></p><div class=\"time\">%@</div></div></div>\
                     </li>",liWidthString,articleWeibo.wapUrl,headUrl,articleWeibo.weiboUserName,icon,articleWeibo.text,articleWeibo.pubDate];
                }
            }
            
            // ul关闭
            [weiboGroupHtml appendFormat:@"</ul>"];
            
            // section关闭
            [weiboGroupHtml appendString:@"</article></section>"];
        }
    }
    return weiboGroupHtml;
}

@end
