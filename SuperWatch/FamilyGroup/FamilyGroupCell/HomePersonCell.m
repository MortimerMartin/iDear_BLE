//
//  HomePersonCell.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "HomePersonCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface HomePersonCell ()
{
    UIView * line;
    UIView * topLine;
}
@property (nonatomic , strong) UIImageView * headImg;
@property (nonatomic , strong) UILabel * name;
@property (nonatomic , strong) UIImageView * sex;
@property (nonatomic , strong) UILabel * age;
@property (nonatomic , strong) UIImageView * isMelist;



@end
@implementation HomePersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupHomePersonCell];
    }

    return self;
}


- (void)setHeadURL:(NSString *)headURL{
    _headURL = headURL;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:headURL]];
}

- (void)setFamily_name:(NSString *)family_name{
    _family_name = family_name;
    _name.text = family_name;
}

- (void)setFamily_age:(NSString *)family_age{
    _family_age = family_age;
    _age.text = [NSString stringWithFormat:@"%@岁",family_age];
}

- (void)setFamily_sex:(NSString *)family_sex{
    _family_sex = family_sex;
    if ([family_sex isEqualToString:@"男"]) {
        _sex.image = [UIImage imageNamed:@"family_icon_man"];
    }else{
        _sex.image = [UIImage imageNamed:@"family_icon_woman"];
    }
}

- (void)setIsHidentView:(BOOL)isHidentView{
    _isHidentView = isHidentView;
    if (isHidentView) {
        if (_isMe) {

        }else{
            _deletBtn.hidden = NO;
            _editBtn.hidden = NO;
            _isMelist.hidden = YES;
            _reportBtn.hidden = YES;
        }

    }else{
        _deletBtn.hidden = YES;
        _editBtn.hidden = YES;
        _isMelist.hidden = NO;
        _reportBtn.hidden = NO;
    }

}

//- (void)setIsMe:(BOOL)isMe{
//    _isMe = isMe;
//    if (isMe) {
//
//    }
//}

- (void)setupHomePersonCell{

    _headImg = [[UIImageView alloc] init];
    _headImg.layer.cornerRadius = 22.5f;
    _headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImg];

    _name = [[UILabel alloc] init];
    _name.font = [UIFont systemFontOfSize:14];
    _name.textColor = [UIColor colorWithHexString:@"#303434"];
    [self.contentView addSubview:_name];

    _sex = [[UIImageView alloc] init];
    [self.contentView addSubview:_sex];

    _age = [[UILabel alloc] init];
    _age.font = [UIFont systemFontOfSize:13];
    _age.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.contentView addSubview:_age];

    _isMelist = [[UIImageView alloc] init];
     _isMelist.image = [UIImage imageNamed:@"facility_icon_select"];
    [self.contentView addSubview:_isMelist];

    _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reportBtn setImage:[UIImage imageNamed:@"family_btn_report_def"] forState:UIControlStateNormal];
    [_reportBtn setImage:[UIImage imageNamed:@"family_btn_report_pre"] forState:UIControlStateHighlighted];
//    [_reportBtn addTarget:self action:@selector(reportInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_reportBtn];
    _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deletBtn setImage:[UIImage imageNamed:@"family_btn_delete_def"] forState:UIControlStateNormal];
    [_deletBtn setImage:[UIImage imageNamed:@"family_btn_delete_pre"] forState:UIControlStateHighlighted];
//    [_deletBtn addTarget:self action:@selector(deleteInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deletBtn];
    _deletBtn.hidden = YES;


    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _editBtn.backgroundColor = [UIColor redColor];
    [_editBtn setImage:[UIImage imageNamed:@"family_btn_compole_def"] forState:UIControlStateNormal];
    [_editBtn setImage:[UIImage imageNamed:@"family_btn_compole_pre"] forState:UIControlStateHighlighted];
//    [_editBtn addTarget:self action:@selector(editInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    _editBtn.hidden = YES;
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];

    [self.contentView addSubview:line];

    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];

    [self.contentView addSubview:topLine];
}
//- (void)reportInfo:(UIButton *)sender{
//    if (_report_block) {
//        _report_block();
//    }
//}
//
//- (void)deleteInfo:(UIButton *)sender{
//    if (_delete_block) {
//        _delete_block();
//    }
//}
//
//- (void)editInfo:(UIButton *)sender{
//    if (_edit_block) {
//        _edit_block();
//    }
//}
- (void)layoutSubviews{
    [super layoutSubviews];

    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];

    [_headImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];

    [_name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(15);
        make.centerY.equalTo(self.contentView).offset(-10);;
    }];

    [_sex mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(15);
        make.centerY.equalTo(self.contentView).offset(10);
        make.height.width.mas_equalTo(16);
    }];

    [_age mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sex.mas_right).offset(5);
        make.centerY.equalTo(_sex);

    }];

    if (_isMe) {
        [_isMelist mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(8);
        }];
    }else{
        [_reportBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(20);
        }];
    }




    [_deletBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
         make.right.equalTo(self.contentView).offset(-10);
        make.width.height.mas_equalTo(20);
    }];

    [_editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_deletBtn.mas_left).offset(-15);
        make.width.height.mas_equalTo(20);
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
