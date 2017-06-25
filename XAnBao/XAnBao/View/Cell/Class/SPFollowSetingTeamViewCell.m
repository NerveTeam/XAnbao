//
//  SPFollowSetingTeamViewCell.m
//  sinaSports
//
//  Created by 磊 on 15/12/23.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import "SPFollowSetingTeamViewCell.h"
#import "UILabel+Extention.h"
#define DefaultColor RGBCOLOR(51, 51, 51)
#define SelectColor ThemeColor
#define DefaultFont [UIFont systemFontOfSize:15]
#define SelectFont [UIFont systemFontOfSize:17]
@interface SPFollowSetingTeamViewCell ()
@property(nonatomic, strong)UILabel *teamName;
@property(nonatomic, strong)UIView *redIconView;
@property(nonatomic, strong)UIView *separatorBottom;
@property(nonatomic, strong)UIView *separatorRight;
@end
@implementation SPFollowSetingTeamViewCell

+ (instancetype)followSetingTeamViewCellWithtTableView:(UITableView *)tableView {
    
    SPFollowSetingTeamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[SPFollowSetingTeamViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    
    return cell;

}

- (void)setModel:(NSDictionary *)partition follow:(NSArray *)follow {
    self.teamName.text = [partition objectForKeySafely:@"name"];
//    if ([follow containsObject:partition]) {
//        [self showOrigin:YES];
//    }
}

- (void)showOrigin:(BOOL)isShowOrigin {
    self.redIconView.hidden = !isShowOrigin;
}

- (void)changeCellStyleSelect:(BOOL)isSelect isTop:(BOOL)isTop{
    if (isSelect) {
        self.teamName.textColor = SelectColor;
        self.separatorRight.hidden = YES;
        self.separatorBottom.hidden = YES;
        self.teamName.font = SelectFont;
        return;
    } else if (isTop) {
        self.teamName.textColor = DefaultColor;
        self.separatorBottom.hidden = YES;
        return;

    }
        self.teamName.textColor = DefaultColor;
        self.separatorRight.hidden = NO;
        self.separatorBottom.hidden = NO;
        self.teamName.font = DefaultFont;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.teamName];
        [self.contentView addSubview:self.redIconView];
        [self.contentView addSubview:self.separatorBottom];
        [self.contentView addSubview:self.separatorRight];
    }
    
    return self;
}



#pragma mark - layoutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.teamName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
    }];
    
    self.redIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.redIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13.5);
        make.right.equalTo(self.contentView).offset(-15.5);
        make.width.height.offset(6);
    }];
    
    self.separatorBottom.translatesAutoresizingMaskIntoConstraints = NO;
    [self.separatorBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView);
        make.height.offset(1);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    self.separatorRight.translatesAutoresizingMaskIntoConstraints = NO;
    [self.separatorRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-1);
        make.width.offset(1);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - lazy
- (UILabel *)teamName {
    if (!_teamName) {
        _teamName = [UILabel labelWithText:@"" fontSize:15 textColor:DefaultColor];
        [_teamName sizeToFit];
    }
    return _teamName;
}
- (UIView *)redIconView {
    if (!_redIconView) {
        _redIconView = [[UIView alloc]init];
        _redIconView.backgroundColor = SelectColor;
        _redIconView.hidden = YES;
        _redIconView.layer.cornerRadius = 3;
        _redIconView.clipsToBounds = YES;
    }
    return _redIconView;
}
- (UIView *)separatorBottom {
    if (!_separatorBottom) {
        _separatorBottom = [[UIView alloc]init];
        _separatorBottom.backgroundColor = RGBCOLOR(221, 221, 221);
    }
    return _separatorBottom;
}
- (UIView *)separatorRight {
    if (!_separatorRight) {
        _separatorRight = [[UIView alloc]init];
        _separatorRight.backgroundColor = RGBCOLOR(221, 221, 221);
    }
    return _separatorRight;
}
@end
