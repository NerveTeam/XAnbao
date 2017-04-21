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
        self.namelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:80 height:45]];
    
        self.namelbl.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.namelbl];
        
        self.titlelabel=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:75 Y:0 width:120 height:45]];
        self.titlelabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titlelabel];
        
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
