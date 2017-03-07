//
//  XABResourceListCell.h
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XABResource.h"
@interface XABResourceListCell : UITableViewCell

@property(nonatomic, strong)XABResource *sportList;

+ (instancetype)newsSportListCellWithTableView:(UITableView *)tableView;
@end
