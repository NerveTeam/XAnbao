//
//  XABPostNoticeViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABPostNoticeViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "XABSchoolRequest.h"
#import "UILabel+Extention.h"
#import "XABEnclosureView.h"
#import "XABSelectPeopleGroupViewController.h"
#import "XABClassRequest.h"
#import "HKNetEngine.h"
#import "ZXCameraManager.h"
#import "XABImageCollectionView.h"
#import "XABUploadImageCell.h"
#import "XABEnclosure.h"

@interface XABPostNoticeViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,XABUploadImageCellDelegate>
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *postBtn;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, strong)XABEnclosureView *titleEnclosure;
@property(nonatomic, strong)UITextView *titleInputView;
@property(nonatomic, strong)XABEnclosureView *contentEnclosure;
@property(nonatomic, strong)UITextView *contentInputView;
@property(nonatomic, strong)XABEnclosureView *imageEnclosure;
@property(nonatomic, strong)XABEnclosureView *statisEnclosure;
@property(nonatomic, strong)XABEnclosureView *selectObjectEnclosure;
@property(nonatomic, strong)UIButton *selectReceivePeople;
@property(nonatomic, strong)NSDictionary *selectGroupList;
@property(nonatomic, strong)UILabel *statisLabel;
@property(nonatomic, strong)UILabel *noStatisLabel;
@property(nonatomic, strong)UIButton *statisBtn;
@property(nonatomic, strong)UIButton *noStatisBtn;
@property(nonatomic, strong)UIButton *uploadImage;
@property(nonatomic, strong)NSMutableArray *uploadImageList;
@property(nonatomic, strong)XABImageCollectionView *imgCollectionView;
@end

@implementation XABPostNoticeViewController
{
    NSString *qn_token;
    NSString *qn_domain;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self getQNToken];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveSelectObject:) name:KSelectGroupListDidFinish object:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentScrollView setContentSize: CGSizeMake(self.view.width, CGRectGetMaxY(self.imageEnclosure.frame))];
}

- (void)getQNToken {
    [GetQiNiuTokenAndDomin requestDataWithParameters:nil headers:Token successBlock:^(BaseDataRequest *request) {
        qn_token = [[request.responseObject objectForKey:@"data"] objectForKey:@"token"];
        qn_domain = [[request.responseObject objectForKey:@"data"] objectForKey:@"domain"];
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)saveSelectObject:(NSNotification *)noti {
    self.selectGroupList =  noti.userInfo;
    [self.selectObjectEnclosure showTip:@"已选择"];
}


- (void)statisClick:(UIButton *)sender {
    if (self.statisBtn.isSelected && !self.noStatisBtn.isSelected) {
        [self.statisBtn setSelected:NO];
        [self.noStatisBtn setSelected:YES];
    }else if (!self.statisBtn.isSelected && self.noStatisBtn.isSelected) {
        [self.statisBtn setSelected:YES];
        [self.noStatisBtn setSelected:NO];
    }
}



- (void)selectReceiveGroup {
    XABSelectPeopleGroupViewController *select = [XABSelectPeopleGroupViewController new];
    select.isScholl = _noticeType == NoticeTypeSchool ? YES : NO;
    select.classId = _classId;
    select.schoolId = _schoolId;
    select.selectedInfo = self.selectGroupList;
    [self pushToController:select animated:YES];
}


- (void)postNotice {
    WeakSelf;
    
    if (self.noticeType == NoticeTypeSchool) {
        NSMutableDictionary *pargam = [NSMutableDictionary new];
        [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
        [pargam setSafeObject:UserInfo.id forKey:@"createId"];
        [pargam setSafeObject:[self.uploadImageList componentsJoinedByString:@","] forKey:@"images"];
        [pargam setSafeObject:@(self.statisBtn.isSelected) forKey:@"confirm"];
        [pargam setSafeObject:self.titleInputView.text forKey:@"title"];
        [pargam setSafeObject:self.contentInputView.text forKey:@"content"];
        [pargam setSafeObject:[[self.selectGroupList objectForKeySafely:@"groupList"] componentsJoinedByString:@","] forKey:@"groups"];
        [pargam setSafeObject:[[self.selectGroupList objectForKeySafely:@"teacherList"] componentsJoinedByString:@","]forKey:@"ids"];
        
        
        [SchoolPostIntranetNotice requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                [self showMessage:@"发布成功"];
            }
        } failureBlock:^(BaseDataRequest *request) {
            [self showMessage:@"发布失败"];
        }];
    }else if (self.noticeType == NoticeTypeClass) {
        NSMutableDictionary *pargam = [NSMutableDictionary new];
        [pargam setSafeObject:[self.uploadImageList componentsJoinedByString:@","]forKey:@"images"];
        [pargam setSafeObject:@(self.statisBtn.isSelected) forKey:@"reply"];
        [pargam setSafeObject:self.titleInputView.text forKey:@"title"];
        [pargam setSafeObject:self.contentInputView.text forKey:@"content"];
        [pargam setSafeObject:[[self.selectGroupList objectForKeySafely:@"groupList"] componentsJoinedByString:@","] forKey:@"groups"];
        [pargam setSafeObject:[[self.selectGroupList objectForKeySafely:@"teacherList"] componentsJoinedByString:@","]forKey:@"students"];
        
        
        [ClassPostNotice requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                [self showMessage:@"发布成功"];
            }
        } failureBlock:^(BaseDataRequest *request) {
            [self showMessage:@"发布失败"];
        }];
        
    }
    
}


