//
//  XABSchoolPictureViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolPictureViewController.h"
#import "SDCycleScrollView.h"

@interface XABSchoolPictureViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@end

@implementation XABSchoolPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self.view);
        make.height.offset(imgScale(self.view.width) + 50);
        make.centerY.equalTo(self.view);
    }];
    [self loadData];
}

- (void)loadData{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.cycleView.imageURLStringsGroup = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3510003795,2153467965&fm=23&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1017904219,2460650030&fm=23&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=938946740,2496936570&fm=23&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3448641352,2315059109&fm=23&gp=0.jpg"];
    });
}

- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
        _cycleView.infiniteLoop = NO;
        [self.view addSubview: _cycleView];
    }
    return _cycleView;
}
@end
