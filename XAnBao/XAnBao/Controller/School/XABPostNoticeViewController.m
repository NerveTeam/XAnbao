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
#import "XABEnclosureView.h"

@interface XABPostNoticeViewController ()
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
@end

@implementation XABPostNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentScrollView setContentSize: CGSizeMake(self.view.width, CGRectGetMaxY(self.imageEnclosure.frame))];
}


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
        make.height.offset(150);
    }];
    [self.imageEnclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectObjectEnclosure.mas_bottom).offset(10);
        make.left.equalTo(self.titleEnclosure);
        make.right.equalTo(self.titleEnclosure);
        make.height.offset(150);
    }];
    
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(40);
    }];
    
}

- (void)postNotice {
    WeakSelf;
    
    if (self.noticeType == NoticeTypeSchool) {
        NSMutableDictionary *pargam = [NSMutableDictionary new];
        [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
        [pargam setSafeObject:UserInfo.id forKey:@"createId"];
        [pargam setSafeObject:self.titleInputView.text forKey:@"title"];
        [pargam setSafeObject:self.contentInputView.text forKey:@"content"];
        //    [pargam setSafeObject:UserInfo.id forKey:@"ids"];
        //    [pargam setSafeObject:UserInfo.id forKey:@"groups"];
        
        
        [SchoolPostIntranetNotice requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
            NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
            if (code == 200) {
                NSDictionary *data = [request.json objectForKeySafely:@"data"];
                NSArray *results = [data objectForKeySafely:@"results"];
                [self showMessage:@"发布成功"];
            }
        } failureBlock:^(BaseDataRequest *request) {
            [self showMessage:@"发布失败"];
        }];
    }else if (self.noticeType == NoticeTypeClass) {
    
    
    }
   
}

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
@end
