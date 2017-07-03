//
//  XABUploadImage.m
//  XAnBao
//
//  Created by Minlay on 17/4/28.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABUploadImageCell.h"
#import "UIButton+Extention.h"
#import "UIImageView+WebCache.h"
#import "UIButton+ImageTitleSpacing.h"
#import "XABEnclosure.h"

@interface XABUploadImageCell ()<UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIButton *imgBtn;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic, strong)XABEnclosure *enclosure;
@property(nonatomic, strong)UIButton *deleteBtn;
@end
@implementation XABUploadImageCell


- (void)setModel:(id)model {
    if ([model isKindOfClass:[XABEnclosure class]]) {
        self.enclosure = (XABEnclosure *)model;
        if (self.enclosure.isLocal) {
            self.imageView.image = [UIImage imageWithData:self.enclosure.imageData];
        }else {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.enclosure.url]];
        }
    }
    
    
    [self layoutFrame:[model isKindOfClass:[NSString class]]];
}

- (void)layoutFrame:(BOOL)isChoose {
    if (isChoose) {
        self.imgBtn.hidden = NO;
        self.imageView.hidden = YES;
        [self.contentView addSubview:self.imgBtn];
        [self.imgBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).offset(10);
        }];
    }else {
        self.imgBtn.hidden = YES;
        self.imageView.hidden = NO;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.deleteBtn];
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).offset(10);
        }];
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.imageView);
        }];
    }
}

- (void)handelTapEvent {
    [self openPhotoLibrary];
}

- (void)deleteImg {
    if ([_delegate respondsToSelector:@selector(deleteImage:)]) {
        [_delegate deleteImage:self];
    }
}

- (void)openCamera

{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES; //可编辑
    
    //判断是否可以打开照相机
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        
        //摄像头
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navgationController presentViewController:picker animated:YES completion:nil];
        
    }
    
    else
        
    {
        
        NSLog(@"没有摄像头");
        
    }
    
}

-(void)openPhotoLibrary

{
      // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self.navgationController presentViewController:imagePicker animated:YES completion:^{
            
            NSLog(@"打开相册");
            
        }];
        
    }
    
    else
        
    {
        
        NSLog(@"不能打开相册");
        
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imgData = UIImagePNGRepresentation(image);
    if ([_delegate respondsToSelector:@selector(uploadDidFinish:)]) {
        [_delegate uploadDidFinish:imgData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//- (void)layoutSubviews {
// 
//}

- (UIButton *)imgBtn {
    if (!_imgBtn) {
        _imgBtn = [UIButton buttonWithTitle:@"添加图片" fontSize:15 titleColor:ThemeColor];
        _imgBtn.layer.cornerRadius = 5;
        _imgBtn.clipsToBounds = YES;
        _imgBtn.layer.borderWidth = 0.5;
        [_imgBtn setImage:[UIImage imageNamed:@"attach_camera"] forState:UIControlStateNormal];
        [_imgBtn sizeToFit];
        [_imgBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        _imgBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_imgBtn addTarget:self action:@selector(handelTapEvent) forControlEvents:UIControlEventTouchUpInside];
        [_imgBtn sizeToFit];
    }
    return _imgBtn;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc ]init];
    }
    
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithImageNormal:@"content_btn_del" imageHighlighted:@"content_btn_del"];
        [_deleteBtn addTarget:self action:@selector(deleteImg) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
@end
