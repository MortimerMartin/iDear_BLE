//
//  LeftTableViewCell.m
//  SuperWatch
//
//  Created by pro on 17/3/9.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "LeftTableViewCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
@interface LeftTableViewCell ()

//@property (nonatomic , strong) UIButton * leftBtn;
@property (nonatomic , strong) UIImageView * img;

@property (nonatomic , strong) UILabel * leftLabel;

@end
@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLeftTVCell];
    }
    return self;
}

- (void)setupLeftTVCell{
//    _leftBtn = [[UIButton alloc] init];
//    [self.contentView addSubview:_leftBtn];

    _img = [[UIImageView alloc] init];
    [self.contentView addSubview:_img];

    _leftLabel = [[UILabel alloc] init];
    _leftLabel.font = [UIFont systemFontOfSize:15];
    _leftLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [self.contentView addSubview:_leftLabel];
}
- (void)setNormal_img:(NSString *)normal_img{
    _normal_img = normal_img;
    _img.image = [UIImage imageNamed:normal_img];
//    [_leftBtn setImage:[UIImage imageNamed:normal_img] forState:UIControlStateNormal];
}
//- (void)setHlight_img:(NSString *)hlight_img{
//    _hlight_img = hlight_img;
////    [_leftBtn setImage:[UIImage imageNamed:hlight_img] forState:UIControlStateHighlighted];
//}

- (void)setCell_title:(NSString *)cell_title{
    _cell_title = cell_title;
    _leftLabel.text = cell_title;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.height.width.mas_equalTo(24);
        make.centerY.equalTo(self.contentView);
    }];

    [_leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(20);
        make.centerY.equalTo(_img);
    }];
}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
