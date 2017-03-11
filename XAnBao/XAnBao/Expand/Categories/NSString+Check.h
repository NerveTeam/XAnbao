//
//  NSString+Check.h
//  SchoolHelper
//
//  Created by 陈林 on 16/9/27.
//  Copyright © 2016年 SEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

// 手机号码的有效性判断
//检测是否是手机号码
- (BOOL)isMobileNumber;

//验证身份证号码
- (BOOL) isValideIDCardNumber;

// 手机号位数判断(满足条件: 以数字1开头的11为全数字String)
- (BOOL)isMobileNumberTempCheck;

//判断字符串是否为数字
- (BOOL)isPureIntType;



@end
