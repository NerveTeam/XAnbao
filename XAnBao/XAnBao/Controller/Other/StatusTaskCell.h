//
//  StatusTaskCell.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StatusCell_SwitchButton,
    StatusCell_RespondButton,
    StatusCell_LinkButton,
} StatusCellButtonType;

@protocol StatusTaskCellDelegate <NSObject>

- (void)statusTaskCellClickButtonAtIndexPath:(NSIndexPath *)indexPath Type:(StatusCellButtonType)StatusCellButtonType with:(id)sender;

@end

@interface StatusTaskCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) UISwitch *statusTaskSwitch;

@property (strong, nonatomic) UIButton  *respondButton;

@property (strong, nonatomic) UIButton  *buttonLink;

@property (weak, nonatomic) id <StatusTaskCellDelegate>delegate;


@end
