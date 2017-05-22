//
//  TaskCell.h
//  DownloaderDemo
//
//  Created by 夏桂峰 on 15/9/22.
//  Copyright (c) 2015年 夏桂峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskModel.h"
#import "WYCircleView.h"
@interface TaskCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property(nonatomic,retain)UIButton *downloadBtn;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *progressLabel;
@property(nonatomic,retain)UILabel *sizeLabel;
@property(nonatomic,retain)UILabel *speedLabel;
@property (retain, nonatomic) UIProgressView *progressView;
@property(nonatomic,retain)WYCircleView *circleView;

@property(nonatomic,retain)UIImageView *headimgView;


@property(nonatomic,copy)void (^downloadBlock)(UIButton *sender);


-(void)cellWithModel:(TaskModel *)model;

@end
