//
//  XABClassGradeCurriculumsVC.m
//  XAnBao
//
//  Created by 韩森 on 2017/5/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

/*

   班级课程表
 
*/
#import "XABClassGradeCurriculumsVC.h"
#import "XABCurriculusCollectionViewCell.h"
#import "XABChatTool.h"
#import "MJExtension.h"
#import "NSArray+Safe.h"
#import "XABCurriculumView.h"
#import "UILabel+Extention.h"
#define kWidth 60//(SCREEN_WIDTH - 30)/5

#define kHeight 20+(kWidth)*9

@interface XABClassGradeCurriculumsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation XABClassGradeCurriculumsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView.image = [UIImage imageNamed:@"CurriculumScheduleMainBG"];

    [self configSource];
}

-(void)configSource{
    
    XABParamModel *param = [XABParamModel paramClassGradeCurriculumWithClassId:@"858726028099588096"];
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
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, kHeight+20+40);
    
    for (int i = 0; i<5; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+i*kWidth, 0, kWidth, 25)];
        label.text = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五"][i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:label];
    }
    
    for (int i = 0; i<8; i++) {
        
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
//        view.address = @"101";
        
       NSInteger week = model.dayOfTheWeek;
//        NSInteger week = 0;
//        if ([weekStr isEqualToString:@"Monday"]) {
//            
//            week = 1;
//        }else if ([weekStr isEqualToString:@"Tuesday"]) {
//            
//            week = 2;
//        }else if ([weekStr isEqualToString:@"Wednesday"]) {
//            
//            week = 3;
//        }else if ([weekStr isEqualToString:@"Thursday"]) {
//            
//            week = 4;
//        }else if ([weekStr isEqualToString:@"Friday"]) {
//            
//            week = 5;
//        }
//        
        

        NSInteger section = model.lessonNumber;
        view.curriculumWidth = kWidth;
        [view drawWithPoisition:CGPointMake(20 + kWidth*(week), 20 + kWidth*(section))];
        [self.contentView addSubview:view];
        [self.contentView bringSubviewToFront:view];
    }
    
}

-(UILabel *)contentLabel{
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kHeight+20, SCREEN_WIDTH - 40, 40)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:13];
    }
    return _contentLabel;
}
-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(self.contentView.frame.origin.x, 0, self.contentView.frame.size.width,kHeight)];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
-(UIView *)contentView{
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth*5+20,kHeight)];
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
#pragma mark <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString * identity = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        aFlowLayout.itemSize = CGSizeMake(70, 100);
        aFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        aFlowLayout.minimumLineSpacing = 0.1f;
        aFlowLayout.minimumInteritemSpacing = (SCREEN_WIDTH-70*4)/4;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:aFlowLayout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
        
//        _collectionView.contentInset = UIEdgeInsetsMake(BANNER_HIGHT, 0, 0, 0);
        
//        [_collectionView addSubview:self.cycleView];
        _collectionView.frame = CGRectMake(0,StatusBarHeight + TopBarHeight + 5, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 5 - 49);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
//        [_collectionView registerNib:[UINib nibWithNibName:@"ZXMainVCCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"applicationCell"];
//        
//        
//        [_collectionView registerNib:[UINib nibWithNibName:@"ZXMainHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXMainHeader"];
        
    }
    
    return _collectionView;
}
-(NSMutableArray *)sourceArray{
    
    if (_sourceArray) {
        
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
