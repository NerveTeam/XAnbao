//
//  XABCurriculumView.h
//  XAnBao
//
//  Created by 韩森 on 2017/5/25.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XABCurriculumView : UIView

@property BOOL isSingleCUrriculum;
@property NSInteger sectionNumebr;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic,assign) CGFloat curriculumWidth;

@property (nonatomic,copy) NSString *fangXueStr;
- (void)drawWithPoisition:(CGPoint)point;


@end
