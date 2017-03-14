//
//  XABClassFileViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassFileViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "SDCycleScrollView.h"
#import "UIButton+Extention.h"
#import "UIButton+ImageTitleSpacing.h"
#import "XABPictureViewController.h"
#import "XABVideoViewController.h"
#import "XABFileViewController.h"
#import "XABOtherViewController.h"

@interface XABClassFileViewController ()
@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic, strong)UIButton *imageBtn;
@property(nonatomic, strong)UIButton *videoBtn;
@property(nonatomic, strong)UIButton *filerBtn;
@property(nonatomic, strong)UIButton *otherBtn;
@end

@implementation XABClassFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self layoutView];
    [self loadData];
}

- (void)setup {
    [self.view addSubview:self.topBarView];
}

- (void)loadData{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.cycleView.imageURLStringsGroup = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3510003795,2153467965&fm=23&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1017904219,2460650030&fm=23&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=938946740,2496936570&fm=23&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3448641352,2315059109&fm=23&gp=0.jpg"];
    });
}

- (void)jumpPicture {
    XABPictureViewController *picture = [XABPictureViewController new];
    picture.filerType = FilerTypeClass;
    [self.navigationController pushViewController:picture animated:YES];
}
- (void)jumpVideo {
    XABVideoViewController *video = [XABVideoViewController new];
    video.filerType = FilerTypeClass;
    [self.navigationController pushViewController:video animated:YES];
}
- (void)jumpFile {
    XABFileViewController *file = [XABFileViewController new];
    file.filerType = FilerTypeClass;
    [self.navigationController pushViewController:file animated:YES];
}
- (void)jumpOther {
    XABOtherViewController *other = [XABOtherViewController new];
    other.filerType = FilerTypeClass;
    [self.navigationController pushViewController:other animated:YES];
}


- (void)layoutView {
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom);
        make.trailing.leading.equalTo(self.view);
        make.height.offset(imgScale(self.view.width));
    }];
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(25);
        make.height.offset(_imageBtn.height + 20);
    }];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageBtn);
        make.right.equalTo(self.view).offset(-25);
        make.height.offset(_videoBtn.height + 20);
    }];
    
    [self.filerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageBtn.mas_bottom).offset(15);
        make.left.equalTo(self.imageBtn);
        make.height.offset(_filerBtn.height + 20);
    }];
    
    [self.otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filerBtn);
        make.right.equalTo(self.videoBtn);
        make.height.offset(_otherBtn.height + 20);
    }];
}
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
        [self.view addSubview: _cycleView];
    }
    return _cycleView;
}
- (UIButton *)imageBtn {
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithTitle:@"图片" fontSize:16 titleColor:[UIColor blackColor] imageNormal:@"img_box" imageSelected:@"img_box"];
        [_imageBtn sizeToFit];
        [_imageBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        [_imageBtn addTarget:self action:@selector(jumpPicture) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_imageBtn];
    }
    return _imageBtn;
}
- (UIButton *)videoBtn {
    if (!_videoBtn) {
        _videoBtn = [UIButton buttonWithTitle:@"视频" fontSize:16 titleColor:[UIColor blackColor] imageNormal:@"audio_box" imageSelected:@"audio_box"];
        [_videoBtn sizeToFit];
        [_videoBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        [_videoBtn addTarget:self action:@selector(jumpVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_videoBtn];
    }
    return _videoBtn;
}
- (UIButton *)filerBtn {
    if (!_filerBtn) {
        _filerBtn = [UIButton buttonWithTitle:@"文件" fontSize:16 titleColor:[UIColor blackColor] imageNormal:@"file_box" imageSelected:@"file_box"];
        [_filerBtn sizeToFit];
        [_filerBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        [_filerBtn addTarget:self action:@selector(jumpFile) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_filerBtn];
    }
    return _filerBtn;
}
- (UIButton *)otherBtn {
    if (!_otherBtn) {
        _otherBtn = [UIButton buttonWithTitle:@"其他" fontSize:16 titleColor:[UIColor blackColor] imageNormal:@"other_box" imageSelected:@"other_box"];
        [_otherBtn sizeToFit];
        [_otherBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        [_otherBtn addTarget:self action:@selector(jumpOther) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_otherBtn];
    }
    return _otherBtn;
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"班级文件" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
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
