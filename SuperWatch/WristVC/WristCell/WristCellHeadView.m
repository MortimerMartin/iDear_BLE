//
//  WristCellHeadView.m
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "WristCellHeadView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"

@interface WristCellHeadView ()

@property (nonatomic , strong) UIView * backGroundView;
@property (nonatomic , strong) UIView * whiteView;

@property (nonatomic , strong) UIImageView * fun_img;
@property (nonatomic , strong) UILabel * fun_label;
@property (nonatomic , strong) UILabel * fun_top_status;
@property (nonatomic , strong) UILabel * fun_bottom_status;
@property (nonatomic , strong) UILabel * fun_status;

@end
@implementation WristCellHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupWristCell];
    }

    return self;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    _fun_label.textColor = color;
    _backGroundView.layer.borderColor = color.CGColor;
    _whiteView.backgroundColor = color;
}
- (void)setImg_name:(NSString *)img_name{
    _img_name = img_name;
    _fun_img.image = [UIImage imageNamed:img_name];
}

- (void)setFun_name:(NSString *)fun_name{
    _fun_name = fun_name;
    _fun_label.text = fun_name;

}

-(void)setFun_content:(NSString *)fun_content{
    _fun_content = fun_content;
    _fun_status.text = fun_content;
}

-(void)setFun_top:(NSString *)fun_top{
    _fun_top = fun_top;

    _fun_top_status.text = fun_top;
}

- (void)setFun_bottom:(NSString *)fun_bottom{
    _fun_bottom = fun_bottom;
    _fun_bottom_status.text = fun_bottom;
}

- (void)setupWristCell{
    _backGroundView = [[UIView alloc] init];
    _backGroundView.layer.cornerRadius = 5;
    _backGroundView.layer.masksToBounds = YES;
    _backGroundView.layer.borderWidth = 1;
    [self addSubview:_backGroundView];

    _whiteView = [[UIView alloc] init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_backGroundView addSubview:_whiteView];

    _fun_img = [[UIImageView alloc] init];
    [_backGroundView addSubview:_fun_img];

    _fun_label = [[UILabel alloc] init];
    _fun_label.textAlignment = NSTextAlignmentCenter;
    _fun_label.font = [UIFont systemFontOfSize:16];
    [_backGroundView addSubview:_fun_label];

    _fun_top_status = [[UILabel alloc] init];
    _fun_top_status.font = [UIFont systemFontOfSize:14];
    _fun_top_status.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGroundView addSubview:_fun_top_status];

    _fun_bottom_status = [[UILabel alloc] init];
    _fun_bottom_status.font = [UIFont systemFontOfSize:14];
    _fun_bottom_status.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGroundView addSubview:_fun_bottom_status];

    _fun_status = [[UILabel alloc] init];
    _fun_status.textAlignment = NSTextAlignmentRight;
    _fun_status.font = [UIFont systemFontOfSize:14];
    _fun_status.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGroundView addSubview:_fun_status];

}


- (void)layoutSubviews{
    [super layoutSubviews];

    [_backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-6);
    }];

    [_whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_backGroundView);
        make.width.mas_equalTo(5);
    }];

    [_fun_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(15);
        make.top.equalTo(_backGroundView).offset(8);
        make.height.width.mas_equalTo(25);
    }];


    [_fun_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fun_img.mas_right).offset(10);
        make.centerY.equalTo(_fun_img);
    }];

    [_fun_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backGroundView).offset(-8);
        make.centerY.equalTo(_fun_img);
    }];

    [_fun_top_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fun_img);
        make.centerY.equalTo(_backGroundView);
    }];

    [_fun_bottom_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fun_img);
        make.top.equalTo(_fun_top_status.mas_bottom).offset(14);
    }];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
