//
//  SPFollowSetingTeamViewCell.h
//  sinaSports
//
//  Created by 磊 on 15/12/23.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPFollowSetingTeamViewCell : UITableViewCell
+ (instancetype)followSetingTeamViewCellWithtTableView:(UITableView *)tableView;
- (void)setModel:(NSDictionary *)partition follow:(NSArray *)follow;
- (void)changeCellStyleSelect:(BOOL)isSelect isTop:(BOOL)isTop;
- (void)showOrigin:(BOOL)isShowOrigin;
@end
