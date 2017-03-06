//
//  SNAdParser.m
//  SNArticleDemo
//
//  Created by Boris on 15/12/30.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "SNArticleAdParser.h"
#import "SNArticleAD.h"
#import "SNArticleImageAD.h"

@implementation SNArticleADParser

#define kArticleADBottomText    @"bottomText"
#define kArticleADBottomBanner  @"bottomBanner"
#define kArticleADLink          @"link"
#define kArticleADTitle         @"title"
#define kArticleADMonitor       @"monitor"
#define kArticleADPV            @"pv"
#define kArticleADS             @"ads"

#ifdef Use_K_Picture
#define kArticleADBannerTitle         @"ktitle"
#else
#define kArticleADBannerTitle         @"title"
#endif

- (NSDictionary *)parseArticleAD:(id)dict
{
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if ( self.hasError  )
    {
        return nil;
    }
    
    NSMutableDictionary *result = nil;
    NSDictionary *dics = [data objectForKeySafely:kArticleADS];
    
    if (CHECK_VALID_DICTIONARY(dics))
    {
        result = [NSMutableDictionary dictionary];
        
        // 文字广告
        NSArray *textAdDicArray = [dics objectForKeySafely:kArticleADBottomText];
        if (CHECK_VALID_ARRAY(textAdDicArray))
        {
            NSMutableArray *textAdArray = [[NSMutableArray alloc] initWithCapacity:[textAdDicArray count]];
            
            for (NSDictionary *textAdDic in textAdDicArray)
            {
                if (CHECK_VALID_DICTIONARY(textAdDic))
                {
                    SNArticleAD *ad = [[SNArticleAD alloc] init];
                    ad.link = SNString([textAdDic valueForKeySafely:kArticleADLink], @"");
                    ad.title = SNString([textAdDic valueForKeySafely:kArticleADTitle], @"");
                    ad.monitor = [textAdDic valueForKeySafely:kArticleADMonitor];
                    ad.pv = [textAdDic valueForKeySafely:kArticleADPV];
                    
                    [textAdArray safeAddObject:ad];
                }
            }
            
            [result safeSetObject:textAdArray forKey:kArticleADBottomText];
        }
        
        // 图片广告
        NSArray *imageAdDicArray = [dics objectForKeySafely:kArticleADBottomBanner];
        if (CHECK_VALID_ARRAY(imageAdDicArray))
        {
            NSMutableArray *imageAdArray = [[NSMutableArray alloc] initWithCapacity:[imageAdDicArray count]];
            
            for (NSDictionary *imageAdDic in imageAdDicArray)
            {
                if (CHECK_VALID_DICTIONARY(imageAdDic))
                {
                    SNArticleImageAD *ad = [[SNArticleImageAD alloc] init];
                    ad.link = SNString([imageAdDic valueForKeySafely:kArticleADLink], @"");
                    ad.imageUrl = SNString([imageAdDic valueForKeySafely:kArticleADBannerTitle], @"");
                    ad.monitor = [imageAdDic valueForKeySafely:kArticleADMonitor];
                    ad.pv = [imageAdDic valueForKeySafely:kArticleADPV];
                    
                    [imageAdArray safeAddObject:ad];
                }
            }
            
            [result safeSetObject:imageAdArray forKey:kArticleADBottomBanner];
        }
    }
    return result;
}

@end