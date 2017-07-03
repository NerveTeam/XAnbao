//
//  TaskContentView.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/8/23.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskContentView : UIView

+(TaskContentView *)shareInstance;
-(void)showWithString:(NSString *)string;

@end