-(void)openPhotoLibrary

{
    
    [[ZXCameraManager getInstance]
     
     pickAlbumPhotoFromCurrentController:self imageBlock:^(UIImage *image) {
         
         [self dismissViewControllerAnimated:YES completion:nil];
         [self upLoadImageFile:image];
         
     }];
    // 进入相册
    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//        
//    {
//        
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//        
//        imagePicker.allowsEditing = YES;
//        
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        imagePicker.delegate = self;
//        
//        [self.navigationController presentViewController:imagePicker animated:YES completion:^{
//            
//            NSLog(@"打开相册");
//            
//        }];
//        
//    }
//    
//    else
//        
//    {
//        
//        NSLog(@"不能打开相册");
//        
//    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)upLoadImageFile:(UIImage *)img {
    WeakSelf;
    NSData *data = UIImageJPEGRepresentation(img, 0.4f);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"xab_tp_wj%@.png", str];
    
    [[HKNetEngine shareInstance] uploadImageToQNFilePath:data name:fileName qnToken:qn_token Block:^(id dic, HKNetReachabilityType reachabilityType) {
        
        if (dic[@"hash"]) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@",qn_domain, dic[@"key"]];
            
            XABEnclosure *enclosure = [XABEnclosure new];
            enclosure.url = urlString;
            [self.uploadImageList insertObject:enclosure atIndex:0];
            [self.imgCollectionView reloadData];
            [self.imgCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//            [weakSelf.uploadImageList addObject:urlString];
            
        }
        
    }];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return self.uploadImageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        XABUploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.imgCollectionView.identifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:self.uploadImageList[indexPath.item]];
        return cell;
    
}

- (void)deleteImage:(XABUploadImageCell *)cell {
    NSIndexPath *path = [self.imgCollectionView indexPathForCell:cell];
    [self.uploadImageList removeObjectAtIndex:path.item];
    [self.imgCollectionView deleteItemsAtIndexPaths:@[path]];
}

#pragma mark - setup

