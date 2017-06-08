//
//  MyInfomationCell.m
//  XAnBao
//
//  Created by wyy on 17/3/17.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "MyInfomationCell.h"
#import "FrameAutoScaleLFL.h"
@implementation MyInfomationCell

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
        self.Settingtitlelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:70 Y:0 width:80 height:45]];
        self.Settingtitlelbl.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.Settingtitlelbl];
        
        self.iconView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:10 width:25 height:25]];
              [self.contentView addSubview:self.iconView];
        
        
        self.ArrowiconView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:280 Y:15 width:15 height:20]];
        
        [self.contentView addSubview:self.ArrowiconView];
        
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
