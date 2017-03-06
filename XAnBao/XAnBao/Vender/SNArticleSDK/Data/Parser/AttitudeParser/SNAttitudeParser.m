//
//  SNAttitudeParser.m
//  SinaNews
//
//  Created by Boris on 15-6-3.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNAttitudeParser.h"
#import "SNCommonMacro.h"
#import "SNCommonGlobalUtil.h"

@implementation SNAttitudeParser

// 5.0 接口重构，对其中部分字段名做了修改
- (SNSupportInfo *)parseAttitudeInfoWithDictionary:(NSDictionary *)dict abstractId:(NSString *)abstractId
{
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if ( self.hasError )
    {
        return nil;
    }
    
    if(!CHECK_VALID_DICTIONARY(data))
    {
        return nil;
    }

    SNSupportInfo *support;
    NSDictionary *supportInfoDict = [data objectForKey:@"careConfig"];
    if (CHECK_VALID_DICTIONARY(supportInfoDict)){
        support = [[SNSupportInfo alloc] init];
        support.isShow = SNBool(supportInfoDict[@"isShow"], NO);
        if (support.isShow){
            support.totalCount = [self convertDataToStr:supportInfoDict[@"count"] defaultValue:0];
            support.steep = [self convertDataToStr:supportInfoDict[@"steep"] defaultValue:1000];  // 设置了默认值，防止接口未返回steep参数造成的程序错误
            support.showIcon = SNString(supportInfoDict[@"showIcon"], @"");
            support.showText = SNString(supportInfoDict[@"showText"], @"");
            support.showStyle = SNString(supportInfoDict[@"showStyle"], @"");
            
            support.newsid = SNString(supportInfoDict[@"newsid"], @"");
            support.luckyUrl = SNString(supportInfoDict[@"luckyUrl"], @"");
            support.showStyleNight = SNString(supportInfoDict[@"showStyleNight"], @"");
            support.isLottery = SNString(supportInfoDict[@"isLottery"], @"");
        }
    }
    return support;
}

- (NSString *)convertDataToStr:(id)normalData defaultValue:(NSInteger)defaultValue{
    NSString *result;
    if (CHECK_VALID_NUMBER(normalData)){
        result = [NSString stringWithFormat:@"%@",SNNumber(normalData, [NSNumber numberWithInteger:defaultValue])];
    }else if (CHECK_VALID_STRING(normalData)){
        result = SNString(normalData, [NSString stringWithFormat:@"%d",defaultValue]);
    }else{
        result = @"0";
    }
    return result;
}

@end
