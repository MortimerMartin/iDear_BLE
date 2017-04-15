//
//  CHEditLastTVCell.m
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CHEditLastTVCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
@interface CHEditLastTVCell ()
{
    UIView * topL;
    UIView * bottomL;
}
@property (nonatomic , strong) UILabel * left_fun;
@property (nonatomic , strong) UIImageView * imgOK;


@property (nonatomic , strong) UILabel * timeLabel;

@end
@implementation CHEditLastTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCHEditLastCell];
    }
    return self;
}

- (void)setupCHEditLastCell{
    _left_fun = [[UILabel alloc] init];
    _left_fun.font = [UIFont systemFontOfSize:15];
    _left_fun.textColor = [UIColor colorWithHexString:@"#303434"];
    [self.contentView addSubview:_left_fun];

    _imgOK = [[UIImageView alloc] init];
    _imgOK.image = [UIImage imageNamed:@"facility_icon_select"];
    [self.contentView addSubview:_imgOK];
    _imgOK.hidden = YES;

    _first_switch = [[UISwitch alloc] init];
    [self.contentView addSubview:_first_switch];
    _first_switch.hidden = YES;

    _timeLabel =[[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#0fc2af"];
    _timeLabel.text = @"重置手环时间";
    [self.contentView addSubview:_timeLabel];
    _timeLabel.hidden = YES;

    topL = [[UIView alloc] init];
    topL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:topL];

    bottomL = [[UIView alloc] init];
    bottomL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:bottomL];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _left_fun.text = title;
}
//-(void)setTime_title:(NSString *)time_title{
//    _time_title = time_title;
//    _timeLabel.text = time_title;
//}
-(void)setShowRight_fun:(int)showRight_fun{
    _showRight_fun = showRight_fun;
    if (showRight_fun == 1) {
        _imgOK.hidden = NO;
    }else if (showRight_fun == 2){
        _first_switch.hidden = NO;
    }else if (showRight_fun == 3){
        _timeLabel.hidden = NO;
    }else{
        _imgOK.hidden = YES;
        _first_switch.hidden = YES;
        _timeLabel.hidden = YES;
    }
    
}



-(void)layoutSubviews{

    [super layoutSubviews];
    
    [topL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];



    [bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_isTwo == YES) {
             topL.hidden = YES;
            make.left.right.bottom.equalTo(self.contentView);
        }else if (_showRight_fun == 3){

            make.left.right.bottom.equalTo(self.contentView);
        }else{

            make.left.equalTo(self.contentView).offset(12);
            make.bottom.right.equalTo(self.contentView);
        }

        make.height.mas_equalTo(0.5);
    }];

    if (_showRight_fun == 3) {

    }
    [_left_fun mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];

    [_imgOK mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(8);
    }];

    [_first_switch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];

    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.contentView);
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
