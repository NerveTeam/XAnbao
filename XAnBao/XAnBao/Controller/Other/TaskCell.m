//
//  TaskCell.m
//  DownloaderDemo
//
//  Created by 夏桂峰 on 15/9/22.
//  Copyright (c) 2015年 夏桂峰. All rights reserved.
//

#import "TaskCell.h"
#import "FGGDownloadManager.h"
#import "FrameAutoScaleLFL.h"
@implementation TaskCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        nameLabel
//        progressLabel
//        sizeLabel
//        speedLabel
        
        self.downloadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.downloadBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:270 Y:25 width:45 height:20];
        [self.downloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.downloadBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [self.downloadBtn setTitle:@"开始" forState:UIControlStateNormal];
        self.downloadBtn.backgroundColor=[UIColor redColor];
        
        [self.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.downloadBtn];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:50 Y:2 width:200 height:20]];
        self.nameLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.nameLabel];
        
        
        self.sizeLabel=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:240 Y:2 width:80 height:20]];
        self.sizeLabel.font=[UIFont systemFontOfSize:12];
        self.sizeLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.sizeLabel];

        self.headimgView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:5 Y:10 width:40 height:40]];
        self.headimgView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.headimgView];
       
    }
    return self;

}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)downloadAction:(UIButton *)sender {
    if(self.downloadBlock)
        self.downloadBlock(sender);
}
-(void)cellWithModel:(TaskModel *)model
{
    _nameLabel.text=model.name;
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    //检查之前是否已经下载，若已经下载，获取下载进度。
    BOOL exist=[[NSFileManager defaultManager] fileExistsAtPath:model.destinationPath];
    if(exist)
    {
        //获取原来的下载进度
        _progressView.progress=[[FGGDownloadManager shredManager] lastProgress:model.url];
        //获取原来的文件已下载部分大小及文件总大小
        _sizeLabel.text=[[FGGDownloadManager shredManager] filesSize:model.url];
        //原来的进度
        _progressLabel.text=[NSString stringWithFormat:@"%.2f%%",_progressView.progress*100];
    }
    if(_progressView.progress==1.0)
    {
        [_downloadBtn setTitle:@"查看" forState:UIControlStateNormal];
        //控制按钮是否可点击的
//        _downloadBtn.enabled=NO;
    }
    else if(_progressView.progress>0.0)
        [_downloadBtn setTitle:@"恢复" forState:UIControlStateNormal];
    else
        [_downloadBtn setTitle:@"开始" forState:UIControlStateNormal];
}
@end
