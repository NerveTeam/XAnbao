//
//  SettingtavleViewCell.m
//  XAnBao
//
//  Created by wyy on 17/3/16.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "SettingtavleViewCell.h"
#import "FrameAutoScaleLFL.h"
@implementation SettingtavleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    if (self) {
        self.Settingtitlelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:80 height:45]];
        self.Settingtitlelbl.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.Settingtitlelbl];
        
        self.CleanLabel=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:200 Y:0 width:120 height:45]];
        self.CleanLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.CleanLabel];
        
    }
    return self;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
