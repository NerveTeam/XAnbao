//
//  MLMeunItem.m
//  MLSwipeMeun
//
//  Created by 吴明磊 on 16/11/3.
//  Copyright (c) 2016年 Minlay. All rights reserved.
//

#import "MLMeunItem.h"
#define NormalColor RGBACOLOR(164, 206, 179, 1)
#define SelectColor [UIColor whiteColor]
#define NormalFont [UIFont systemFontOfSize:16]
#define SelectFont [UIFont systemFontOfSize:16]

@interface MLMeunItem ()
{
    CGFloat rgba[4];
    CGFloat rgbaGAP[4];
}

@end

@implementation MLMeunItem
- (instancetype)init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:NormalColor forState:UIControlStateNormal];
        self.font = NormalFont;
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    selected = selected;
    if (selected) {
        [self setTitleColor:_selectlColor != nil ? _selectlColor : SelectColor forState:UIControlStateNormal];
        self.font = _selectlFont !=nil ? _selectlFont : SelectFont;
    }else {
        [self setTitleColor:_normalColor != nil ? _normalColor : NormalColor forState:UIControlStateNormal];
        self.font = _normalFont !=nil ? _normalFont : NormalFont;
    }
}
- (void)updateItemStyle:(CGFloat)percent {
    [self setRGB];
    CGFloat r = rgba[0] + rgbaGAP[0]*(1-percent);
    CGFloat g = rgba[1] + rgbaGAP[1]*(1-percent);
    CGFloat b = rgba[2] + rgbaGAP[2]*(1-percent);
    CGFloat a = rgba[3] + rgbaGAP[3]*(1-percent);
    [self setTitleColor:[UIColor colorWithRed:r green:g blue:b alpha:a] forState:UIControlStateNormal];
}

- (void)setRGB {
    
    UIColor *normalColor = _normalColor != nil ? _normalColor : NormalColor;
    UIColor *selectColor = _selectlColor != nil? _selectlColor : SelectColor;
    
    int numNormal = (int)CGColorGetNumberOfComponents(normalColor.CGColor);
    int numSelected = (int)CGColorGetNumberOfComponents(selectColor.CGColor);
    if (numNormal == 4 && numSelected == 4) {
        // UIDeviceRGBColorSpace
        const CGFloat *norComponents = CGColorGetComponents(normalColor.CGColor);
        const CGFloat *selComponents = CGColorGetComponents(selectColor.CGColor);
        rgba[0] = norComponents[0];
        rgbaGAP[0] = selComponents[0]-rgba[0];
        rgba[1] = norComponents[1];
        rgbaGAP[1] = selComponents[1]-rgba[1];
        rgba[2] = norComponents[2];
        rgbaGAP[2] = selComponents[2]-rgba[2];
        rgba[3] = norComponents[3];
        rgbaGAP[3] =  selComponents[3]-rgba[3];
    }else{
        if (numNormal == 2) {
            const CGFloat *norComponents = CGColorGetComponents(normalColor.CGColor);
            self.normalColor = [UIColor colorWithRed:norComponents[0] green:norComponents[0] blue:norComponents[0] alpha:norComponents[1]];
        }
        if (numSelected == 2) {
            const CGFloat *selComponents = CGColorGetComponents(selectColor.CGColor);
            self.selectlColor = [UIColor colorWithRed:selComponents[0] green:selComponents[0] blue:selComponents[0] alpha:selComponents[1]];
        }
    }
    
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self setTitleColor:_normalColor != nil ? _normalColor : NormalColor forState:UIControlStateNormal];
    self.font = _normalFont !=nil ? _normalFont : NormalFont;
}
@end
