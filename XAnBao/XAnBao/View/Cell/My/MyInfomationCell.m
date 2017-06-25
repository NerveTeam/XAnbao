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
        self.Settingtitlelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:70 Y:0 width:80 height:42]];
        if (!IS_IPHONE_5) {
            self.Settingtitlelbl.size=[FrameAutoScaleLFL CGSizeLFLMakeWidth:80 hight:35];
            
        }
        self.Settingtitlelbl.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.Settingtitlelbl];
        
        self.iconView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:5 width:25 height:25]];
        self.iconView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.iconView];
        
        
        self.ArrowiconView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:295 Y:14 width:10 height:12]];
        
        [self.contentView addSubview:self.ArrowiconView];
        
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
