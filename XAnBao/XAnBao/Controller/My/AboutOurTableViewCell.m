//
//  AboutOOurTableViewCell.m
//  XAnBao
//
//  Created by wyy on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "AboutOurTableViewCell.h"
#import "FrameAutoScaleLFL.h"
@implementation AboutOurTableViewCell

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
        self.titlelab=[[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:10 Y:0 width:80 height:42]];
        
        if (!IS_IPHONE_5) {
            self.titlelab.size=[FrameAutoScaleLFL CGSizeLFLMakeWidth:80 hight:35];
            
        }
        
        
//        self.titlelab.backgroundColor=[UIColor redColor];
        self.titlelab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titlelab];
        
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
