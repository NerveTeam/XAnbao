//
//  ClasstableViewCell.m
//  XAB
//
//  Created by wyy on 17/3/7.
//  Copyright © 2017年 王园园. All rights reserved.
//

#import "ClasstableViewCell.h"
#import "FrameAutoScaleLFL.h"
@implementation ClasstableViewCell

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
        
        self.titleimageView=[[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:15 width:90 height:50]];
        self.titleimageView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.titleimageView];
        
        self.titlenNamelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:120 Y:10 width:190 height:40]];
        self.titlenNamelbl.numberOfLines=0;
        self.titlenNamelbl.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.titlenNamelbl];
        self.datelbl=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:120 Y:35 width:120 height:50]];
        self.datelbl.font=[UIFont systemFontOfSize:11];
        
        [self.contentView addSubview:self.datelbl];
        
        
        self.titlelbl=[[UILabel alloc]init];
        self.titlelbl.font=[UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.titlelbl];
        
        
    }
    return  self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
