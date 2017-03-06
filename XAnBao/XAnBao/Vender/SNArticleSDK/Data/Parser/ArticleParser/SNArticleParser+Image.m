//
//  ArticleParser+Image.m
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser+Image.h"
#import "SNArticle.h"
#import "SNCommonMacro.h"
#import "NSDictionary+SNArticle.h"
#import "SNImageUrlManager.h"
#import "SNArticleManager+Tag.h"

//#import "NewsManager+Article.h"

@implementation SNArticleParser (Image)

#pragma mark - 图片
#pragma mark ----- 顶图
//处理顶图
- (void)handleHeaderPictureInArticle:(SNArticle *)article
{
    if(!article.headPictureUrl)
        return;
    SNArticleImage * img = [[SNArticleImage alloc] init];
    img.url = article.headPictureUrl;
    img.width = kScreenWidth;
    img.height = kScreenWidth;
    img.needCut = YES;
    img.doZoom = YES;
    img.tagId = @"scale-img";
    
    [article.articleImageArray addObject:img];
}

#pragma mark ----- 图组
//普通图组
- (void)parsePicsGroupWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *pictureModuleArray = [dict objectDataForKeySafely:@"picsGroup"];
    if ([pictureModuleArray isKindOfClass:[NSArray class]])
    {
        NSInteger moduleCount = [pictureModuleArray count];
        // 存在图片组
        if (moduleCount > 0)
        {
            // 创建图片组数组
            NSMutableArray *articlePicModuleArray = [[NSMutableArray alloc] initWithCapacity:[pictureModuleArray count]];
            
            // 遍历图片组数组,每一个dictionary代表一个图片组
            for (NSDictionary *pictureModuleDictionary in pictureModuleArray)
            {
                if ([pictureModuleDictionary isKindOfClass:[NSDictionary class]])
                {
                    NSArray *picArray = [pictureModuleDictionary objectForKey:@"data"];
                    if ([picArray isKindOfClass:[NSArray class]])
                    {
                        if ([picArray count] > 0)
                        {
                            // 创建一个图片组
                            SNArticlePictureGroup * articlePicGroup = [[SNArticlePictureGroup alloc] init];
                            articlePicGroup.title = SNString([pictureModuleDictionary objectForKeySafely:@"title"], @"");
                            
                            if (nil == articlePicGroup.pictureGroup)
                            {
                                NSMutableArray * temp = [[NSMutableArray alloc] init];
                                articlePicGroup.pictureGroup = temp;
                            }
                            
                            //遍历图片组的图片
                            for (NSDictionary *pictureDictionary in picArray)
                            {
                                if ([pictureDictionary isKindOfClass:[NSDictionary class]])
                                {
                                    // 创建一个图片
                                    SNArticlePicture *articlePicture = [[SNArticlePicture alloc] init];
                                    //取出接口返回的宽高
                                    articlePicture.width = SNInteger([pictureDictionary objectForKey:@"width"], 0);
                                    articlePicture.height = SNInteger([pictureDictionary objectForKey:@"height"], 0);
                                    
                                    //算出可用K服务范围内的宽度
                                    articlePicture.width = [self getGroupImageWidthWithAP:articlePicture];
                                    //固定高度
                                    articlePicture.height = ArticleScrollGroupImage_Height;
                                    articlePicture.picUrl = SNString([pictureDictionary objectForKey:@"kpic"], @"");
                                    articlePicture.gifUrl = SNString([pictureDictionary objectForKey:@"gif"], @"");
                                    articlePicture.picAlt = SNString([pictureDictionary objectForKey:@"alt"], @"");
                                    
                                    // 把图片加入图片组
                                    [articlePicGroup.pictureGroup addObject:articlePicture];
                                }
                            }
                            
                            // 把图片组加入图片组数组
                            [articlePicModuleArray addObject:articlePicGroup];
                        }
                    }
                }
            }
            
            // 设置正文图片组
            article.pictureGroupList = articlePicModuleArray;
        }
    }
}

//高清图组
- (void)parseHDPicsGroupWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *pictureModuleArray = [dict objectDataForKeySafely:@"hdpicsGroup"];
    if ([pictureModuleArray isKindOfClass:[NSArray class]])
    {
        NSInteger moduleCount = [pictureModuleArray count];
        // 存在图片组
        if (moduleCount > 0)
        {
            // 创建图片组数组
            NSMutableArray *articlePicModuleArray = [[NSMutableArray alloc] initWithCapacity:[pictureModuleArray count]];
            
            // 遍历图片组数组,每一个dictionary代表一个图片组
            for (NSDictionary *pictureModuleDictionary in pictureModuleArray)
            {
                if ([pictureModuleDictionary isKindOfClass:[NSDictionary class]])
                {
                    NSArray *picArray = [pictureModuleDictionary objectForKey:@"data"];
                    if ([picArray isKindOfClass:[NSArray class]])
                    {
                        if ([picArray count] > 0)
                        {
                            // 创建一个图片组
                            SNArticlePictureGroup * articlePicGroup = [[SNArticlePictureGroup alloc] init];
                            articlePicGroup.title = SNString([pictureModuleDictionary objectForKeySafely:@"title"], @"");
                            
                            if (nil == articlePicGroup.pictureGroup)
                            {
                                NSMutableArray * temp = [[NSMutableArray alloc] init];
                                articlePicGroup.pictureGroup = temp;
                            }
                            
                            //遍历图片组的图片
                            for (NSDictionary *pictureDictionary in picArray)
                            {
                                if (CHECK_VALID_DICTIONARY(pictureDictionary))
                                {
                                    // 创建一个图片
                                    SNArticlePicture *articlePicture = [[SNArticlePicture alloc] init];
                                    articlePicture.picUrl = SNString([pictureDictionary objectForKey:@"kpic"], @"");
                                    articlePicture.width = SNInteger([pictureDictionary objectForKey:@"width"], 0);
                                    articlePicture.height = SNInteger([pictureDictionary objectForKey:@"height"], 0);
                                    
                                    //算出可用K服务范围内的宽度
                                    articlePicture.width = [self getGroupImageWidthWithAP:articlePicture];
                                    //固定高度
                                    articlePicture.height = ArticleScrollGroupImage_Height;
                                    
                                    articlePicture.gifUrl = SNString([pictureDictionary objectForKey:@"gif"], @"");
                                    articlePicture.picAlt = SNString([pictureDictionary objectForKey:@"alt"], @"");
                                    // 把图片加入图片组
                                    [articlePicGroup.pictureGroup addObject:articlePicture];
                                }
                            }
                            
                            // 把图片组加入图片组数组
                            [articlePicModuleArray addObject:articlePicGroup];
                        }
                    }
                }
            }
            
            // 设置正文图片组
            article.hdPictureGroupList = articlePicModuleArray;
        }
    }
}