- (void)setup {
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.postBtn];
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.titleEnclosure];
    [self.titleEnclosure addSubview:self.titleInputView];
    [self.contentScrollView addSubview:self.contentEnclosure];
    [self.contentEnclosure addSubview:self.contentInputView];
    [self.contentScrollView addSubview:self.statisEnclosure];
    [self.contentScrollView addSubview:self.selectObjectEnclosure];
    [self.contentScrollView addSubview:self.imageEnclosure];
    [self.selectObjectEnclosure addSubview:self.selectReceivePeople];
    [self.statisEnclosure addSubview:self.statisLabel];
    [self.statisEnclosure addSubview:self.noStatisLabel];
    [self.statisEnclosure addSubview:self.statisBtn];
    [self.statisEnclosure addSubview:self.noStatisBtn];
    [self.imageEnclosure addSubview:self.uploadImage];
    [self.imageEnclosure addSubview:self.imgCollectionView];
    
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.postBtn.mas_top);
    }];
    
    [self.titleEnclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.offset(120);
    }];
    [self.titleInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.titleEnclosure);
        make.top.equalTo(self.titleEnclosure).offset(40);
    }];
    [self.contentEnclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleEnclosure.mas_bottom).offset(10);
        make.left.equalTo(self.titleEnclosure);
        make.right.equalTo(self.titleEnclosure);
        make.height.offset(120);
    }];
    [self.contentInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentEnclosure);
        make.top.equalTo(self.contentEnclosure).offset(40);
    }];
    [self.statisEnclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentEnclosure.mas_bottom).offset(10);
        make.left.equalTo(self.titleEnclosure);
        make.right.equalTo(self.titleEnclosure);
        make.height.offset(120);
    }];
    [self.selectObjectEnclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statisEnclosure.mas_bottom).offset(10);
        make.left.equalTo(self.titleEnclosure);
        make.right.equalTo(self.titleEnclosure);
        make.height.offset(40);
    }];
    [self.selectReceivePeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectObjectEnclosure);
        make.right.equalTo(self.selectObjectEnclosure).offset(-10);
    }];
    [self.imageEnclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectObjectEnclosure.mas_bottom).offset(10);
        make.left.equalTo(self.titleEnclosure);
        make.right.equalTo(self.titleEnclosure);
        make.height.offset(160);
    }];
    
    [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageEnclosure.mas_bottom).offset(-10);
        make.leading.equalTo(self.imageEnclosure);
        make.trailing.equalTo(self.imageEnclosure);
        make.height.offset(120);
    }];
    
    [self.uploadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageEnclosure).offset(10);
        make.right.equalTo(self.imageEnclosure).offset(-10);
    }];
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
    
    [self.statisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statisEnclosure).offset(50);
        make.left.equalTo(self.statisEnclosure).offset(10);
    }];
    [self.statisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statisLabel);
        make.right.equalTo(self.statisEnclosure).offset(-10);
    }];
    [self.noStatisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statisLabel.mas_bottom).offset(10);
        make.left.equalTo(self.statisEnclosure).offset(10);
    }];
    [self.noStatisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.noStatisLabel);
        make.right.equalTo(self.statisEnclosure).offset(-10);
    }];
    
}

