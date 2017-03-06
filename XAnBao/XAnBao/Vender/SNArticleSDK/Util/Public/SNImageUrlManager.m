//
//  NewsManager+ImageUrl.m
//  SinaNews
//
//  Created by na li on 12-7-31.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import "SNImageUrlManager.h"
//#ifdef iPad
//#import "SNNewsCellContants.h"
//#else
//#import "NewsCellContant.h"
//#endif

#import "SNArticleConstant.h"
#import "NSString+SNArticle.h"
#import "SNCommonMacro.h"

#define kImageDomain        @"l.sinaimg.cn"


//!!!如果使用K服务,所有图片的尺寸需要在白名单内,否则会无法获取到图片
// K服务相关文档:http://wiki.intra.sina.com.cn/pages/viewpage.action?pageId=22054155
//
// 固定码:iphone app为apl.
//
// K服务白名单列表:

@implementation SNImageUrlManager

#pragma 
#pragma mark --  change imageurl

+ (NSString*) imageUrlByAppendingSize:(NSString *)sourceImageUrl
                            withWidth:(NSInteger)width
                           withHeight:(NSInteger)height
                         withSolution:(NSInteger)solution
                             withClip:(BOOL)clipped
                                scale:(CGFloat)scale
                               doZoom:(BOOL)doZoom
{
    NSString * str = nil;
    
    if(!CHECK_VALID_STRING(sourceImageUrl))
    {
        return @"";
    }
    
    if ([sourceImageUrl containsString:kImageDomain])
    {
        NSInteger width_ = width* scale;
        NSInteger height_ = height* scale;
        
        // 获取图片类型
        NSString *imageUlrType = [[sourceImageUrl  componentsSeparatedByString:@"."] lastObject];
        if (!CHECK_VALID_STRING(imageUlrType))
        {
            imageUlrType = @"";
        }
        
        // 确立分割字符,查找替换的部分
        NSString *componentsSeparatedStr = [NSString stringWithFormat:@"original.%@",imageUlrType];
        
        // 查找替换范围
        NSRange range = [sourceImageUrl rangeOfString:componentsSeparatedStr options:NSBackwardsSearch];
        NSString *imageRuleString = @"";

        // original.jpg必须为后缀,使用替换串拼接K服务图片地址
        if ([sourceImageUrl hasSuffix:componentsSeparatedStr])
        {
            // 构建图片裁图字符串
            if (clipped)
            {
                if(doZoom)
                {
                    imageRuleString = [NSString stringWithFormat:@"w%ldh%ldt50l50q%ldz1apl.%@",(long)width_,(long)height_,(long)solution,imageUlrType];
                }
                else
                {
                    imageRuleString = [NSString stringWithFormat:@"w%ldh%ldt50l50q%ldapl.%@",(long)width_,(long)height_,(long)solution,imageUlrType];
                }
            }
            else
            {
                width_ = [self findNearestNumber:width_];
                
                imageRuleString = [NSString stringWithFormat:@"w%ldq%ldapl.%@",(long)width_,(long)solution,imageUlrType];
            }
            
            str = [sourceImageUrl stringByReplacingCharactersInRange:range withString:imageRuleString];
        }
    }
    
    if (str == nil)
    {
        str = sourceImageUrl;
    }
    return str;
}

+ (NSString*) imageUrlByAppendingSize:(NSString *)sourceImageUrl
                            withWidth:(NSInteger)width
                           withHeight:(NSInteger)height
                         withSolution:(NSInteger)solution
                             withClip:(BOOL)clipped
{
    return [SNImageUrlManager imageUrlByAppendingSize:sourceImageUrl
                                      withWidth:width
                                     withHeight:height
                                   withSolution:solution
                                       withClip:clipped
                                          scale:[UIScreen mainScreen].scale
                                         doZoom:NO];
}

+ (NSInteger)findNearestNumber:(NSInteger)inputNumber
{
    static NSArray *whiteWidthArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whiteWidthArray = @[@90L,@135L,@152L,@240L,@270L,@320,@360L,@480L,@640L,@720L,@750L,@830L,@1242L,@1362L];
    });
    
    NSInteger outputNumber = inputNumber;
    
    NSUInteger count = [whiteWidthArray count];
    if (count > 0) 
    {
        NSUInteger index = [whiteWidthArray indexOfObject:@(inputNumber) inSortedRange:NSMakeRange(0, count)options:NSBinarySearchingInsertionIndex usingComparator:^(id object0, id object1) {
            NSInteger number0 = [object0 integerValue];
            NSInteger number1 = [object1 integerValue];
            if (number0 < number1) return NSOrderedAscending;
            else if (number0 > number1) return NSOrderedDescending;
            else return NSOrderedSame;
        }];
        
        if (index >= count)
        {
            index = count - 1;
        }
        
        outputNumber = [whiteWidthArray[index] integerValue];
    }

    return outputNumber;
}



#pragma mark 正文图片地址

/*
 
 -----正文K服务白名单-----
 
 单条微博单张图片:
 ip4,5,6:   w448h448t50l50q75,w112h448t50l50q75,w448h112t50l50q75
 ip6+:      w168h672t50l50q75,w672h168t50l50q75,w672h672t50l50q75
 
 单条微博多张图片:
 all:       w134h134t50l50q75
 
 topBanner: 
 all:       w640h120t50l50q75
 
 adBanner:  
 all:       w560h120t50l50q75
 
 视频封面,普通图集,高清图集:
 ip4,5:     w560h420t50l50q75
 ip6:       w670h502t50l50q75
 ip6+:      w1032h774t50l50q75
 
 滑动图组,滑动高清图组:
 ip4,5:     w250h187t50l50q75
 ip6:       w305h228t50l50q75
 ip6+:      w344h258t50l50q75
 
 */
+ (NSString *)articleImgUrl:(SNArticleImage *)articleImage
{
    //是否要裁剪
    BOOL clip = articleImage.needCut;
    CGFloat scale = 1;
    
    //缩放比例
    if(articleImage.NOScale)
    {
        scale = 1;
    }
    else
    {
        scale = [UIScreen mainScreen].scale;
    }
    
    NSString *imageUrl = [SNImageUrlManager imageUrlByAppendingSize:articleImage.url
                                                        withWidth:articleImage.width
                                                       withHeight:articleImage.height
                                                     withSolution:Normal_Solution
                                                         withClip:clip
                                                            scale:scale
                                                           doZoom:articleImage.doZoom];
    return imageUrl;
}

/**
 * 正文广告banner
 * w:280*2
 * h:60*2
 */
+ (NSString *)articleBannerADImageUrl:(NSString *)sourceImageUrl
{
    return [SNImageUrlManager imageUrlByAppendingSize:sourceImageUrl withWidth:kArticleBannerADPicWidth withHeight:kArticleBannerADPicHeight withSolution:Normal_Solution withClip:YES];
}

+ (NSString *)originalImageUrl:(NSString *)sourceImageUrl
{
    return sourceImageUrl;
}

@end
