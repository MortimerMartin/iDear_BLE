//
//  SetocCell.m
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SetocCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
@interface SetocCell ()
{
    UIView * topLine;
    UIView * bottomLine;
}
@property (nonatomic , strong) UILabel * setName;


@end

@implementation SetocCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSETCell];
    }

    return self;
}

- (void)setupSETCell{
    _setName = [[UILabel alloc] init];
    _setName.textColor = [UIColor colorWithHexString:@"#303434"];
    _setName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_setName];

    _setOpenBtn = [[UISwitch alloc] init];
//    [_setOpenBtn setImage:[UIImage imageNamed:@"btn_close_def"] forState:UIControlStateNormal];
//    [_setOpenBtn setImage:[UIImage imageNamed:@"btn_close_pre"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_setOpenBtn];

    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:topLine];

    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:bottomLine];

}

-(void)setSet_name:(NSString *)set_name{
    _set_name = set_name;
    _setName.text = set_name;
}

- (void)setLineHidden:(int)lineHidden{
    _lineHidden = lineHidden;
    if (lineHidden != 0 ) {
        topLine.hidden = YES;
    }

};

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSETCellView];
}

- (void)layoutSETCellView{
    [_setName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];

    [_setOpenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];

    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_lineHidden ==0 || _lineHidden == 1) {
            make.left.equalTo(self.contentView).offset(12);
            make.right.bottom.equalTo(self.contentView);
        }else{
            make.left.right.bottom.equalTo(self.contentView);
        }

        make.height.mas_equalTo(0.5);
    }];
}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