#pragma mark - lazy

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"发布内网公告" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithTitle:@"发布" fontSize:15 titleColor:[UIColor whiteColor]];
        _postBtn.backgroundColor = ThemeColor;
        _postBtn.layer.cornerRadius = 5;
        _postBtn.clipsToBounds = YES;
        [_postBtn addTarget:self action:@selector(postNotice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [UIScrollView new];
        _contentScrollView.backgroundColor = RGBCOLOR(242, 242, 242);
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}
- (XABEnclosureView *)titleEnclosure {
    if (!_titleEnclosure) {
        _titleEnclosure = [XABEnclosureView enclosureWithTitle:@"通告标题"];
    }
    return _titleEnclosure;
}
- (UITextView *)titleInputView {
    if (!_titleInputView) {
        _titleInputView = [UITextView new];
        _titleInputView.font = [UIFont systemFontOfSize:14];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        _titleInputView.text = [NSString stringWithFormat:@"%@%@发布的通知",strDate,UserInfo.name];
    }
    return _titleInputView;
}
- (XABEnclosureView *)contentEnclosure {
    if (!_contentEnclosure) {
        _contentEnclosure = [XABEnclosureView enclosureWithTitle:@"通告内容"];
    }
    return _contentEnclosure;
}
- (UITextView *)contentInputView {
    if (!_contentInputView) {
        _contentInputView = [UITextView new];
        _contentInputView.font = [UIFont systemFontOfSize:14];
    }
    return _contentInputView;
}
- (XABEnclosureView *)statisEnclosure {
    if (!_statisEnclosure) {
        _statisEnclosure = [XABEnclosureView enclosureWithTitle:@"是否统计"];
    }
    return _statisEnclosure;

}
- (XABEnclosureView *)selectObjectEnclosure {
    if (!_selectObjectEnclosure) {
        _selectObjectEnclosure = [XABEnclosureView enclosureWithTitle:@"选择收到的组"];
    }
    return _selectObjectEnclosure;

}
- (XABEnclosureView *)imageEnclosure {
    if (!_imageEnclosure) {
        _imageEnclosure = [XABEnclosureView enclosureWithTitle:@"上传附件"];
    }
    return _imageEnclosure;

}
- (UIButton *)selectReceivePeople {
    if (!_selectReceivePeople) {
        _selectReceivePeople = [UIButton buttonWithImageNormal:@"class_job_rightArrow" imageSelected:@"class_job_rightArrow"];
        [_selectReceivePeople sizeToFit];
        [_selectReceivePeople addTarget:self action:@selector(selectReceiveGroup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectReceivePeople;
}
- (UILabel *)statisLabel {
    if (!_statisLabel) {
        _statisLabel = [UILabel labelWithText:@"统计" fontSize:15 textColor:[UIColor blackColor]];
    }
    return _statisLabel;
}

- (UILabel *)noStatisLabel {
    if (!_noStatisLabel) {
        _noStatisLabel = [UILabel labelWithText:@"不统计" fontSize:15 textColor:[UIColor blackColor]];
    }
    return _noStatisLabel;
}
- (UIButton *)noStatisBtn {
    if (!_noStatisBtn) {
        _noStatisBtn = [UIButton new];
        [_noStatisBtn setBackgroundImage:[UIImage imageNamed:@"pub_class_inform_noselect"] forState:UIControlStateNormal];
    [_noStatisBtn setBackgroundImage:[UIImage imageNamed:@"pub_class_inform_selected"] forState:UIControlStateSelected];
        [_noStatisBtn addTarget:self action:@selector(statisClick:) forControlEvents:UIControlEventTouchUpInside];
        [_noStatisBtn setSelected:YES];
    }
    return _noStatisBtn;
}
- (UIButton *)statisBtn {
    if (!_statisBtn) {
        _statisBtn = [UIButton new];
        [_statisBtn setBackgroundImage:[UIImage imageNamed:@"pub_class_inform_noselect"] forState:UIControlStateNormal];
        [_statisBtn setBackgroundImage:[UIImage imageNamed:@"pub_class_inform_selected"] forState:UIControlStateSelected];
        [_statisBtn addTarget:self action:@selector(statisClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statisBtn;
}
- (UIButton *)uploadImage {
    if (!_uploadImage) {
        _uploadImage = [UIButton buttonWithImageNormal:@"class_job_rightArrow" imageSelected:@"class_job_rightArrow"];
        [_uploadImage sizeToFit];
        [_uploadImage addTarget:self action:@selector(openPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadImage;
}
- (NSMutableArray *)uploadImageList {
    if (!_uploadImageList) {
        _uploadImageList = [NSMutableArray array];
    }
    return _uploadImageList;
}

- (XABImageCollectionView *)imgCollectionView {
    if (!_imgCollectionView) {
        _imgCollectionView = [[XABImageCollectionView alloc]initWithItemSize:CGRectMake(0, 0, 100, 100) identifier:@"XABUploadImageCell" itemHorizontalSpacing:20 itemVerticalSpacing:0 scrollDirection:UICollectionViewScrollDirectionHorizontal];
        _imgCollectionView.dataSource = self;
    }
    return _imgCollectionView;
}
@end
