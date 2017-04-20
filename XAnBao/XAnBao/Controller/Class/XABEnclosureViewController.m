//
//  XABEnclosureViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABEnclosureViewController.h"
#import "UIButton+Extention.h"
#import "YBBaseCollectionView.h"
#import "UIView+TopBar.h"
#import "XABRecordCell.h"

@interface XABEnclosureViewController ()<UICollectionViewDataSource,XABRecordCellDelegate>
@property(nonatomic, strong)UIView *topBar;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)YBBaseCollectionView *recordCollectionView;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;
@property(nonatomic, copy)NSString *playingFileName;
@property(nonatomic, strong)NSMutableArray *recordFiles;
@end

@implementation XABEnclosureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.recordFiles = [NSMutableArray arrayWithObject:@"add"];
    [self.recordCollectionView reloadData];
}

- (void)setup {
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.recordCollectionView];
    
    [self.recordCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.offset(200);
    }];

}





- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.recordFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XABRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.recordCollectionView.identifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setModel:self.recordFiles[indexPath.item]];
    return cell;
}

- (void)recordingDidFinish:(NSString *)filePath {
    if (filePath.length > 0) {
        [self.recordFiles insertObject:filePath atIndex:0];
        [self.recordCollectionView reloadData];
    }
}


- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBar = [_topBar topBarWithTintColor:ThemeColor title:@"附件" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
    }
    return _topBar;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
}
- (YBBaseCollectionView *)recordCollectionView {
    if (!_recordCollectionView) {
        _recordCollectionView = [[YBBaseCollectionView alloc]initWithItemSize:CGRectMake(0, 0, 100, 100) identifier:@"XABRecordCell" itemHorizontalSpacing:20 itemVerticalSpacing:0 scrollDirection:UICollectionViewScrollDirectionHorizontal];
        _recordCollectionView.dataSource = self;
    }
    return _recordCollectionView;
}

@end
