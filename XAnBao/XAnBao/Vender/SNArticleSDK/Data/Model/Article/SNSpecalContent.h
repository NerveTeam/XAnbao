//
//  SpecalContent.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SpecalContentTypeBackgroud = 0, //带背景
    SpecalContentTypeQuote = 1,     //带引号
    SpecalContentTypeSummary = 2,   //摘要
    SpecalContentTypeConclusion = 3 //结语
    
}SpecalContentType;

/**
 *  特殊内容
 */
@interface SNSpecalContent : NSObject <NSCoding>

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)SpecalContentType type;

@end