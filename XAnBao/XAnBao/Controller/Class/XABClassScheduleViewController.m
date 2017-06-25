//
//  XABClassScheduleViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassScheduleViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"

#import "XABChatTool.h"
#import "MJExtension.h"
#import "NSArray+Safe.h"
#import "XABCurriculumView.h"
#import "UILabel+Extention.h"
#define kWidth 60//(SCREEN_WIDTH - 30)/5

#define kHeight 20+(kWidth)*9

@interface XABClassScheduleViewController ()
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;

@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation XABClassScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)setup {
    [self.view addSubview:self.topBarView];
    self.imageView.image = [UIImage imageNamed:@"CurriculumScheduleMainBG"];
    
    [self configSource];
}
-(void)configSource{
    
    XABParamModel *param = [XABParamModel paramClassGradeCurriculumWithClassId:self.classId];//@"858726028099588096"
    [[XABChatTool getInstance] getClassCurriculumsWithRequestModel:param esultBlock:^(XABClassGradeCurriculumModel*model, NSError *error) {
        
        if (error == nil) {
            
            if (model.curriculums.count>0) {
                [self addCurriculumViews:model.curriculums];
                
            }
        }
    }];
    
    //    NSString *coursePath = [[NSBundle mainBundle] pathForResource:@"courses-1" ofType:@"json"];
    //
    //    NSData *data = [NSData dataWithContentsOfFile:coursePath];
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //
    //    XABResponseModel *response = [XABResponseModel responseFromKeyValues:dict];
    //    XABClassGradeCurriculumModel *model = [XABClassGradeCurriculumModel mj_objectWithKeyValues:[response.data safeObjectAtIndex:0]];
    //
    //    NSArray *arr = [XABCurriculumsModel mj_objectArrayWithKeyValuesArray:model.curriculums];
    //    NSLog(@"arr == %@,  \n  model == %ld",arr,arr.count);
    
    //    [self addCurriculumViews:arr];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, kHeight);
    
    for (int i = 0; i<5; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+i*kWidth, 0, kWidth, 25)];
        label.text = @[@"周一",@"周二",@"周三",@"周四",@"周五"][i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:label];
    }
    
    for (int i = 0; i<9; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,20+ i*kWidth, 20, kWidth)];
        label.text = @[@"第1节",@"第2节",@"第3节",@"第4节",@"第5节",@"第6节",@"第7节",@"第8节",@"第9节"][i];
        label.verticalText = label.text;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:label];
    }
}

- (void)addCurriculumViews:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
        
        XABCurriculumsModel *model = arr[i];
        XABCurriculumView *view = [[XABCurriculumView alloc] init];
        view.isSingleCUrriculum = YES;
        view.sectionNumebr = 1;
        view.title = model.name;
        view.fangXueStr = @"放学";
        
        NSInteger week = model.dayOfTheWeek;
        
        NSInteger section = model.lessonNumber;
        view.curriculumWidth = kWidth;
        [view drawWithPoisition:CGPointMake(20 + kWidth*(week), 20 + kWidth*(section-1))];
        [self.contentView addSubview:view];
        [self.contentView bringSubviewToFront:view];
    }
    
}
-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,kHeight)];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
-(UIView *)contentView{
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (kWidth*5+20))/2,0, kWidth*5+20,kHeight)];
        [self.scrollView addSubview:_contentView];
        
    }
    return _contentView;
}
-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        [self.view addSubview:_scrollView];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"课程表" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
        _topBarView.backgroundColor = ThemeColor;
    }
    return _topBarView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
}

@end
