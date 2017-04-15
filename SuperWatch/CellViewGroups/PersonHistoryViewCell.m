//
//  PersonHistoryViewCell.m
//  SuperWatch
//
//  Created by pro on 17/2/18.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonHistoryViewCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
@interface PersonHistoryViewCell ()

@property (nonatomic , strong) UIView * historyView;
@property (nonatomic , strong) UIImageView * imgname;
@property (nonatomic , strong) UILabel * nameLabel;
@property (nonatomic , strong) UILabel * contentLabel;

@end
@implementation PersonHistoryViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupCollectionHistoryCell];
    }
    return self;
}

-(void)setupCollectionHistoryCell{
    _historyView = [[UIView alloc] init];
    _historyView.backgroundColor = [UIColor whiteColor];
    _historyView.layer.cornerRadius = 5;
    _historyView.layer.masksToBounds = YES;
    _historyView.layer.borderWidth = 0.5;
    _historyView.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
    [self.contentView addSubview:_historyView];

    _imgname = [[UIImageView alloc] init];
    [_historyView addSubview:_imgname];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    [_historyView addSubview:_nameLabel];

    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:25];
    _contentLabel.textColor = [UIColor colorWithHexString:@"#0fc2af"];
    [_historyView addSubview:_contentLabel];

}

//- (void)setImg_name:(NSString *)img_name{
//    _img_name = img_name;
//    _imgname.image = [UIImage imageNamed:img_name];
//}

-(void)setFun_name:(NSString *)fun_name{
    _fun_name = fun_name;
    _nameLabel.text = fun_name;

    if ([fun_name isEqualToString:@"内脏脂肪"]) {
         _imgname.image = [UIImage imageNamed:@"measure_icon_visceral"];
    }else if ([fun_name isEqualToString:@"骨量"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_bone"];
    }else if ([fun_name isEqualToString:@"BMR(基础代谢)"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_BMR"];
    }else if ([fun_name isEqualToString:@"体重"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_weight"];
    }else if ([fun_name isEqualToString:@"体脂率"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_bodyfat"];
    }else if ([fun_name isEqualToString:@"肌肉量"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_muscle"];
    }else if ([fun_name isEqualToString:@"水分含量"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_water"];
    }else if ([fun_name isEqualToString:@"身体年龄"]){
        _imgname.image = [UIImage imageNamed:@"measure_icon_age"];
    }else{

    }

}

- (void)setFun_content:(NSString *)fun_content{
    _fun_content = fun_content;
    _contentLabel.text = fun_content;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_historyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];

    [_imgname mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(20);
        make.left.top.equalTo(_historyView).offset(10);
    }];

    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgname);
        make.left.equalTo(_imgname.mas_right).offset(10);
    }];


    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_historyView).offset(-10);
        make.bottom.equalTo(_historyView).offset(-10);
    }];
}

@end
