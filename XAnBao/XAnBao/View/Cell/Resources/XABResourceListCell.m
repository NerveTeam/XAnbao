//
//  XABResourceListCell.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABResourceListCell.h"
#import "Masonry.h"
#import "UILabel+Extention.h"
#import "XABResource.h"
#import "UIImageView+WebCache.h"
#import "MLTool.h"
#import "UIImage+Stretch.h"
#import "UIImageView+Animation.h"

@interface XABResourceListCell ()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *img;
@property(nonatomic, strong)UILabel *commentCount;
@property(nonatomic, strong)UILabel *postDate;
//@property(nonatomic, strong)UIImageView *commentIcon;
@end
@implementation XABResourceListCell
static const CGFloat marginLeft = 10;
static const CGFloat marginTop = 15;
static const CGFloat imgW = 105;
static const CGFloat imgH = imgScale(imgW);
+ (instancetype)newsSportListCellWithTableView:(UITableView *)tableView {
    XABResourceListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.postDate];
        [self.contentView addSubview:self.commentCount];
        [self viewLayout];
    }
    return self;
}

- (void)setSportList:(XABResource *)sportList {
    _sportList = sportList;
    self.titleLabel.text = sportList.title;
    [self.titleLabel sizeToFit];
    [self.img sd_setImageWithURL:[NSURL URLWithString:sportList.coverUrl] placeholderImage:[UIImage imageNamed:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493274238533&di=afd56661e1e34fd48e0333e222cda78f&imgtype=0&src=http%3A%2F%2Fpic2.16pic.com%2F00%2F20%2F02%2F16pic_2002642_b.jpg"]];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:@"2016-7-16 09:33:22"];
    self.postDate.text = sportList.publishTime;
    if (![sportList.visits isEqualToString:@"0"]) {
            self.commentCount.text = sportList.visits;
    }
    if (self.sportList.coverUrl == nil || [self.sportList.coverUrl isEqualToString:@""]) {
        [self.img mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(marginTop);
            make.bottom.equalTo(self.contentView).offset(-marginTop);
            make.width.offset(0);
            make.height.offset(imgH);
        }];
    }
    
}
- (void)viewLayout {
    
    
    [self.img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(marginLeft);
        make.top.equalTo(self.contentView).offset(marginTop);
        make.bottom.equalTo(self.contentView).offset(-marginTop);
        make.width.offset(imgW);
        make.height.offset(imgH);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img);
        make.left.equalTo(self.img.mas_right).offset(marginLeft);
        make.right.equalTo(self.contentView).offset(-marginLeft);
        //        make.width.offset(200);
    }];
    
    [self.postDate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.img);
    }];
    
//    [self.commentIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-marginLeft);
//        make.bottom.equalTo(self.postDate);
//    }];
//    
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-marginLeft);
                make.bottom.equalTo(self.postDate);
    }];
    
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:nil fontSize:14];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    }
    return _titleLabel;
}
- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        _img.clipsToBounds = YES;
    }
    return _img;
}
- (UILabel *)postDate {
    if (!_postDate) {
        _postDate = [UILabel labelWithText:nil fontSize:12];
        _postDate.textColor = RGBACOLOR(194, 194, 194, 1);
    }
    return _postDate;
}
- (UILabel *)commentCount {
    if (!_commentCount) {
        _commentCount = [UILabel labelWithText:nil fontSize:12];
        _commentCount.textColor = RGBACOLOR(194, 194, 194, 1);
    }
    return _commentCount;
}
//- (UIImageView *)commentIcon {
//    if (!_commentIcon) {
//        _commentIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment"]];
//    }
//    return _commentIcon;
//}

@end
