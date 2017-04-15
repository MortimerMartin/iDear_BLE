//
//  CDTableViewCell.m
//  SuperWatch
//
//  Created by pro on 17/3/2.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CDTableViewCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"

@interface CDTableViewCell ()
{
    UIView * topLine;
    UIView * bottomLine;
}
@property (nonatomic , strong) UILabel * Device_name;
@property (nonatomic , strong) UIImageView * imaView;

@end

@implementation CDTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCDCell];
    }

    return self;
}


- (void)setupCDCell{

    _Device_name = [[UILabel alloc] init];
    _Device_name.font = [UIFont systemFontOfSize:14];
    _Device_name.textColor = [UIColor colorWithHexString:@"#303434"];
    [self.contentView addSubview:_Device_name];

    _imaView = [[UIImageView alloc] init];
    _imaView.image = [UIImage imageNamed:@"facility_icon_select"];
    [self.contentView addSubview:_imaView];
    _imaView.hidden = YES;

    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:topLine];

    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:bottomLine];

}

-(void)setDevicename:(NSString *)devicename{
    _devicename = devicename;
    _Device_name.text = devicename;
}


- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected == YES) {
        _imaView.hidden = NO;
    }else{
        _imaView.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];


    [_Device_name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(11.5);
    }];

    [_imaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(12.5);
    }];

    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];

    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];

}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
