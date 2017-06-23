//
//  MySelfTableCell.m
//  XAnBao
//
//  Created by wyy on 17/3/17.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "MySelfTableCell.h"
#import "FrameAutoScaleLFL.h"
@implementation MySelfTableCell

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
        self.namelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:80 height:self.height]];
    
        self.namelbl.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.namelbl];
        
        self.titlelabel=[[UITextField alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:75 Y:0 width:120 height:33]];
        if (!IS_IPHONE_5) {
            self.titlelabel.size=[FrameAutoScaleLFL CGSizeLFLMakeWidth:80 hight:35];
            
        }
        self.titlelabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titlelabel];
        
        
        self.ArrowiconView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:295 Y:14 width:10 height:12]];
        
        [self.contentView addSubview:self.ArrowiconView];
        
        
        self.headerView=[[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:10 width:30 height:30]];
      
        self.headerView.layer.cornerRadius=self.headerView.frame.size.width/2;
        self.headerView.clipsToBounds=YES;
        [self.contentView addSubview:self.headerView];

        
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
