//
//  SMSleepCell.m
//  SuperWatch
//
//  Created by pro on 17/3/6.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SMSleepCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import <QuartzCore/QuartzCore.h>
@interface SMSleepCell ()
{
//    UIView * leftLine;
//    UIView * rightLine;
    UIView * bottomLine;
}
@property (nonatomic , strong) UILabel * timeLabel;
@property (nonatomic , strong) UILabel * sleepStatus;
@property (nonatomic , strong) UIView * backGSSView;

@end
@implementation SMSleepCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSMSleepCell];
    }

    return self;
}

- (void)setupSMSleepCell{
//    _backGSSView = [[UIView alloc] init];
//    [self.contentView addSubview:_backGSSView];

    _timeLabel  = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#50c0e5"];
    [self.contentView addSubview:_timeLabel];

    _sleepStatus = [[UILabel alloc] init];
    _sleepStatus.font = [UIFont systemFontOfSize:15];
    _sleepStatus.textAlignment= NSTextAlignmentRight;
    _sleepStatus.textColor = [UIColor colorWithHexString:@"#50c0e5"];
    [self.contentView addSubview:_sleepStatus];

//    leftLine = [[UIView alloc] init];
//    leftLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
//    [_backGSSView addSubview:leftLine];
//
//    rightLine = [[UIView alloc] init];
//    rightLine.backgroundColor =[UIColor colorWithHexString:@"#c9cdcd"];
//    [_backGSSView addSubview:rightLine];

    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:bottomLine];
}

-(void)setLastrow:(BOOL)lastrow{
    _lastrow = lastrow;

}

- (void)setTime:(NSString *)time{
    _time = time;
    _timeLabel.text = time;
}

- (void)setStatus:(NSString *)status{
    _status = status;
    if ([status isEqualToString:@"深度睡眠"]) {
        _timeLabel.textColor = [UIColor colorWithHexString:@"#4869ba"];
        _sleepStatus.textColor = [UIColor colorWithHexString:@"#4869ba"];
    }
    _sleepStatus.text = status;
}

- (void)layoutSubviews{
    [super layoutSubviews];

//    [_backGSSView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(12);
//        make.right.equalTo(self.contentView).offset(-12);
//        make.top.bottom.equalTo(self.contentView);
//    }];

//    if (_lastrow == YES) {
//        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_backGSSView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
//        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _backGSSView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _backGSSView.layer.mask = maskLayer;
//    }

    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.centerY.equalTo(self.contentView);
    }];

    [_sleepStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-18);
        make.centerY.equalTo(self.contentView);
    }];

    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel);
        make.right.equalTo(_sleepStatus);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];

//    [leftLine mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(_backGSSView);
//        make.width.mas_equalTo(0.5);
//    }];
//
//    [rightLine mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.top.bottom.equalTo(_backGSSView);
//        make.width.mas_equalTo(0.5);
//    }];


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
