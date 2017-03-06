//
//  SNArticleManager+Attitude.m
//  SNArticleDemo
//
//  Created by Boris on 16/2/22.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleManager+Attitude.h"
#import "NSString+SNArticle.h"
#import "SNCommonMacro.h"

@implementation SNArticleManager (Attitude)

#pragma mark - get from dataInfo

//获取态度文案
+ (NSString *)getAttitudeTextWithAttitudeInfo:(SNAttitudeInfo *)attitudeInfo
                                 attitudeType:(ArticleAttitude)attitude
                                   currentNum:(NSInteger)currentNum
                              currentAttitude:(ArticleAttitude)currentAttitude
{
    NSMutableString *string = [NSMutableString string];
    
    if(!attitudeInfo)
    {
        return @"";
    }
    
    NSArray *array = nil;
    
    if(attitude == ArticleAttitudePraise)
    {
        array = attitudeInfo.praiseAttitudes;
    }
    else if(attitude == ArticleAttitudeDisPraise)
    {
        array = attitudeInfo.dispraiseAttitudes;
    }
    
    if(currentNum == 0)
    {
        return @"";
    }
    
    NSString *numString = [NSString numberToXWan:currentNum];
    //没有其他认证用户
    if(!CHECK_VALID_ARRAY(array))
    {
        //若用户的态度不是当前获取文案的态度
        if(currentAttitude != attitude)
        {
            [string appendFormat:@"%@人",numString];
        }
        //若用户的态度是当前获取文案的态度
        else
        {
            [string appendString:@"我"];
            if(currentNum <= 1)
            {
                [string appendString:@"1人"];
            }
            else
            {
                [string appendFormat:@"和新浪网友等%@人",numString];
            }
        }
    }
    //有其他认证用户
    else
    {
        //若用户的态度是当前获取文案的态度
        if(currentAttitude == attitude)
        {
            [string appendString:@"我和"];
        }
        
        NSUInteger count = array.count;
        
        //是否第一个名字
        BOOL isFirst = YES;
        //遍历其他认证用户
        for( int i = 0;i<count;i++)
        {
            //认证用户信息
            SNAttitude *attitude = [array objectAtIndexSafely:i];
            
            if(attitude)
            {
                NSString *name = attitude.userName;
                if(CHECK_VALID_STRING(name))
                {
                    //第一个名字之前不加顿号,其他都加
                    if(!isFirst)
                    {
                        [string appendFormat:@"、"];
                    }
                    [string appendFormat:@"%@",name];
                    isFirst = NO;
                }
            }
        }
        [string appendFormat:@"等%@人",numString];
    }
    
    if(attitude == ArticleAttitudePraise)
    {
        [string appendFormat:@"顶了这篇文章。"];
    }
    else if(attitude == ArticleAttitudeDisPraise)
    {
        [string appendFormat:@"踩了这篇文章。"];
    }
    
    return string;
}

//获取态度HTML文案
+ (NSString *)getAttitudeHtmlWithAttitudeInfo:(SNAttitudeInfo *)attitudeInfo
                                 attitudeType:(ArticleAttitude)attitude
                                   currentNum:(NSInteger)currentNum
                              currentAttitude:(ArticleAttitude)currentAttitude
                                      display:(BOOL)display
{
    NSMutableString *string = [NSMutableString string];
    
    if(!attitudeInfo)
    {
        return @"";
    }
    
    NSArray *array = nil;
    
    if(attitude == ArticleAttitudePraise)
    {
        array = attitudeInfo.praiseAttitudes;
    }
    else if(attitude == ArticleAttitudeDisPraise)
    {
        array = attitudeInfo.dispraiseAttitudes;
    }
    
    if(currentNum == 0)
    {
        return @"";
    }
    NSString *numString = [NSString numberToXWan:currentNum];
    
    if(display)
    {
        [string appendString:@"<p style=\"\">"];
    }else
    {
        [string appendString:@"<p style=\"display:none;\">"];
    }
    
    //没有其他认证用户
    if(!CHECK_VALID_ARRAY(array))
    {
        //若用户的态度不是当前获取文案的态度
        if(currentAttitude != attitude)
        {
            [string appendFormat:@"<span>%@</span>人",numString];
        }
        //若用户的态度是当前获取文案的态度
        else
        {
            [string appendString:@"我"];
            if(currentNum <= 1)
            {
                [string appendString:@"<span>1</span>人"];
            }
            else
            {
                [string appendFormat:@"和新浪网友等<span>%@</span>人",numString];
            }
        }
    }
    //有其他认证用户
    else
    {
        //若用户的态度是当前获取文案的态度
        if(currentAttitude == attitude)
        {
            [string appendString:@"我和"];
        }
        
        NSUInteger count = array.count;
        
        BOOL isFirst = YES;
        for( int i = 0;i<count;i++)
        {
            SNAttitude *attitude = [array objectAtIndexSafely:i];
            
            if(attitude)
            {
                NSString *name = attitude.userName;
                if(CHECK_VALID_STRING(name))
                {
                    //第一个名字之前不加顿号,其他都加
                    if(!isFirst)
                    {
                        [string appendFormat:@"、"];
                    }
                    isFirst = NO;
                    [string appendFormat:@"%@",name];
                }
            }
        }
        [string appendFormat:@"等<span>%@</span>人",numString];
    }
    
    
    if(attitude == ArticleAttitudePraise)
    {
        [string appendFormat:@"<span class=\"p_txt txt_up\">顶</span>了这篇文章。</p>"];
    }
    else if(attitude == ArticleAttitudeDisPraise)
    {
        [string appendFormat:@"<span class=\"p_txt txt_down\">踩</span>了这篇文章。</p>"];
    }
    
    return string;
}

@end
