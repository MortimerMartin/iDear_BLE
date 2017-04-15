//
//  ApplyPersonCell.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ApplyPersonCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface ApplyPersonCell ()
{
    UIView * _line;
    UIView * topLine;
}
@property (nonatomic , strong) UIImageView * headImg;
@property (nonatomic , strong) UILabel * nameLabel;
@property (nonatomic , strong) UILabel * descriptLabel;
//@property (nonatomic , strong) UIButton * agreeBtn;
//@property (nonatomic , strong) UIButton * disagreenBtn;
@property (nonatomic , strong) UILabel * statusLabel;
//@property (nonatomic , strong) UIView * line;

@end
@implementation ApplyPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupApplyPersonCell];
    }
    return self;
}

- (void)setupApplyPersonCell{

    _headImg = [[UIImageView alloc] init];
    _headImg.layer.cornerRadius = 20;
    _headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImg];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#303434"];
    [self.contentView addSubview:_nameLabel];

    _descriptLabel = [[UILabel alloc] init];
    _descriptLabel.font = [UIFont systemFontOfSize:13];
    _descriptLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.contentView addSubview:_descriptLabel];

    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn setImage:[UIImage imageNamed:@"add_btn_agree_def"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"add_btn_agree_pre"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_agreeBtn];
    _agreeBtn.hidden = NO;
    _disagreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_disagreenBtn setImage:[UIImage imageNamed:@"add_btn_refuse_def"] forState:UIControlStateNormal];
    [_disagreenBtn setImage:[UIImage imageNamed:@"add_btn_refuse_pre"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_disagreenBtn];
    _disagreenBtn.hidden = NO;
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_statusLabel];
    _statusLabel.hidden = YES;
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    [self.contentView addSubview:_line];

    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];

    [self.contentView addSubview:topLine];

}

- (void)setHeadURL:(NSString *)headURL{
    _headURL = headURL;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:headURL]];
}

- (void)setApplyname:(NSString *)applyname{
    _applyname = applyname;
    _nameLabel.text = applyname;
}

- (void)setApplydescript:(NSString *)applydescript{
    _applydescript = applydescript;
    _descriptLabel.text = applydescript;
}
-(void)setIsAgree:(NSString *)isAgree{
    _isAgree = isAgree;
    _agreeBtn.hidden = YES;
    _disagreenBtn.hidden = YES;
    _statusLabel.hidden = NO;
    if ([_isAgree isEqualToString:@"同意"]) {
        _statusLabel.textColor = [UIColor colorWithHexString:@"#0fc2af"];
        _statusLabel.text = @"已同意";
    }else if([_isAgree isEqualToString:@"不同意"]){
        _statusLabel.textColor = [UIColor colorWithHexString:@"9aa9a9"];
        _statusLabel.text = @"已拒绝";
    }else{
        _agreeBtn.hidden = NO;
        _disagreenBtn.hidden = NO;
        _statusLabel.hidden= YES;
    }

}


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

    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(12.5);
        make.centerY.equalTo(self.contentView).offset(-10);;
    }];

    [_descriptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.centerY.equalTo(self.contentView).offset(10);
    }];

    [_agreeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.height.mas_equalTo(32);
    }];

    [_disagreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_agreeBtn.mas_left).offset(-20);
        make.width.height.mas_equalTo(32);
    }];

    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_agreeBtn);
    }];

    [_line mas_updateConstraints:^(MASConstraintMaker *make) {
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
