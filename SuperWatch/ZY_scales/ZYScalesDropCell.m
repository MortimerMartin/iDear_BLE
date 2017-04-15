//
//  ZYScalesDropCell.m
//  SuperWatch
//
//  Created by Mortimer on 17/3/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ZYScalesDropCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "FFDropDownMenuModel.h"
@interface ZYScalesDropCell ()

@property (nonatomic , strong) UIImageView * headImg;
@property (nonatomic , strong) UILabel * title;
@property (nonatomic , strong) UIView * line;

@end
@implementation ZYScalesDropCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setupDropCell];
    }
    return self;
}

-(void)setupDropCell{
    UIImageView * img = [[UIImageView alloc] init];
    img.userInteractionEnabled = YES;

    [self.contentView addSubview:img];
    self.headImg = img;

    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:19.0];
    label.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [self.contentView addSubview:label];
    self.title = label;

    UIView * separater = [[UIView alloc] init];
    separater.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:separater];
    self.line = separater;
}

-(void)setDrop_title:(NSString *)drop_title{
    _drop_title = drop_title;
    _title.text = drop_title;
}

-(void)setDrop_source:(NSString *)drop_source{
    _drop_source = drop_source;
    if (![_drop_title isEqualToString:@"新增成员"]) {
        _headImg.layer.cornerRadius = 12.0f;
        _headImg.layer.masksToBounds = YES;
        [_headImg sd_setImageWithURL:[NSURL URLWithString:drop_source]];
    }else{

        _headImg.image = [UIImage imageNamed:drop_source];
    }

}
-(void)setOnlyYOU:(BOOL)onlyYOU{
    _onlyYOU = onlyYOU;
    if (_onlyYOU == YES) {
        _line.hidden = YES;
    }
}

-(void)setMenuModel:(id)menuModel{
    _menuModel = menuModel;
     FFDropDownMenuModel *realMenuModel = (FFDropDownMenuModel *)menuModel;
    _title.text = realMenuModel.menuItemTitle;
    _drop_title = _title.text;
    if (![realMenuModel.menuItemTitle isEqualToString:@"新增成员"]) {
        _headImg.layer.cornerRadius = 12.0f;
        _headImg.layer.masksToBounds = YES;
        [_headImg sd_setImageWithURL:[NSURL URLWithString:realMenuModel.menuItemIconName]];
    }else{
        _title.textColor = [UIColor colorWithRed:32/255.0 green:150/255.0 blue:198/255.0 alpha:1];;
        _headImg.image = [UIImage imageNamed:realMenuModel.menuItemIconName];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_applyF != YES) {
        [_headImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView);
            if (![_drop_title isEqualToString:@"新增成员"]) {
                make.width.height.mas_equalTo(24);
            }else{
                make.width.height.mas_equalTo(16);
            }
            
        }];
    }


    [_title mas_updateConstraints:^(MASConstraintMaker *make) {

        if (_applyF == YES) {
            make.centerX.centerY.equalTo(self.contentView);
        }else{
            make.left.equalTo(_headImg.mas_right).offset(8);
            make.centerY.equalTo(_headImg);
        }

    }];

    [_line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
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
