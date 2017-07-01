//
//  CheckTaskViewController.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckTaskViewController : UIViewController

@property (strong, nonatomic) NSDictionary *senderSDict;
@property (strong, nonatomic) NSArray *groupList;
@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSString *courseName;

@property (strong, nonatomic) NSString *currentTime;

@end
