//
//  PersonHistoryCell.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonHistoryCell.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "Masonry.h"
@interface PersonHistoryCell ()
{
    UIView * line;
}
@property (nonatomic , strong) UILabel * timeLabel;
@property (nonatomic , strong) UIImageView * img;
@property (nonatomic , strong) UILabel * right_info;
@end
@implementation PersonHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupHistoryCell];
    }
    return self;
}

- (void)setTime:(NSString *)time{
    _time = time;
    _timeLabel.text = time;

}

- (void)setWeight:(NSString *)weight{
    _weight = weight;
    _right_info.text = weight;
}
- (void)setupHistoryCell{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.contentView addSubview:_timeLabel];


    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@"person_btn_go"];
    [self.contentView addSubview:_img];

    _right_info = [[UILabel alloc] init];
    _right_info.textColor = [UIColor colorWithHexString:@"#565c5c"];
    _right_info.textAlignment = NSTextAlignmentRight;
    _right_info.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_right_info];

    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:line];

}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)layoutSubviews{
    [super layoutSubviews];


    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(9);

    }];

    [_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-9);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
    }];


    [_right_info mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_img);
            make.right.equalTo(_img.mas_left).offset(-7);
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
