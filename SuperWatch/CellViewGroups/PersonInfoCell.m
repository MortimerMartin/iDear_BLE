//
//  PersonInfoCell.m
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonInfoCell.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface PersonInfoCell ()
{
    UIView * line;
    UIView * topLine;
}
@property (nonatomic , strong) UILabel * left_name;
@property (nonatomic , strong) UIImageView * headImg;
@property (nonatomic , strong) UIImageView * img;
@property (nonatomic , strong) UILabel * right_info;

@end
@implementation PersonInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupPersonInfoCell];
    }
    return self;
}

- (void)setupPersonInfoCell{

    _left_name = [[UILabel alloc] init];
    _left_name.font = [UIFont systemFontOfSize:15];
    _left_name.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.contentView addSubview:_left_name];

    _headImg = [[UIImageView alloc] init];
//    _headImg.backgroundColor = [UIColor redColor];
    _headImg.layer.cornerRadius = 22.5;
    _headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImg];

    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@"person_btn_go"];
    [self.contentView addSubview:_img];

    _right_info = [[UILabel alloc] init];
    _right_info.textColor = [UIColor colorWithHexString:@"#565c5c"];
    _right_info.textAlignment = NSTextAlignmentRight;
    _right_info.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_right_info];

    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:line];

    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:topLine];
    topLine.hidden = YES;
}

- (void)setInfo:(NSString *)info{
    _info = info;
    _right_info.text = info;
}

- (void)setInfo_name:(NSString *)info_name{
    _info_name = info_name;
    _left_name.text = info_name;
}

- (void)setInfo_img:(NSString *)info_img{
    _info_img = info_img;

    if (![info_img isEqualToString:@"icon"]) {
        [_headImg sd_setImageWithURL:[NSURL URLWithString:info_img]];
    }else{
        _headImg.image = [UIImage imageNamed:info_img];
    }
}

-(void)setShowTopLine:(BOOL)showTopLine{
    _showTopLine = showTopLine;
    if (showTopLine == YES) {
        topLine.hidden = NO;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];

    [_left_name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        if ([_info_name isEqualToString:@"手环解绑"]) {
            _left_name.textColor = [UIColor colorWithHexString:@"#0fc2af"];
            make.centerX.equalTo(self.contentView);
        }else{
            make.left.equalTo(self.contentView).offset(9);
        }


    }];

    if (![_info_name isEqualToString:@"手环解绑"]) {
        [_img mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-9);
            make.width.mas_equalTo(7);
            make.height.mas_equalTo(15);
        }];
    }


    if (_info_img) {
        [_headImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_img);
            make.right.equalTo(_img.mas_left).offset(-7);
            make.height.width.mas_equalTo(45);
        }];
    }else{

        [_right_info mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_img);
            make.right.equalTo(_img.mas_left).offset(-7);
        }];
    }


    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
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
