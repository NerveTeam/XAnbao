//
//  SPFollowSetingTeamView.h
//  sinaSports
//
//  Created by 磊 on 15/12/23.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPFollowSetingTeamView;
@protocol SPFollowSetingTeamViewDelegate <NSObject>

@optional
- (void)followSetingTeamViewDidSelect:(SPFollowSetingTeamView *)setingTeamView index:(NSIndexPath *)indexPath;
@end
typedef void(^callBackBlock)(NSIndexPath *indexPath);

@interface SPFollowSetingTeamView : UITableView
- (instancetype)initWithDidSelectCallBack:(callBackBlock)callBack;

- (void)setModel:(NSArray *)list follow:(NSArray *)follow;

- (CGFloat)cellHeight;

- (void)showOrigin:(BOOL)isShowOrigin;
@end
