//
//  SPBaseCollectionView.m
//  sinaSports
//
//  Created by 磊 on 15/12/29.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import "YBBaseCollectionView.h"
#import "YBCollectionViewBaseCell.h"

@interface FlowLayout : UICollectionViewFlowLayout
@property(nonatomic, assign)NSInteger horizontalSpacing;
@property(nonatomic, assign)NSInteger verticalSpacing;
@property(nonatomic, assign)UICollectionViewScrollDirection direction;
@end
@implementation FlowLayout
- (instancetype)initWithItemSize:(CGSize)itemSize itemHorizontalSpacing:(CGFloat)horizontalSpacing itemVerticalSpacing:(CGFloat)verticalSpacing ScrollDirection:(UICollectionViewScrollDirection)direction{
    
    self = [super init];
    if (self) {
        _horizontalSpacing = horizontalSpacing;
        _verticalSpacing = verticalSpacing;
        _direction = direction;
        [self initFlowLayoutStyleWithItemSize:itemSize];
    }
    return self;
}

- (void)initFlowLayoutStyleWithItemSize:(CGSize)itemSize {
    self.itemSize = itemSize;
    self.minimumInteritemSpacing = _horizontalSpacing;
    
    self.minimumLineSpacing = _direction ? _horizontalSpacing : _verticalSpacing;
    self.scrollDirection = _direction;
}

@end

@interface YBBaseCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, strong)NSArray *dataList;

@end
@implementation YBBaseCollectionView

- (instancetype)initWithItemSize:(CGRect)frame identifier:(NSString *)identifier itemHorizontalSpacing:(CGFloat)horizontalSpacing itemVerticalSpacing:(CGFloat)verticalSpacing scrollDirection:(UICollectionViewScrollDirection)direction{
    
    self = [super initWithFrame:frame collectionViewLayout:[[FlowLayout alloc]initWithItemSize:frame.size itemHorizontalSpacing:horizontalSpacing itemVerticalSpacing:verticalSpacing ScrollDirection:direction]];
    if (self) {
        self.identifier = identifier;
        [self setUp];
    }
    return self;
}

- (void)requestFinishData:(NSArray *)dataList {
    self.dataList = dataList;
    [self reloadData];
}



#pragma mark - privateMethod

- (void)setUp {
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self registerCell];
}

- (void)registerCell {
    [self registerClass:NSClassFromString(_identifier) forCellWithReuseIdentifier:_identifier];
}

#pragma mark <UICollectionViewDelegate>


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBCollectionViewBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
    [cell setModel:self.dataList[indexPath.item]];
    return cell;
}

@end