//获取滑动图组的宽度
- (int)getGroupImageWidthWithAP:(SNArticlePicture * )articlePic
{
    if(articlePic.height == 0)
    {
        return 125;
    }
    //算出图片高度和固定高度的比例
    CGFloat scale = articlePic.height/ArticleScrollGroupImage_Height;
    //根据比例缩放宽度
    int width = articlePic.width/scale;
    
    //最小值
    int min = 125;
    //最大值为屏幕宽度-70
    int max = ArticleScrollGroupImage_Width;
    //25递增
    int level = 25;
    
    //最多为max
    if(width > max - level)
    {
        return max;
    }
    
    //从最小开始,按照level递增来向上适配宽度
    for(int i = min; i <= max; i+=level)
    {
        if(width<=i)
        {
            return i;
        }
    }
    
    return width;
}

//处理滑动图组
- (void)handlePicsGroupInArticle:(SNArticle *)article
{
    NSUInteger articleImageCount = article.articleImageArray.count;
    
    if (article.pictureGroupList.count > 0) {
        
        int idx = 0;
        for (SNArticlePictureGroup * pictureGroup in article.pictureGroupList )
        {
            for (SNArticlePicture * articlePic in pictureGroup.pictureGroup )
            {
                SNArticleImage * img = [[SNArticleImage alloc] init];
                img.gifUrl = articlePic.gifUrl;
                img.url = articlePic.picUrl;
                img.width = (int)articlePic.width;
                img.height = (int)articlePic.height;
                img.description = articlePic.picAlt;
                img.tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount + idx];
                img.needCut = YES;
                img.NOScale = YES;
                img.doZoom = YES;
                [article.articleImageArray addObject:img];
                
                articlePic.tagId = img.tagId;
                pictureGroup.totalWidth += 10+img.width;
                idx++;
            }
        }
    }
    
    // 有图组模块,进行替换
    if ([article.pictureGroupList count] > 0)
    {
        int imageTagIdx = 0;
        int idx = 0;
        
        for (SNArticlePictureGroup * pictureGroup in article.pictureGroupList )
        {
            NSMutableString *pictureGroupHtml = [NSMutableString string];
            
            NSInteger pictureCount = [pictureGroup.pictureGroup count];
            if (pictureCount >0)
            {
                [pictureGroupHtml appendString:@"<article data-pl=\"hdpics_group\" class=\"M_groupimg\"><div class=\"groupimg_w\" ui-hdslides=\"\" style=\"position: relative;\">"];
                
                NSUInteger groupIndex = [article.pictureGroupList indexOfObject:pictureGroup];
                // ul开始
                [pictureGroupHtml appendFormat:@"<ul  style=\"width:%dpx;\">",pictureGroup.totalWidth];
                
                // li
                SNArticlePicture *articlePicture = nil;
                for (int i = 0; i < pictureCount; ++i)
                {
                    articlePicture = [pictureGroup.pictureGroup objectAtIndexSafely:i];
                    
                    if (articlePicture)
                    {
                        NSString *tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount + imageTagIdx];
                        
                        [pictureGroupHtml appendFormat:@"<li style=\"width:%ldpx;height:%ldpx;\">",(long)(articlePicture.width + 10),(long)articlePicture.height];
                        [pictureGroupHtml appendFormat:@"<div class=\"photo_k\" style=\"width:%ldpx;\">",(long)articlePicture.width];
                        [pictureGroupHtml appendFormat:@"<span class=\"photo\" tap-params=\"method:imageGroupClick;pos:1;groupIndex:%lu;index:%d;tagId:%@;type:%d\" ui-imgbox link-status=\"disabled\">",(unsigned long)groupIndex,i,tagId,ArticlePicGroupTypePicsGroup];
                        [pictureGroupHtml appendFormat:@"<img id=\"%@\" data-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='block'\" style=\"width:%ldpx; height:%ldpx;\"/>",tagId,tagId,tagId,(long)articlePicture.width,(long)articlePicture.height];
                        [pictureGroupHtml appendFormat:@"</span></div></li>"];
                        
                        imageTagIdx ++;
                    }
                }
                // ul关闭
                [pictureGroupHtml appendFormat:@"</ul>"];
                
                [pictureGroupHtml appendString:@"</div>"];
                [pictureGroupHtml appendFormat:@"<h4 class=\"group_title\">%@</h4>",pictureGroup.title];
                
                [pictureGroupHtml appendString:@"</article>"];
            }
            
            article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_PIC_GROUP,idx+1] withString:pictureGroupHtml];
            
            idx++;
        }
    }
}

