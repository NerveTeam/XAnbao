//
//  SNParser.h
//  SNArticleDemo
//
//  Created by Boris on 15/12/28.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNArticlePublicMethod.h"
#import "SNCommonGlobalUtil.h"

#define status_success 0

@interface SNParser : NSObject

@property (nonatomic, readwrite, assign) BOOL        hasError;
@property (nonatomic, assign) NSInteger   errorCode;
@property (nonatomic, copy)   NSString  *  errorMessage;
@property (nonatomic, strong) NSError   *  error;

- (NSDictionary *)parseBaseDataWithDict:(NSDictionary *)dict;

@end
