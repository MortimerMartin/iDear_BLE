//
//  SMSleepSectionHeadView.m
//  SuperWatch
//
//  Created by pro on 17/3/6.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SMSleepSectionHeadView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
@interface SMSleepSectionHeadView ()
{
    UIView * bottomL;
}
//@property (nonatomic , strong) UIView * backlayerView;
@property (nonatomic , strong) UILabel * timeLabel;
@property (nonatomic , strong) UILabel * statusLabel;


@end
@implementation SMSleepSectionHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSMSleepSectionHeadView];
    }

    return self;
}


- (void)setupSMSleepSectionHeadView{
//    _backlayerView = [[UIView alloc] init];
//    _backlayerView.layer.borderWidth = 0.5;
//    _backlayerView.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
//    _backlayerView.layer.cornerRadius = 3;
//    
//    [self addSubview:_backlayerView];

    _timeLabel  = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    _timeLabel.text = @"时间段";
    [self addSubview:_timeLabel];

    _statusLabel = [[UILabel alloc] init];
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.textColor = [UIColor colorWithHexString:@"#9aa9a9"];;
    _statusLabel.text = @"睡眠状况";
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_statusLabel];

    bottomL = [[UIView alloc] init];
    bottomL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self addSubview:bottomL];

}


- (void)layoutSubviews{
    [super layoutSubviews];

//    _backlayerView.frame = CGRectMake(12, 12, self.frame.size.width - 24, self.frame.size.height - 12);
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backlayerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3,3)];
//
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//
//    maskLayer.frame = _backlayerView.bounds;
//
//    maskLayer.path = maskPath.CGPath;
//
//    _backlayerView.layer.mask = maskLayer;

//    [_backlayerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(self).offset(12);
//        make.right.equalTo(self).offset(-12);
//        make.bottom.equalTo(self);
//    }];


    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.centerY.equalTo(self);
    }];

    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18);
        make.centerY.equalTo(self);
    }];

    [bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
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
