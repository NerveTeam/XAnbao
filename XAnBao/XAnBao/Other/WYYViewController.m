//
//  LZXCollectionViewCell.h
//  引导页
//
//  Created by wyy on 16/5/19.
//  Copyright © 2016年 王园园. All rights reserved.
//

#import "WYYViewController.h"
#import "WYYCollectionViewCell.h"
#import "YBTabBarController.h"
#import "XABUserLogin.h"
#import "UIImageView+WebCache.h"
@interface WYYViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation WYYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCollectionView];
    
    [[XABUserLogin getInstance] requestGetGuideImageResultBlock:^(NSString *image_url, NSError *error) {
        
        [self.dataArray addObject:image_url];
        [self.collectionView reloadData];
    }];
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置cell 大小
    layout.itemSize = self.view.bounds.size;
    
    // 设置滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置间距
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    // 隐藏滚动条
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页效果
    _collectionView.pagingEnabled = YES;
    
    // 设置弹簧效果
    _collectionView.bounces =  NO;
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[WYYCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//    cell.imageviewbg.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    [cell.imageviewbg sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@""]];//.image = self.dataArray[indexPath.row];

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count - 1) {
        [self presentViewController:self.controller animated:YES completion:nil];
    }
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
