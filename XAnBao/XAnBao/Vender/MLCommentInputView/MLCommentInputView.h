//
//  MLCommentInputView.h
//  MLCommentInputView
//
//  Created by Minlay on 16/11/20.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLCommentInputViewDelegate <NSObject>
@optional
- (void)commentItemClick;
- (void)sendComment:(NSString *)inputText;
@end
@interface MLCommentInputView : UIView
@property(nonatomic, weak)id<MLCommentInputViewDelegate> delegate;
- (void)updateCommentCount:(NSInteger)count;
@end
