//
//  deviceCell.m
//  SuperWatch
//
//  Created by pro on 17/2/13.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "deviceCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
@interface deviceCell ()
{
    UIView * topL;
    UIView * bottomL;
}
@property (nonatomic , strong) UILabel * deviceName;

@property (nonatomic , strong) UILabel * deviceTime;

@property (nonatomic , strong) UIImageView * selectImg;

@end
@implementation deviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self addDeviceSubViews];
    }
    return self;
}

- (void)addDeviceSubViews{

    _deviceName = [[UILabel alloc] init];
    _deviceName.font = [UIFont systemFontOfSize:14];
    _deviceName.textColor = [UIColor colorWithHexString:@"#303434"];
    [self.contentView addSubview:_deviceName];

    _deviceTime = [[UILabel alloc] init];
    _deviceTime.font = [UIFont systemFontOfSize:12];
    _deviceTime.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    [self.contentView addSubview:_deviceTime];

    _selectImg = [[UIImageView alloc] init];
//    _selectImg.backgroundColor = [UIColor redColor];
    _selectImg.image = [UIImage imageNamed:@"facility_icon_select"];
    [self.contentView addSubview:_selectImg];
    _selectImg.hidden = YES;

    topL = [[UIView alloc] init];
    topL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:topL];

    bottomL = [[UIView alloc] init];
    bottomL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self addSubview:bottomL];

}

- (void)setDevice_name:(NSString *)device_name{
    _device_name = device_name;
    _deviceName.text =  [NSString stringWithFormat:@"地尔体脂秤iDear-%@",device_name];

}

- (void)setDevice_time:(NSString *)device_time{
    _device_time = device_time;
    if (device_time && device_time.length>0) {
        _deviceTime.text = [NSString stringWithFormat:@"上次连接时间：%@",device_time];
    }else{
        _deviceTime.text = @"上次连接时间：无";
    }

}

- (void)setSelectD:(BOOL)selectD{
    _selectD = selectD;
    if (_selectD == YES) {
        _selectImg.hidden = NO;
    }else{
        _selectImg.hidden = YES;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];

    [_deviceName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-60);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-4);
    }];

    [_deviceTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deviceName);
        make.right.equalTo(self.contentView).offset(-60);
        make.top.equalTo(self.contentView.mas_centerY).offset(4);;
    }];

    [_selectImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.width.mas_equalTo(12);

    }];

    [topL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

    [bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
