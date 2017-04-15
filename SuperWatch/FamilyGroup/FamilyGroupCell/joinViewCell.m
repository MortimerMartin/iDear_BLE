//
//  joinViewCell.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "joinViewCell.h"
#import "UIView+CLExtension.h"
#import "UIColor+HexString.h"
#import "Masonry.h"

@interface joinViewCell ()

@property (nonatomic , strong) UIImageView * home;
@property (nonatomic , strong) UILabel * num;
@property (nonatomic , strong) UILabel * time;
@property (nonatomic , strong) UILabel * status;

@end
@implementation joinViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupJoinCell];
    }
    return self;
}

- (void)setupJoinCell{
    _home = [[UIImageView alloc] init];
    _home.image = [UIImage imageNamed:@"nav_btn_family"];
    [self.contentView addSubview:_home];

    _num = [[UILabel alloc] init];
    _num.font = [UIFont systemFontOfSize:14];
    _num.textColor = [UIColor colorWithHexString:@"#303434"];
    [self.contentView addSubview:_num];

    _time = [[UILabel alloc] init];
    _time.font = [UIFont systemFontOfSize:13];
    _time.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.contentView addSubview:_time];

    _status = [[UILabel alloc] init];
    _status.font = [UIFont systemFontOfSize:13];
    _status.textColor = [UIColor colorWithHexString:@"#0fc2af"];
    [self.contentView addSubview:_status];

}

- (void)setNumber:(NSString *)number{
    _number = number;
    _num.text = number;
}

- (void)setApply:(NSString *)apply{
    _apply = apply;
    _time.text = apply;
}

- (void)setText_color:(NSString *)text_color{
    _text_color = text_color;
    _status.text = _text_color;
    if ([text_color isEqualToString:@"0"]) {
        _status.textColor = [UIColor colorWithHexString:@"#0fc2af"];
        _status.text = @"等待中";
    }else if ([text_color isEqualToString:@"1"]){
        _status.textColor = [UIColor colorWithHexString:@"#0fc2af"];
        _status.text = @"已通过";

    }else{

         _status.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
        _status.text = @"已拒绝";
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_home mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.height.width.mas_equalTo(40);
    }];

    [_num mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-10);
        make.left.equalTo(_home.mas_right).offset(18);

    }];

    [_time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_num);
        make.centerY.equalTo(self.contentView).offset(10);
    }];

    [_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self).offset(-12);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
