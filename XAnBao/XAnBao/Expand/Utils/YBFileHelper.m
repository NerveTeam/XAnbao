//
//  YBFileHelper.m
//  YueBallSport
//
//  Created by Minlay on 16/11/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBFileHelper.h"
#import "JSONKit.h"

@implementation YBFileHelper
+ (NSDictionary *)getChannelConfig {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"channelConfig"ofType:@"json"];
    NSString *contentString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *dataDict = [contentString objectFromJSONString];
    
    return [dataDict objectForKey:@"channel"];
}
@end