//处理滑动图组
- (void)handleHDPicsGroupInArticle:(SNArticle *)article
{
    NSUInteger articleImageCount = article.articleImageArray.count;
    
    if (article.hdPictureGroupList.count > 0) {
        
        int idx = 0;
        for (SNArticlePictureGroup * pictureGroup in article.hdPictureGroupList )
        {
            for (SNArticlePicture * articlePic in pictureGroup.pictureGroup )
            {
                SNArticleImage * img = [[SNArticleImage alloc] init];
                img.gifUrl = articlePic.gifUrl;
                img.url = articlePic.picUrl;
                img.width = (int)articlePic.width;
                img.height = (int)articlePic.height;
                img.tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount + idx];
                img.needCut = YES;
                img.NOScale = YES;
                img.doZoom = YES;
                img.description = articlePic.picAlt;
                [article.articleImageArray addObject:img];
                
                idx++;
                articlePic.tagId = img.tagId;
                pictureGroup.totalWidth += 10+img.width;
            }
        }
    }
    
    // 有图组模块,进行替换
    if ([article.hdPictureGroupList count] > 0)
    {
        int imageTagIdx = 0;
        int idx = 0;
        
        for (SNArticlePictureGroup * pictureGroup in article.hdPictureGroupList )
        {
            NSMutableString *pictureGroupHtml = [NSMutableString string];
            
            NSInteger pictureCount = [pictureGroup.pictureGroup count];
            if (pictureCount >0)
            {
                //                <article data-pl="hdpics_group" class="M_groupimg">
                //                <div class="groupimg_w" ui-hdslides="" style="position: relative;">
                //                <ul style="width: 2540px;">
                //                <li style="height: 228px; width: 200px;">
                //                <div class="photo_k" style="width:190px;">
                //                <span class="photo" tap-params="method:hdImageGroupClick;pos:1;offset:1;groupIndex:;index:0;extra:;" ui-imgbox="" link-status="disabled">
                //                <img src="http://r3.sinaimg.cn/10230/2014/0620/d3/3/45486174/auto.jpg" data-src="http://r3.sinaimg.cn/10230/2014/0620/d3/3/45486174/auto.jpg" style="width:190px; height:228px;">
                //                </span>
                //                </div>
                //                </li>
                
                [pictureGroupHtml appendString:@"<article data-pl=\"hdpics_group\" class=\"M_groupimg\"><div class=\"groupimg_w\" ui-hdslides=\"\" style=\"position: relative;\">"];
                
                NSUInteger groupIndex = [article.hdPictureGroupList indexOfObject:pictureGroup];
                // ul开始
                [pictureGroupHtml appendFormat:@"<ul  style=\"width:%dpx;\">",pictureGroup.totalWidth];
                
                // li
                SNArticlePicture *articlePicture = nil;
                for (int i = 0; i < pictureCount; ++i)
                {
                    articlePicture = [pictureGroup.pictureGroup objectAtIndexSafely:i];
                    
                    if (articlePicture)
                    {
                        NSString *tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount + imageTagIdx];
                        
                        [pictureGroupHtml appendFormat:@"<li style=\"width:%ldpx;height:%ldpx;\">",(long)(articlePicture.width + 10),(long)articlePicture.height];
                        [pictureGroupHtml appendFormat:@"<div class=\"photo_k\" style=\"width:%ldpx;\">",(long)articlePicture.width];
                        [pictureGroupHtml appendFormat:@"<span class=\"photo\" tap-params=\"method:imageGroupClick;pos:1;groupIndex:%lu;index:%d;tagId:%@;type:%d\" ui-imgbox link-status=\"disabled\">",(unsigned long)groupIndex,i,tagId,ArticlePicGroupTypeHdpicsGroup];
                        [pictureGroupHtml appendFormat:@"<img id=\"%@\" data-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='block'\" style=\"width:%ldpx; height:%ldpx;\"/>",tagId,tagId,tagId,(long)(articlePicture.width),(long)articlePicture.height];
                        [pictureGroupHtml appendFormat:@"</span></div></li>"];
                        
                        imageTagIdx ++;
                    }
                }
                
                // ul关闭
                [pictureGroupHtml appendFormat:@"</ul>"];
                
                [pictureGroupHtml appendString:@"</div>"];
                [pictureGroupHtml appendFormat:@"<h4 class=\"group_title\">%@</h4>",pictureGroup.title];
                
                [pictureGroupHtml appendString:@"</article>"];
            }
            
            article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_HDPIC_GROUP,idx+1] withString:pictureGroupHtml];
            
            idx++;
        }
    }
}

#pragma mark - 图集
//高清图集
- (void)parseHDPicsModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *pictureModuleArray = [dict objectDataForKeySafely:@"hdpicsModule"];
    if (![pictureModuleArray isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    if([pictureModuleArray count] == 0)
    {
        return ;
    }
    
    article.hdPicsModuleList = pictureModuleArray;
}

//普通图集
- (void)parsePicsModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *pictureModuleArray = [dict objectDataForKeySafely:@"picsModule"];
    if ([pictureModuleArray isKindOfClass:[NSArray class]])
    {
        NSInteger moduleCount = [pictureModuleArray count];
        // 存在图片组
        if (moduleCount > 0)
        {
            // 创建图片组数组
            NSMutableArray *articlePicModuleArray = [[NSMutableArray alloc] initWithCapacity:[pictureModuleArray count]];
            
            // 遍历图片组数组,每一个dictionary代表一个图片组
            for (NSDictionary *pictureModuleDictionary in pictureModuleArray)
            {
                if ([pictureModuleDictionary isKindOfClass:[NSDictionary class]])
                {
                    NSArray *picArray = [pictureModuleDictionary objectForKey:@"data"];
                    if ([picArray isKindOfClass:[NSArray class]])
                    {
                        if ([picArray count] > 0)
                        {
                            // 创建一个图片组
                            SNArticlePictureGroup * articlePicGroup = [[SNArticlePictureGroup alloc] init];
                            if (nil == articlePicGroup.pictureGroup)
                            {
                                NSMutableArray * temp = [[NSMutableArray alloc] init];
                                articlePicGroup.pictureGroup = temp;
                            }
                            
                            //遍历图片组的图片
                            for (NSDictionary *pictureDictionary in picArray)
                            {
                                if ([pictureDictionary isKindOfClass:[NSDictionary class]])
                                {
                                    // 创建一个图片
                                    SNArticlePicture *articlePicture = [[SNArticlePicture alloc] init];
                                    articlePicture.picUrl = SNString([pictureDictionary objectForKey:@"kpic"], @"");
                                    articlePicture.gifUrl = SNString([pictureDictionary objectForKey:@"gif"], @"");
                                    articlePicture.picAlt = SNString([pictureDictionary objectForKey:@"alt"], @"");
                                    articlePicture.height = SNInt([pictureDictionary objectForKey:@"height"], 0);
                                    articlePicture.width = SNInt([pictureDictionary objectForKey:@"width"], 0);
                                    articlePicture.isCover = SNBool([pictureDictionary objectForKey:@"isCover"], NO);
                                    // 把图片加入图片组
                                    [articlePicGroup.pictureGroup addObject:articlePicture];
                                }
                            }
                            
                            // 把图片组加入图片组数组
                            [articlePicModuleArray addObject:articlePicGroup];
                        }
                    }
                }
            }
            
            // 设置正文图片组
            article.picsModuleList = articlePicModuleArray;
        }
    }
}

