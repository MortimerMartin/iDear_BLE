//
//  newPersonCell.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "newPersonCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
@interface newPersonCell ()
{
    UIView * line;
}
@property (nonatomic , strong) UIImageView * person;
@property (nonatomic , strong) UILabel * apply;
@property (nonatomic , strong) UIView * redView;

@end
@implementation newPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupNewPersonCell];
    }

    return self;
}

- (void)setupNewPersonCell{
    _person = [[UIImageView alloc] init];
    _person.image = [UIImage imageNamed:@"nav_icon_add"];
    [self.contentView addSubview:_person];

    _apply = [[UILabel alloc] init];
    _apply.text = @"新成员申请";
    _apply.font = [UIFont systemFontOfSize:15];
    _apply.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [self.contentView addSubview:_apply];

    _redView = [[UIView alloc] init];
    _redView.backgroundColor = [UIColor redColor];
    _redView.layer.cornerRadius = 4;
    _redView.layer.masksToBounds = YES;
    [self.contentView addSubview:_redView];
    _redView.hidden = YES;

    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];

    [self.contentView addSubview:line];

}

- (void)setIsNewApply:(BOOL)isNewApply{
    _isNewApply = isNewApply;
    if (isNewApply) {
        _redView.hidden = NO;
    }else{
        _redView.hidden = YES;
    }
}
- (void)setIsNewAdd:(BOOL)isNewAdd{
    _isNewAdd = isNewAdd;
    if (isNewAdd) {
        _redView.hidden = YES;
        _person.image = [UIImage imageNamed:@"family_btn_add"];
        _apply.text = @"新增成员";
        _apply.textColor = [UIColor colorWithHexString:@"#0d9dcd"];
    }else{
        _person.image = [UIImage imageNamed:@"nav_icon_add"];
        _apply.text = @"新成员申请";
        _apply.textColor = [UIColor colorWithHexString:@"#565c5c"];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];

    [_person mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);

    }];

    [_apply mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_person);
        make.left.equalTo(_person.mas_right).offset(15);

    }];

    [_redView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
        make.width.height.mas_equalTo(8);
    }];

    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
