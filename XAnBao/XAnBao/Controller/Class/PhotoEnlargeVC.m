//
//  PhotoEnlargeVC.m
//  IndustrialCommercialSP
//
//  Created by luqiang on 16/10/13.
//  Copyright © 2016年 team. All rights reserved.
//

#import "PhotoEnlargeVC.h"

@interface PhotoEnlargeVC () <UIScrollViewDelegate>
{
    UIView *_translucentView;
    UIScrollView *_scrollview;
    UIImageView *_imageview;
    
    UIImage *_image;
}
@end

@implementation PhotoEnlargeVC

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self singleTap];
}
#pragma mark - 监听事件
- (void)singleTap
{
    [UIView animateWithDuration:.28 animations:^{
        
        _scrollview.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        _translucentView.backgroundColor = [UIColor clearColor];
        
        // 1) 清除根视图
        [self.view removeFromSuperview];
        // 2) 清除子视图控制器
        [self removeFromParentViewController];
    }];
}

#pragma mark - 成员方法
- (void)show:(NSArray *)imageArr
{
    _image = imageArr[0];
    
    // 借助UIApplication中的window
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    // 将根视图添加到window中
    [window addSubview:self.view];
    // 记录住视图控制器
    [window.rootViewController addChildViewController:self];
    
    // 显示照片列表
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBasicUI];
    
    [self initUpUI];
}

- (void)initBasicUI {
    
    // 最底层的View 没有背景颜色
    UIView *bottomView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 透明层的View 黑色半透明
    _translucentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _translucentView.backgroundColor = [UIColor blackColor];
    [_translucentView setAlpha:0.9];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTap setNumberOfTapsRequired:1];
    [_translucentView addGestureRecognizer:singleTap];
    [bottomView addSubview:_translucentView];
    self.view = bottomView;
}

- (void)initUpUI {
    
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height/4;
    frame.size.height = frame.size.height/2;
    
    _scrollview=[[UIScrollView alloc]initWithFrame:frame];
    [self.view addSubview:_scrollview];

    _imageview=[[UIImageView alloc]initWithImage:_image];
    [_scrollview addSubview:_imageview];
    _scrollview.contentSize=_image.size;
    
    _scrollview.delegate=self;
    _scrollview.maximumZoomScale=3.0;
    _scrollview.minimumZoomScale=1.0;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTap setNumberOfTapsRequired:1];
    [_scrollview addGestureRecognizer:singleTap];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageview;
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