/*
 
 获取图集的html
 
 prarams:
 
 covers:封面集合
 title:图集标题
 count:图集图片总数
 index:当前图集在同图集类型中的索引
 groupType:图集类型
 
 */
- (NSString *)getHtmlWithCovers:(NSArray *)covers
                          title:(NSString *)title
                          count:(long)count
                          index:(int)index
                      groupType:(ArticlePicGroupType)groupType
{
    if(covers.count <= 1)
    {
        return @"";
    }
    NSMutableString *html = [NSMutableString string];
    
    SNArticleImage *firstImage = [covers firstObject];
    
    [html appendFormat:@"<article class=\"M_puzzlepic\" data-pl>"];
    [html appendFormat:@"<div class=\"list\">"];
    [html appendFormat:@"<div class=\"photos\" ui-imgsbox ui-link=\"method:imageGroupClick;pos:1;groupIndex:%d;tagId:%@;type:%d\">",index,firstImage.tagId,groupType];
    
    if(covers.count == 3)
    {
        SNArticleImage *img1 = [covers objectAtIndexSafely:0];

        //左侧图片
        [html appendFormat:@"<div class=\"l_side photo_k\">"];
        
        [html appendFormat:@"<div class=\"photo p_2_3\">"];
        [html appendFormat:@"<span class=\"item\">"];
        [html appendFormat:@"<img id=\"%@\" datas-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img1.tagId,img1.tagId,img1.tagId];
        [html appendFormat:@"</span>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</div>"];
        
        // 右侧图片
        [html appendFormat:@"<div class=\"r_side photo_k\">"];
        //后两张图
        for(int i = 1;i<covers.count;i++)
        {
            SNArticleImage *img = [covers objectAtIndexSafely:i];
            
            [html appendFormat:@"<div class=\"photo p_4_3\">"];
            [html appendFormat:@"<span class=\"item\">"];
            [html appendFormat:@"<img id=\"%@\" datas-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img.tagId,img.tagId,img.tagId];
            [html appendFormat:@"</span>"];
            [html appendFormat:@"</div>"];
        }
    }
    else if(covers.count == 4)
    {
        //左侧图片
        [html appendFormat:@"<div class=\"l_side photo_k\">"];
        for(int i = 0;i<2;i++)
        {
            SNArticleImage *img = [covers objectAtIndexSafely:i];
            
            [html appendFormat:@"<div class=\"photo p_3_2\">"];
            [html appendFormat:@"<span class=\"item\">"];
            [html appendFormat:@"<img id=\"%@\" datas-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img.tagId,img.tagId,img.tagId];
            [html appendFormat:@"</span>"];
            [html appendFormat:@"</div>"];
        }
        [html appendFormat:@"</div>"];
        
        // 右侧图片
        [html appendFormat:@"<div class=\"r_side photo_k\">"];
        for(int i = 2;i<4;i++)
        {
            SNArticleImage *img = [covers objectAtIndexSafely:i];
            
            [html appendFormat:@"<div class=\"photo p_3_2\">"];
            [html appendFormat:@"<span class=\"item\">"];
            [html appendFormat:@"<img id=\"%@\" datas-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img.tagId,img.tagId,img.tagId];
            [html appendFormat:@"</span>"];
            [html appendFormat:@"</div>"];
        }
    }
    else if(covers.count == 5)
    {
        //左侧图片
        [html appendFormat:@"<div class=\"l_side photo_k\">"];
        for(int i = 0;i<2;i++)
        {
            SNArticleImage *img = [covers objectAtIndexSafely:i];
            
            [html appendFormat:@"<div class=\"photo p_1_1\">"];
            [html appendFormat:@"<span class=\"item\">"];
            [html appendFormat:@"<img id=\"%@\" datas-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img.tagId,img.tagId,img.tagId];
            [html appendFormat:@"</span>"];
            [html appendFormat:@"</div>"];
        }
        [html appendFormat:@"</div>"];
        
        // 右侧图片
        [html appendFormat:@"<div class=\"r_side photo_k\">"];
        for(int i = 2;i<5;i++)
        {
            SNArticleImage *img = [covers objectAtIndexSafely:i];
            
            [html appendFormat:@"<div class=\"photo p_3_2\">"];
            [html appendFormat:@"<span class=\"item\">"];
            [html appendFormat:@"<img id=\"%@\" datas-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img.tagId,img.tagId,img.tagId];
            [html appendFormat:@"</span>"];
            [html appendFormat:@"</div>"];
        }
    }
    [html appendFormat:@"</div>"];
    [html appendFormat:@"<p class=\"total\">%ld图</p>",count];
    
    [html appendFormat:@"</div>"];
    [html appendFormat:@"<h4>%@</h4>",title];
    [html appendFormat:@"</div>"];
    [html appendFormat:@"</article>"];
    
    return html;
}

//处理高清图集
- (void)handleHDPicsModuleInArticle:(SNArticle *)article
{
    if(article.hdPicsModuleList.count == 0)
    {
        return;
    }
    
    int idx = 0;
    for(NSDictionary *picsModule in article.hdPicsModuleList)
    {
        NSArray *groupArray = [picsModule objectForKeySafely:@"data"];
        if(!CHECK_VALID_ARRAY(groupArray))
        {
            continue;
        }
        //单个图集
        if(groupArray.count == 1)
        {
            //图集信息
            NSDictionary *picModule = [groupArray firstObject];
            
            if(!CHECK_VALID_DICTIONARY(picModule))
            {
                continue;
            }
            
            //封面数组
            NSArray *coverArray = [picModule objectForKeySafely:@"covers"];
            if(!CHECK_VALID_ARRAY(coverArray))
            {
                continue;
            }
            
            NSMutableArray *tempArray = [NSMutableArray array];
            NSInteger coverCount = coverArray.count;
            
            //封面数量容错,4.8.1只支持1,3,4,5的样式
            if(coverCount == 2)
            {
                coverCount = 1;
            }
            else if(coverCount >5)
            {
                coverCount = 5;
            }
            
            //遍历图片组的图片
            for (int i = 0;i<coverCount;i++)
            {
                //封面图片信息
                NSDictionary *cover = [coverArray objectAtIndexSafely:i];
                
                if(!CHECK_VALID_DICTIONARY(cover))
                {
                    continue;
                }
                NSUInteger articleImageCount = article.articleImageArray.count;
                
                NSString *tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount];
                
                SNArticleImage * img = [[SNArticleImage alloc] init];
                img.url = SNString([cover objectForKey:@"kpic"], @"");
                //根据封面数量处理图片
                switch (coverCount) {
                    case 1:
                    {
                        img.width = ArticleGroupImage_Width;
                        img.height = ArticleGroupImage_Height;
                        
                        //                img.NOScale = YES;
                        //若有宽高
                        if ([cover objectForKeySafely:@"width"] && [cover objectForKeySafely:@"height"])
                        {
                            
                            //宽
                            img.width = SNInt([cover objectForKey:@"width"] , 0);
                            //高
                            img.height = SNInt([cover objectForKey:@"height"] , 0);
                            if(img.width >kBigImage_Width)
                            {
                                float scale = kBigImage_Width/img.width;
                                img.width = kBigImage_Width;
                                img.height = img.height * scale;
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        //共3张图的第1张图
                        if(i == 0)
                        {
                            img.width = ArticleModuleCover_3_L_Width;
                            img.height = ArticleModuleCover_3_L_Height;
                            img.needCut = YES;
                            img.doZoom = YES;
                        }
                        //共3张图的第2,3张图
                        else
                        {
                            img.width = ArticleModuleCover_3_R_Width;
                            img.height = ArticleModuleCover_3_R_Height;
                            img.needCut = YES;
                            img.doZoom = YES;
                        }
                    }
                        break;
                    case 4:
                    {
                        img.width = ArticleModuleCover_4_Width;
                        img.height = ArticleModuleCover_4_Height;
                        img.needCut = YES;
                        img.doZoom = YES;
                    }
                        break;
                    case 5:
                    {
                        //共5张图的第1,2张图
                        if(i == 0 || i == 1)
                        {
                            img.width = ArticleModuleCover_5_L_Width;
                            img.height = ArticleModuleCover_5_L_Height;
                            img.needCut = YES;
                            img.doZoom = YES;
                        }
                        //共5张图的第3,4,5张图
                        else
                        {
                            img.width = ArticleModuleCover_5_R_Width;
                            img.height = ArticleModuleCover_5_R_Height;
                            img.needCut = YES;
                            img.doZoom = YES;
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                
                img.tagId = tagId;
                
                [article.articleImageArray addObject:img];
                [tempArray addObject:img];
            }
            
            NSString *html;
            
            if(tempArray.count == 1)
            {
                NSMutableString *tempHtml = [NSMutableString string];
                SNArticleImage *img = tempArray.firstObject;
                NSString *styleWidth = @"";
                NSString *smallStyle = @"";
                if(img.width <= kBigImage_Width)
                {
                    styleWidth = [NSString stringWithFormat:@"style=\"width:%dpx;\"",img.width];
                    smallStyle = @" M_picsmall";
                }
                
                [tempHtml appendFormat:@"<article %@ data-pl=\"pics-module\" class=\"M_picf%@\" ui-night ui-link=\"method:imageGroupClick;pos:1;groupIndex:%d;tagId:%@;type:%d\">",styleWidth,smallStyle,idx,img.tagId,ArticlePicGroupTypeHdpicsModule];
                [tempHtml appendFormat:@"<div class=\"M_pic\">"];
                [tempHtml appendFormat:@"<div class=\"bigphoto\">"];
                [tempHtml appendFormat:@"<div style=\"height:%dpx;\" ui-imgbox=\"\" >",img.height];
                [tempHtml appendFormat:@"<img id=\"%@\" data-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",img.tagId,img.tagId,img.tagId];
                [tempHtml appendFormat:@"<span class=\"icon\">%ld图</span>",(long)([[picModule objectForKeySafely:@"count"] integerValue])];
                [tempHtml appendFormat:@"</div>"];
                [tempHtml appendFormat:@"</div>"];
                [tempHtml appendFormat:@"<h4>%@</h4>",[picModule objectForKeySafely:@"title"]];
                [tempHtml appendFormat:@"</article>"];
                html = [NSString stringWithString:tempHtml];
            }
            else
            {
                html = [self getHtmlWithCovers:tempArray
                                         title:SNString([picModule objectForKeySafely:@"title"], @"")
                                         count:(long)([[picModule objectForKeySafely:@"count"] integerValue])
                                         index:idx
                                     groupType:ArticlePicGroupTypeHdpicsModule];
            }
            
            article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_HDPIC_MODULE,idx+1] withString:html];
        }
        //多个滑动图集
        else if(groupArray.count > 1)
        {
            NSMutableString *pictureGroupHtml = [NSMutableString string];
            
            [pictureGroupHtml appendFormat:@"<article data-pl=\"hdpics_module\" class=\"M_hdgroupimg\">"];
            [pictureGroupHtml appendFormat:@"<div class=\"groupimg_w\" ui-slides>"];
            [pictureGroupHtml appendFormat:@"<ul style=\"width:%ld%%;\">",(long)(groupArray.count*100)];
            
            for(int i = 0;i<groupArray.count;i++)
            {
                NSDictionary *dict = [groupArray objectAtIndexSafely:i];
                if(!CHECK_VALID_DICTIONARY(dict))
                {
                    continue;
                }
                //获取封面
                NSDictionary *pic = [dict objectForKeySafely:@"pic"];
                
                if(CHECK_VALID_DICTIONARY(pic))
                {
                    NSUInteger articleImageCount = article.articleImageArray.count;
                    NSString *tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount];
                    
                    SNArticleImage * img = [[SNArticleImage alloc] init];
                    img.url = SNString([pic objectForKey:@"kpic"], @"");
                    img.width = ArticleScrollGroupImage_Width;
                    img.height = ArticleScrollGroupImage_Height;
                    img.tagId = tagId;
                    
                    img.needCut = YES;
                    img.NOScale = YES;
                    img.doZoom = YES;
                    
                    [article.articleImageArray addObject:img];
                    
                    NSString *imageStyle = @"";
                    
                    [pictureGroupHtml appendFormat:@"<li style=\"width:%g%%;\" >",(float)(100.0/groupArray.count)];
                    [pictureGroupHtml appendFormat:@"<div class=\"photo_k\" style=\"height:%dpx;\">",img.height];
                    [pictureGroupHtml appendFormat:@"<div class=\"photo\" ui-imgbox ui-link=\"method:imageGroupClick;pos:1;groupIndex:%d;tagId:%@;type:%d;index:%d;\">",idx,tagId,ArticlePicGroupTypeHdpicsModule,i];
                    [pictureGroupHtml appendFormat:@"<div class=\"title\">"];
                    [pictureGroupHtml appendFormat:@"<span clsss=\"p_txt\">%@</span>",[dict objectForKeySafely:@"title"]];
                    [pictureGroupHtml appendFormat:@"<span clsss=\"p_num\">%ld图</span>",(long)([[dict objectForKeySafely:@"count"] integerValue])];
                    [pictureGroupHtml appendFormat:@"</div>"];
                    [pictureGroupHtml appendFormat:@"<img %@ id=\"%@\" data-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/>",imageStyle,tagId,tagId,tagId];
                    [pictureGroupHtml appendFormat:@"</div>"];
                    [pictureGroupHtml appendFormat:@"</div>"];
                    
                    [pictureGroupHtml appendFormat:@"</li>"];
                }
            }
            [pictureGroupHtml appendFormat:@"</ul>"];
            [pictureGroupHtml appendFormat:@"</div>"];
            [pictureGroupHtml appendFormat:@"</article>"];
            
            article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_HDPIC_MODULE,idx+1] withString:pictureGroupHtml];
        }
        idx++;
    }
}

//处理普通图集
- (void)handlePicsModuleInArticle:(SNArticle *)article
{
    if(article.picsModuleList.count == 0)
    {
        return;
    }
    
    NSUInteger articleImageCount = article.articleImageArray.count;
    
    if (article.picsModuleList.count > 0) {
        
        int idx = 0;
        for (SNArticlePictureGroup * pictureGroup in article.picsModuleList )
        {
            pictureGroup.coverList = [NSMutableArray array];
            for (SNArticlePicture * articlePic in pictureGroup.pictureGroup )
            {
                if(articlePic.isCover)
                {
                    [pictureGroup.coverList addObject:articlePic];
                }
                SNArticleImage * img = [[SNArticleImage alloc] init];
                img.url = articlePic.picUrl;
                //默认宽高
                img.width = ArticleGroupImage_Width;
                img.height = ArticleGroupImage_Height;
                img.gifUrl = articlePic.gifUrl;
                //默认剪切
                img.needCut = YES;
                //                img.NOScale = YES;
                //若有宽高
                if (articlePic.height > 0 && articlePic.width > 0)
                {
                    //宽
                    img.width = (int)articlePic.width;
                    //高
                    img.height = (int)articlePic.height;
                    
                    if(img.width >kBigImage_Width)
                    {
                        float scale = kBigImage_Width/img.width;
                        img.width = kBigImage_Width;
                        img.height = img.height * scale;
                    }
                    img.needCut = NO;
                }
                
                img.tagId = [SNArticleManager tagIDWithImageIndex:articleImageCount + idx];
                img.description = articlePic.picAlt;
                
                articlePic.tagId = img.tagId;
                [article.articleImageArray addObject:img];
                
                idx++;
            }
        }
    }
    
    //若是高清图集新闻,则不做后边的处理
    if([article.articleID hasSuffix:@"hdpic"])
    {
        return;
    }
    
    // 有图组模块,进行替换
    if ([article.picsModuleList count] > 0)
    {
        
        int idx = 0;
        
        for (SNArticlePictureGroup * pictureGroup in article.picsModuleList )
        {
            NSMutableString *pictureGroupHtml = [NSMutableString string];
            
            NSInteger coverCount = pictureGroup.coverList.count;
            
            //封面数量容错,4.8.1只支持1,3,4,5的样式
            if(coverCount == 2)
            {
                coverCount = 1;
            }
            else if(coverCount >5)
            {
                coverCount = 5;
            }
            
            if(coverCount <= 1)
            {
                SNArticlePicture *articlePic;
                //若有一张封面图,则取这张
                if(pictureGroup.coverList.count >= 1)
                {
                    articlePic = [pictureGroup.coverList firstObject];
                }
                //若没有封面图,则取第一张图片
                else
                {
                    articlePic = [pictureGroup.pictureGroup firstObject];
                }
                
                int heightShouldShow = ArticleGroupImage_Height;
                int widthShouldShow = ArticleGroupImage_Width;
                //若有宽高
                if (articlePic.height > 0 && articlePic.width > 0)
                {
                    //宽
                    widthShouldShow = (int)articlePic.width;
                    //高
                    heightShouldShow = (int)articlePic.height;
                    
                    if(widthShouldShow >kBigImage_Width)
                    {
                        float scale = kBigImage_Width/widthShouldShow;
                        widthShouldShow = kBigImage_Width;
                        heightShouldShow = heightShouldShow * scale;
                    }
                }
                
                
                
                NSString *tagId = [SNArticleManager tagIDWithImageIndex:article.articleImageArray.count];
                
                SNArticleImage * img = [[SNArticleImage alloc] init];
                img.url = articlePic.picUrl;
                img.width = widthShouldShow;
                img.height = heightShouldShow;
                img.tagId = tagId;
                img.description = articlePic.picAlt;
                
                articlePic.tagId = img.tagId;
                
                [article.articleImageArray addObject:img];
                
                NSString *styleWidth = @"";
                NSString *smallStyle = @"";
                if(widthShouldShow <= kBigImage_Width)
                {
                    styleWidth = [NSString stringWithFormat:@"style=\"width:%dpx;\"",widthShouldShow];
                    smallStyle = @" M_picsmall";
                }
                
                [pictureGroupHtml appendFormat:@"<article %@ data-pl=\"pics-module\" class=\"M_picf%@\" ui-night ui-link=\"method:imageGroupClick;pos:1;groupIndex:%d;tagId:%@;type:%d\">",styleWidth,smallStyle,idx,tagId,ArticlePicGroupTypePicsModule];
                [pictureGroupHtml appendFormat:@"<div class=\"M_pic\">"];
                [pictureGroupHtml appendFormat:@"<div class=\"bigphoto\">"];
                [pictureGroupHtml appendFormat:@"<div style=\"height:%dpx;\" ui-imgbox=\"\"   >",heightShouldShow];
                [pictureGroupHtml appendFormat:@"<img  id=\"%@\" data-src=\"%@\" src=\"[%@]\" onerror=\"this.style.display='none'\" onload=\"this.style.display='block'\"/>",tagId,tagId,tagId];
                [pictureGroupHtml appendFormat:@"<span class=\"icon\">%lu图</span>",(unsigned long)([pictureGroup.pictureGroup count])];
                [pictureGroupHtml appendFormat:@"</div>"];
                [pictureGroupHtml appendFormat:@"</div>"];
                [pictureGroupHtml appendFormat:@"<h4></h4>"];
                [pictureGroupHtml appendFormat:@"</article>"];
            }
            else
            {
                

                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i =0;i< coverCount;i++ )
                {
                    SNArticlePicture * articlePic = [pictureGroup.coverList objectAtIndexSafely:i];
                    
                    SNArticleImage * img = [[SNArticleImage alloc] init];
                    img.url = articlePic.picUrl;
                    
                    //根据封面数量处理图片
                    switch (coverCount) {
                        case 3:
                        {
                            //共3张图的第1张图
                            if(i == 0)
                            {
                                img.width = ArticleModuleCover_3_L_Width;
                                img.height = ArticleModuleCover_3_L_Height;
                            }
                            //共3张图的第2,3张图
                            else
                            {
                                img.width = ArticleModuleCover_3_R_Width;
                                img.height = ArticleModuleCover_3_R_Height;
                            }
                        }
                            break;
                        case 4:
                        {
                            img.width = ArticleModuleCover_4_Width;
                            img.height = ArticleModuleCover_4_Height;
                        }
                            break;
                        case 5:
                        {
                            //共5张图的第1,2张图
                            if(i == 0 || i == 1)
                            {
                                img.width = ArticleModuleCover_5_L_Width;
                                img.height = ArticleModuleCover_5_L_Height;
                            }
                            //共5张图的第3,4,5张图
                            else
                            {
                                img.width = ArticleModuleCover_5_R_Width;
                                img.height = ArticleModuleCover_5_R_Height;
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    img.needCut = YES;
                    img.doZoom = YES;
                    
                    NSString *tagId = [SNArticleManager tagIDWithImageIndex:article.articleImageArray.count];
                    
                    img.tagId = tagId;
                    img.description = articlePic.picAlt;
                    
                    articlePic.tagId = img.tagId;
                    [article.articleImageArray addObject:img];
                    [tempArray addObject:img];
                }
                
                NSString *str = [self getHtmlWithCovers:tempArray
                                                  title:SNString(pictureGroup.title, @"")
                                                  count:pictureGroup.pictureGroup.count
                                                  index:idx
                                              groupType:ArticlePicGroupTypePicsModule];
                pictureGroupHtml = [NSMutableString stringWithString:str];
            }
            article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_PIC_MODULE,idx+1] withString:pictureGroupHtml];
            
            idx++;
        }
    }
}



#pragma mark ----- 单张图

//处理单张图
- (void)parseImgWithDict:(NSDictionary *)dict
               inArticle:(SNArticle *)article
{
    
    /*-----------------------Img handel raw data-----------------------*/
    
    //全部图片
    NSMutableArray  * allImgArray = [[NSMutableArray alloc] init];
    
    //遍历
    [[dict objectDataForKeySafely:@"pics"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop)
     {
         @autoreleasepool
         {
             //是否已经加入到了全部图片数组
             BOOL added = NO;
             
             NSDictionary *data = [obj objectForKey:@"data"];
             
             //创建图片对象
             SNArticleImage * img = [[SNArticleImage alloc] init];
             
             img.url = SNString([data objectForKey:@"kpic"], @"");
             
            img.gifUrl = SNString([data objectForKey:@"gif"], nil);
             
             img.description = SNString([data objectForKey:@"alt"], @"");
             
             //若有宽高
             if ([data objectForKeySafely:@"width"] &&
                 [data objectForKeySafely:@"height"]&&
                 [[data objectForKeySafely:@"width"] integerValue]!=0 &&
                 [[data objectForKeySafely:@"height"] integerValue] != 0)
             {
                 //宽
                 img.width = SNInt([data objectForKey:@"width"], 0);
                 //高
                 img.height = SNInt([data objectForKey:@"height"], 0);
                 
                 if (self.isNBA) {
                     if (img.gifUrl == nil || [img.gifUrl isEqualToString:@""]) {
                         if (![img.url containsString:@"gif"]) {
                             [allImgArray addObject:img];
                         }
                     }
                 }else {
                       [allImgArray addObject:img];
                 }
                 added = YES;
             }
             //若没有高度和宽度，直接加入
             else
             {
                 if (self.isNBA) {
                     if (img.gifUrl == nil || [img.gifUrl isEqualToString:@""]) {
                         if (![img.url containsString:@"gif"]) {
                               [allImgArray addObject:img];
                         }
                     }
                 }else {
                     [allImgArray addObject:img];
                 }
                 added = YES;
             }
             
             //若已经被加入数组
             if (added)
             {
                 //html获取对应的标签
                 img.tagId = [SNArticleManager tagIDWithImageIndex:idx];
             }
         }
     }];
    
    //正文中要展示的图片
    NSMutableArray * articleImgArray = [[NSMutableArray alloc] init];
    
    //将全部图片放入到要展示的图片组
    [articleImgArray setArray:allImgArray];
    
    /*-----------------------replac with tag-----------------------*/
    // replace content with img tag
    //若本文章非高清图类型
//    if ( ![abstract isKindOfClass:[HDPicAbstract class]] )
//    {
        int idx = 0;
        //遍历要在正文中展示的图片
        for (SNArticleImage * obj in articleImgArray )
        {
            //若图片不可展示,则不替换content
            if (![obj canShow])
            {
                idx++;
                continue;
            }
            
            //获取图片对应标签
            NSString * imgTag = [SNArticleParser imgTagWithArticleImg:obj];
            //替换content中占位符
            article.content = [article.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_IMG,idx+1] withString:imgTag];
            idx++;
        }
//    }
    
    [article.articleImageArray addObjectsFromArray:articleImgArray];
}

// 图片对应的html标签
+ (NSString *)imgTagWithArticleImg:(SNArticleImage *)articleImg
{
    NSString * imgTag = nil;
    BOOL isGif = [articleImg isGif];
    
    imgTag = [SNArticleParser bigImageTagTemplate:isGif];
    
    if(articleImg.gifUrl)
    {
        NSString *gifInfo = [NSString stringWithFormat:@"data-gif=\"%@\"",articleImg.gifUrl];
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[GIFINFO]" withString:gifInfo];
    }
    else if(articleImg.url)
    {
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[GIFINFO]" withString:@""];
    }
    else
    {
        return @"";
    }
    
    //若图片宽度比展示区域宽度小
    if(articleImg.width < kBigImage_Width)
    {
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[ISSMALL]" withString:@"M_picsmall"];
        NSString *smallStyle = [NSString stringWithFormat:@"style=\"width:%dpx;\"",(int)(articleImg.width)];
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[SMALLSTYLE]" withString:smallStyle];
    }
    else
    {
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[ISSMALL]" withString:@""];
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[SMALLSTYLE]" withString:@""];
    }
    
    int /*width = 0,*/height = 0;
    if (articleImg.width <= 0)
    {
        //            width = kBigImage_Width;
        height = kBigImage_Width*3/4.0;
    }
    else if (articleImg.height <= 0 && height == 0)
    {
        //            width = kBigImage_Width;
        height = kBigImage_Width*3/4.0;
    }
    else
    {
        height = articleImg.height;
        
        if(articleImg.width > kBigImage_Width)
        {
            float scaleTemp = kBigImage_Width/(articleImg.width);
            height = height * scaleTemp;
        }
    }
    
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[realImageHeight]" withString:[NSString stringWithFormat:@"%d",height]];
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[IMAGEAUTOHEIGHT]" withString:[NSString stringWithFormat:@"%d",height]];
    
    NSString *gifIndex = articleImg.gifUrl?@"flag=\"0\"":@"";
    NSString *gifTag = articleImg.gifUrl?@"<span class=\"icon\">GIF</span>":@"";
    NSString *gifdiv = articleImg.gifUrl?@"<div class=\"C_gifloading C_loading\" style=\"display:none;\"></div>":@"";
    
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[GIFINDEX]" withString:gifIndex];
    
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[GIFTAG]" withString:gifTag];
    
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[GIFDIV]" withString:gifdiv];
    
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[IMAGEURLID]" withString:articleImg.tagId];
    
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[DATASRC]" withString:articleImg.url];
    
    // decription
    imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[IMGDESCRIPTION]" withString:(articleImg.description==nil)?@"":articleImg.description];
    
    // 组图
    if ([articleImg isKindOfClass:[SNArticleGroupImage class]])
    {
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[GROUPHIDE]" withString:@"show"];
        imgTag = [imgTag stringByReplacingOccurrencesOfString:@"[ImageCount]" withString:[NSString stringWithFormat:@"%lu图",(unsigned long)([((SNArticleGroupImage *)articleImg).groupImgs count]+1)]];
    }
    return imgTag;
}

//大图模板
+ (NSString *)bigImageTagTemplate:(BOOL)isGif
{
    NSString * tag = nil;
    tag =
    @"<article data-pl=\"pic\" class=\"M_picf [ISSMALL]\" [SMALLSTYLE] ui-night ui-link=\"method:imgClick;pos:1;pic:[IMAGEURLID]\" [GIFINDEX]>\
    <div class=\"M_pic\">\
    <div class=\"bigphoto\">\
    <div class=\"C_gif\" style=\"height:[realImageHeight]px;\" ui-imgbox=\"\"  >\
    [GIFDIV]\
    <img id=\"[IMAGEURLID]\" src data-src=\"[IMAGEURLID]\"  onerror=\"this.style.display='none'\" onload=\"this.style.display='inline';this.parentNode.style.height='[IMAGEAUTOHEIGHT]px'\" [GIFINFO]/>\
    </div>\
    [GIFTAG]\
    </div>\
    <h4>[IMGDESCRIPTION]</h4>\
    </article>";
    
    
    //    //gif图需要自动调节高度
    //    if(isGif)
    //    {
    //        tag = [tag stringByReplacingOccurrencesOfString:@"[IMAGEAUTOHEIGHT]" withString:@";this.parentNode.style.height='auto'"];
    //    }
    //    else
    //    {
    //        tag = [tag stringByReplacingOccurrencesOfString:@"[IMAGEAUTOHEIGHT]" withString:@";this.parentNode.style.height='auto'"];
    //    }
    
    return tag;
}

//小图模板
+ (NSString *)smallImageTagTemplate
{
    return @"<dl class=\"smallphoto\">\
    <dt ui-imgbox=\"\" ui-link=\"method:imgClick;pos:1;pic:[IMAGEURLID]\">\
    <img onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\" id=\"[IMAGEURLID]\" src=\"[[IMAGEURLID]]\" data-src=\"[IMAGEURLID]\" width=\"[realImageWidth]px\" height=\"[realImageHeight]px\">\
    <div class=\"bg\"></div>\
    <span data-hide=\"[GROUPHIDE]\" class=\"icon\">[ImageCount]</span>\
    </dt>\
    </dl>";
}

@end
