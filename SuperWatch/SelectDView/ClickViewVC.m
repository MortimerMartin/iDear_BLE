//
//  ClickViewVC.m
//  SuperWatch
//
//  Created by Mortimer on 17/3/31.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ClickViewVC.h"
#import "UIColor+HexString.h"
#import "Masonry.h"

@interface ClickViewVC ()

@property (nonatomic , strong) UIView * backgroundView;
@property (nonatomic , strong) UIImageView * bottomImg;
@property (nonatomic , strong) UIImageView * left_icon;
@property (nonatomic , strong) UILabel * left_connect_device;
@property (nonatomic , strong) UIImageView * right_img;


@end
@implementation ClickViewVC


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        [self setupClickView];
    }
    return self;
}

-(void)setupClickView{


    _bottomImg = [[UIImageView alloc] init];
    _bottomImg .image = [UIImage imageNamed:@"background"];
    [self addSubview:_bottomImg];

    _backgroundView = [[UIView alloc] init];
    _backgroundView.layer.cornerRadius = 3;
    _backgroundView.layer.masksToBounds = YES;
    _backgroundView.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
   _backgroundView.layer.borderWidth = 0.5;
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroundView];

    _left_icon = [[UIImageView alloc] init];
    [_backgroundView addSubview:_left_icon];

    _left_connect_device = [[UILabel alloc] init];
    _left_connect_device.font = [UIFont systemFontOfSize:15];
    _left_connect_device.textColor = [UIColor colorWithHexString:@"#303434"];

    [_backgroundView addSubview:_left_connect_device];

    UIButton * addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage imageNamed:@"home_icon_add_def"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"home_icon_add_pre"] forState:UIControlStateHighlighted];
    [_backgroundView addSubview:addBtn];
    //    UIImageView * img_j = [[UIImageView alloc] init];
    //    img_j.image = [UIImage imageNamed:@""];
    //    [view addSubview:img_j];



    [addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backgroundView).offset(-15);
        make.centerY.equalTo(_backgroundView);
    }];
}
- (void)setTableView_section:(NSInteger)tableView_section{
    _tableView_section = tableView_section;
    if (tableView_section == 0) {
        _left_icon.image = [UIImage imageNamed:@"home_icon_bracelet_l"];
        _left_connect_device.text = @"连接手环";
        _bottomImg.hidden = YES;
    }else if (tableView_section == 1){
        _left_icon.image = [UIImage imageNamed:@"home_icon_scales_l"];
        _left_connect_device.text = @"连接体脂秤";
        _bottomImg.hidden = NO;
    }else{
        _left_icon.image = [UIImage imageNamed:@"home_icon_bracelet_l"];
        _left_connect_device.text = @"连接手环";
        _bottomImg.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [_bottomImg mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_tableView_section == 1) {
            make.bottom.right.left.equalTo(self);
            make.height.mas_equalTo(110);
        }
    }];

    [_backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_tableView_section == 0) {
            make.left.top.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
//            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_SH"]) {
//
//
//            }
            make.bottom.equalTo(self);
        }else if (_tableView_section == 1){

//            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_TZC"]) {
//
//            }
            make.left.top.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.height.mas_equalTo(60);

        }else{
            make.left.top.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self);
        }


    }];

    [_left_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundView).offset(12);
        make.centerY.equalTo(_backgroundView);
    }];

    [_left_connect_device mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_left_icon.mas_right).offset(15);
        make.centerY.equalTo(_left_icon);
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
