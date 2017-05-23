//
//  XABSchoolMessage.h
//  XAnBao
//
//  Created by Minlay on 17/3/9.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XABSchoolMessageDelegate <NSObject>
- (void)messageDidFinish;
- (void)cancelMessage;
- (void)requestError;
@end
@interface XABSchoolMessage : UIView
+ (instancetype)schoolMessageWithSchollId:(NSString *)schollId;
@property(nonatomic, weak)id<XABSchoolMessageDelegate> delegate;
@end
