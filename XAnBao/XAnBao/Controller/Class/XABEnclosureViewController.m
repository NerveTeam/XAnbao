//
//  XABEnclosureViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABEnclosureViewController.h"
#import "UIButton+Extention.h"
#import "UIView+TopBar.h"
#import "XABRecordCell.h"
#import "XABUploadImageCell.h"
#import "XABEnclosureView.h"
#import "XABRecordCollectionView.h"
#import "XABImageCollectionView.h"
#import "XABEnclosure.h"

@interface XABEnclosureViewController ()<UICollectionViewDataSource,XABRecordCellDelegate,XABUploadImageCellDelegate>
@property(nonatomic, strong)UIView *topBar;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)XABEnclosureView *recordBgView;
@property(nonatomic, strong)XABEnclosureView *imgBgView;
@property(nonatomic, strong)XABRecordCollectionView *recordCollectionView;
@property(nonatomic, strong)XABImageCollectionView *imgCollectionView;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;
@property(nonatomic, copy)NSString *playingFileName;
@property(nonatomic, strong)NSMutableArray *recordFiles;
@property(nonatomic, strong)NSMutableArray *imageFiles;
@end

@implementation XABEnclosureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self setup];
    self.recordFiles = [NSMutableArray arrayWithObject:@"add"];
    self.imageFiles = [NSMutableArray arrayWithObject:@"add"];
    [self.recordCollectionView reloadData];
    [self.imgCollectionView reloadData];
}

- (void)setup {
    [self.view addSubview:self.topBar];
    [self.recordBgView addSubview:self.recordCollectionView];
    [self.imgBgView addSubview:self.imgCollectionView];
    
    [self.recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(160);
    }];
    [self.recordCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.recordBgView.mas_bottom).offset(-10);
        make.leading.equalTo(self.recordBgView);
        make.trailing.equalTo(self.recordBgView);
        make.height.offset(120);
    }];
    
    [self.imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordBgView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(160);
    }];

    [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgBgView.mas_bottom).offset(-10);
        make.leading.equalTo(self.imgBgView);
        make.trailing.equalTo(self.imgBgView);
        make.height.offset(120);
    }];
    
}





- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isKindOfClass:[XABRecordCollectionView class]]) {
         return self.recordFiles.count;
    }else if ([collectionView isKindOfClass:[XABImageCollectionView class]]) {
        return self.imageFiles.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isKindOfClass:[XABRecordCollectionView class]]) {
        XABRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.recordCollectionView.identifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:self.recordFiles[indexPath.item]];
        return cell;
    }else if ([collectionView isKindOfClass:[XABImageCollectionView class]]) {
        XABUploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.imgCollectionView.identifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:self.imageFiles[indexPath.item]];
        return cell;
    }
    
    return nil;
  
}

- (void)recordingDidFinish:(NSString *)filePath {
    if (filePath.length > 0) {
        [self.recordFiles insertObject:filePath atIndex:0];
        [self.recordCollectionView reloadData];
        [self.recordCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)uploadDidFinish:(NSData *)imageData {
    if (imageData) {
        XABEnclosure *enclosure = [XABEnclosure new];
        enclosure.imageData = imageData;
        enclosure.isLocal = YES;
        [self.imageFiles insertObject:enclosure atIndex:0];
        [self.imgCollectionView reloadData];
        [self.imgCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        
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
- (XABEnclosureView *)recordBgView {
    if (!_recordBgView) {
        _recordBgView = [XABEnclosureView enclosureWithTitle:@"上传语音"];
        _recordBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_recordBgView];
    }
    return _recordBgView;
}
- (XABEnclosureView *)imgBgView {
    if (!_imgBgView) {
        _imgBgView = [XABEnclosureView enclosureWithTitle:@"上传图片"];
        _imgBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_imgBgView];
    }
    return _imgBgView;
}
- (XABRecordCollectionView *)recordCollectionView {
    if (!_recordCollectionView) {
        _recordCollectionView = [[XABRecordCollectionView alloc]initWithItemSize:CGRectMake(0, 0, 100, 100) identifier:@"XABRecordCell" itemHorizontalSpacing:20 itemVerticalSpacing:20 scrollDirection:UICollectionViewScrollDirectionHorizontal];
        _recordCollectionView.dataSource = self;
    }
    return _recordCollectionView;
}

- (XABImageCollectionView *)imgCollectionView {
    if (!_imgCollectionView) {
        _imgCollectionView = [[XABImageCollectionView alloc]initWithItemSize:CGRectMake(0, 0, 100, 100) identifier:@"XABUploadImageCell" itemHorizontalSpacing:20 itemVerticalSpacing:0 scrollDirection:UICollectionViewScrollDirectionHorizontal];
        _imgCollectionView.dataSource = self;
    }
    return _imgCollectionView;
}
@end
