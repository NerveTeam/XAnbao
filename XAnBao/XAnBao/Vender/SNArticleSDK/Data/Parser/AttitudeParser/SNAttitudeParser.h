//
//  SNAttitudeParser.h
//  SinaNews
//
//  Created by Boris on 15-6-3.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSupportInfo.h"
#import "SNParser.h"

@interface SNAttitudeParser : SNParser

- (SNSupportInfo *)parseAttitudeInfoWithDictionary:(NSDictionary *)dict abstractId:(NSString *)abstractId;

@end
