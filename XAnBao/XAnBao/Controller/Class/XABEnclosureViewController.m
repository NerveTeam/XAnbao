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
#import "HKNetEngine.h"
#import "XABClassRequest.h"
#import "FSResource.h"

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
@property(nonatomic, strong)NSMutableArray *recordFileName;
@property(nonatomic, strong)NSMutableArray *imageFileName;
@property(nonatomic, strong)UIButton *postBtn;
@end

@implementation XABEnclosureViewController
{
    NSString *qn_token;
    NSString *qn_domain;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self setup];
    [self getQNToken];
    if (self.attachments) {
        [self initFilesData];
        self.postBtn.hidden = YES;
    }else {
        [self.recordFiles addObject:@"add"];
        [self.imageFiles addObject:@"add"];
    [self.recordCollectionView reloadData];
    [self.imgCollectionView reloadData];
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)initFilesData {
    for (NSDictionary *item in self.attachments) {
        NSString *type = [item objectForKeySafely:@"type"];
        NSString *url = [item objectForKeySafely:@"url"];
        if ([type isEqualToString:@"2"]) {
            XABEnclosure *en = [XABEnclosure new];
            en.isLocal = NO;
            en.url = url;
            [self.imageFiles addObject:en];
        }else if ([type isEqualToString:@"4"]) {
            NSString *pathName = [FSResource getFilePathName:url];
            [self.recordFiles addObject:pathName];
//            [self.mArrSpxUrl addObject:urlStr];
            if (![[NSFileManager defaultManager] fileExistsAtPath:pathName]) {
                [self downSPXFilesPath:pathName url:url];
            }
        }
    }
    [self.recordCollectionView reloadData];
    [self.imgCollectionView reloadData];
    
}


- (void)setup {
    [self.view addSubview:self.topBar];
    [self.recordBgView addSubview:self.recordCollectionView];
    [self.imgBgView addSubview:self.imgCollectionView];
    [self.view addSubview:self.postBtn];
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
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
    
}
- (void)postEnclosure {
    if (self.recordFileName.count == 0 && self.imageFileName.count == 0) {
        [self showMessage:@"请至少添加一个附件"];
        return;
    }
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    [parma setSafeObject:self.recordFileName forKey:@"recordUrl"];
    [parma setSafeObject:self.imageFileName forKey:@"imageUrl"];
    [[NSNotificationCenter defaultCenter]postNotificationName:AddEnclosureDidFinish object:nil userInfo:parma.copy];
    [self popViewControllerAnimated:YES];
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
        [self uploadVioceWithFilePath:filePath];
        [self.recordFiles insertObject:filePath atIndex:0];
        [self.recordCollectionView reloadData];
        [self.recordCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)uploadDidFinish:(NSData *)imageData {
    if (imageData) {
        [self upLoadImageFile:imageData];
        XABEnclosure *enclosure = [XABEnclosure new];
        enclosure.imageData = imageData;
        enclosure.isLocal = YES;
        [self.imageFiles insertObject:enclosure atIndex:0];
        [self.imgCollectionView reloadData];
        [self.imgCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
}
- (void)deleteImage:(XABUploadImageCell *)cell {
    NSIndexPath *path = [self.imgCollectionView indexPathForCell:cell];
    [self.imageFiles removeObjectAtIndex:path.item];
    [self.imageFileName removeObjectAtIndex:path.item];
    [self.imgCollectionView deleteItemsAtIndexPaths:@[path]];
}
- (void)deleteRecord:(XABRecordCell *)cell {
    NSIndexPath *path = [self.recordCollectionView indexPathForCell:cell];
    [self.recordFiles removeObjectAtIndex:path.item];
    [self.recordFileName removeObjectAtIndex:path.item];
    [self.recordCollectionView deleteItemsAtIndexPaths:@[path]];
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

- (NSMutableArray *)recordFileName {
    if (!_recordFileName) {
        _recordFileName = [NSMutableArray array];
    }
    return _recordFileName;
}

- (NSMutableArray *)imageFileName {
    if (!_imageFileName) {
        _imageFileName = [NSMutableArray array];
    }
    return _imageFileName;
}

- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"提交" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(postEnclosure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
#pragma mark - 上传工作

- (void)getQNToken {
    [GetQiNiuTokenAndDomin requestDataWithParameters:nil headers:Token successBlock:^(BaseDataRequest *request) {
        qn_token = [[request.responseObject objectForKey:@"data"] objectForKey:@"token"];
        qn_domain = [[request.responseObject objectForKey:@"data"] objectForKey:@"domain"];
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}
- (void)uploadVioceWithFilePath:(NSString *)filePath {
    [self showMessage:@"正在上传"];
    WeakSelf;
    NSError *errer;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&errer];
    if (errer) {
        return;
    }
    // 录音后缀字符串
    NSString *strSpxName = [[filePath componentsSeparatedByString:@"/"] lastObject];
    
    [[HKNetEngine shareInstance] uploadImageToQNFilePath:data name:strSpxName qnToken:qn_token Block:^(id dic, HKNetReachabilityType reachabilityType) {
        if (dic[@"hash"]) {
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",KQNHttp, dic[@"key"]];
            [weakSelf.recordFileName addObject:urlString];
            [self showMessage:@"上传成功"];
        }
    }];
}


- (void)upLoadImageFile:(NSData *)img {
    [self showMessage:@"正在上传"];
    WeakSelf;
    NSData *data = img;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"xab_tp_wj%@.png", str];
    
    [[HKNetEngine shareInstance] uploadImageToQNFilePath:data name:fileName qnToken:qn_token Block:^(id dic, HKNetReachabilityType reachabilityType) {
        
        if (dic[@"hash"]) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@",qn_domain, dic[@"key"]];
            [weakSelf.imageFileName addObject:urlString];
            [self showMessage:@"上传成功"];
        }
        
    }];
    
}

- (void)downSPXFilesPath:(NSString *)pathName url:(NSString *)urlStr {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        [data writeToFile:pathName atomically:YES];
        
    });
}
- (NSMutableArray *)recordFiles {
    if (!_recordFiles) {
        _recordFiles = [NSMutableArray array];
    }
    return _recordFiles;
}
- (NSMutableArray *)imageFiles {
    if (!_imageFiles) {
        _imageFiles = [NSMutableArray array];
    }
    return _imageFiles;
}
@end
