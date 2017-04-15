//
//  SMSleepHeadView.m
//  SuperWatch
//
//  Created by pro on 17/3/6.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SMSleepHeadView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"

@interface SMSleepHeadView ()
{
    UIView * QView;
    UIView * SView;
    UILabel * QLabel;
    UILabel * SLabel;

    UILabel * QXLabel;
    UILabel * QFLabel;

    UILabel * SXLabel;
    UILabel * SFLabel;

//    int deepsleep;
//    int lightsleep;
}
@property (nonatomic , strong) UIView * BlayerView;


@property (nonatomic , strong) UILabel * timeLabel;
@property (nonatomic , strong) UILabel * QXSLabel;
@property (nonatomic , strong) UILabel * QFSLabel;

@property (nonatomic , strong) UILabel * SXSLabel;
@property (nonatomic , strong) UILabel * SFSLabel;


@property (nonatomic , retain) NSArray * chartValues;

@property (nonatomic , strong) UILabel * label;

@property (nonatomic , assign) int deepsleep;
@property (nonatomic , assign) int lightsleep;

@end
@implementation SMSleepHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSMSleepHeadView];
        [self setupCharsSMSHeadView];
    }
    return self;
}
- (void)setupCharsSMSHeadView{
    if (!_chart) {
        _chart = [[VBPieChart alloc] init];
        [_BlayerView addSubview:_chart];
    }

    [self addObserver:_chart
           forKeyPath:@"holeRadiusPrecent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:_chart
           forKeyPath:@"radiusPrecent"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];


    _label = [[UILabel alloc] initWithFrame:CGRectMake(30, 55, 80, 80)];
    _label.font = [UIFont systemFontOfSize:38];
    _label.textColor = [UIColor colorWithHexString:@"#50c0e5"];
    _label.textAlignment = NSTextAlignmentCenter;
//    _label.layer.cornerRadius = 65;
//    _label.layer.masksToBounds = YES;
//    _label.backgroundColor = [UIColor redColor];
    [_BlayerView addSubview:_label];

    _chart.holeRadiusPrecent = 0.75;
    [_chart setFrame:CGRectMake(20, 52, 150, 150)];
    _label.center = _chart.center;
    _label.text = @"0%";

    _deepsleep = 0;
    _lightsleep =0;

    _chart.startAngle = M_PI_2;
//    self.chartValues = @[ // Data can be passed after JSON Deserialization
//                         @{@"name":@"first", @"value":@(_deepsleep), @"color":@"#50c0e5", @"strokeColor":@"#fff"},
//
//                         // Chart can use patterns
//                         @{@"name":@"second", @"value":@(_lightsleep), @"color":@"#4869ba", @"strokeColor":@"#fff"}];

//    [_chart setChartValues:_chartValues animation:YES duration:0.4 options:VBPieChartAnimationFan];

    __weak typeof(self) weakSelf = self;
    _chart.YYlabelName = ^(NSString * name){
        if ([name isEqualToString:@"first"]) {
            weakSelf.label.text = [NSString stringWithFormat:@"%d%%",weakSelf.deepsleep];
        }else{
            weakSelf.label.text = [NSString stringWithFormat:@"%d%%",weakSelf.lightsleep];
        }
    };

//    _chart.labelBlock = ^ (CALayer*layer, NSInteger index){
//
//        return CGPointMake(0, 0);
//
//    };
}

-(void)releaseobserve{
    [self  removeObserver:_chart forKeyPath:@"holeRadiusPrecent"];
    [self removeObserver:_chart forKeyPath:@"radiusPrecent"];
}

-(void)reloadVBPieChart:(int)deep lightSleep:(int)light{
    _deepsleep = deep/(deep + light);
    _lightsleep = light/(deep + light);
    [_chart setHoleRadiusPrecent:0.75];
    [_chart setChartValues:_chartValues animation:YES duration:0.4 options:VBPieChartAnimationFan];
}
-(void)reloadLgihtSMSleep:(int)hour LightMin:(int)min{

    if (hour>0) {
        _QXSLabel.text = [NSString stringWithFormat:@"%d",hour];
    }else{
        _QXSLabel.text = @"0";
    }

    if (min>0) {
        _QFSLabel.text = [NSString stringWithFormat:@"%d",min];
    }else{
        _QFSLabel.text = @"0";
    }
}
-(void)reloadDeepSMSleep:(int)hour DeepMin:(int)min{
    if (hour >0) {
        _SXSLabel.text = [NSString stringWithFormat:@"%d",hour];
    }else{
        _SXSLabel.text = @"0";
    }

    if (min>0) {
        _SFSLabel.text = [NSString stringWithFormat:@"%d",min];
    }else{
        _SFSLabel.text = @"0";
    }
}
-(void)reloadSMSleepTime:(int)alltime{
    int minuteT = alltime%60;
    int hours = alltime/60;
    int days = alltime/60/24;
    NSString * time1 = nil;
    if (minuteT>0 && hours <=0 && days<=0) {


        time1 = [NSString stringWithFormat:@" %d分钟",minuteT];
    }else if (hours>0 && days<=0){
        time1 = [NSString stringWithFormat:@" %d小时%d分钟",hours,minuteT];
    }else if (days >0){
        time1 = [NSString stringWithFormat:@" %d天%d小时%d分钟",days,hours,minuteT];
    }else{
        time1 = [NSString stringWithFormat:@" %d分钟",minuteT];
    }


    _timeLabel.text = [NSString stringWithFormat:@"总睡眠时间: %@",time1];;
}



- (void)setupSMSleepHeadView{
    _BlayerView = [[UIView alloc] init];
    _BlayerView.backgroundColor = [UIColor whiteColor];
    _BlayerView.layer.cornerRadius = 3;
    _BlayerView.layer.masksToBounds = YES;
    _BlayerView.layer.borderColor = [UIColor colorWithHexString:@"#50c0e5"].CGColor;
    _BlayerView.layer.borderWidth = 0.5;
    [self addSubview:_BlayerView];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:17];
    _timeLabel.text = @"总睡眠时间: 0分钟";
    _timeLabel.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_BlayerView addSubview:_timeLabel];

    QView = [[UIView alloc] init];
    QView.layer.cornerRadius = 3;
    QView.layer.masksToBounds = YES;
    QView.backgroundColor = [UIColor colorWithHexString:@"#50c0e5"];
    [_BlayerView addSubview:QView];

    QLabel = [[UILabel alloc] init];
    QLabel.text = @"浅度睡眠";
    QLabel.font = [UIFont systemFontOfSize:14];
    QLabel.textColor = [UIColor colorWithHexString:@"#50c0e5"];
    [_BlayerView addSubview:QLabel];

    _QXSLabel = [[UILabel alloc] init];
    _QXSLabel.text= @"0";
    _QXSLabel.font = [UIFont systemFontOfSize:17];
    _QXSLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [_BlayerView addSubview:_QXSLabel];

    QXLabel = [[UILabel alloc] init];
    QXLabel.text = @"小时";
    QXLabel.font = [UIFont systemFontOfSize:12];
    QXLabel.textColor = [UIColor colorWithHexString:@"737f7f"];
    [_BlayerView addSubview:QXLabel];

    _QFSLabel = [[UILabel alloc] init];
    _QFSLabel.text = @"0";
    _QFSLabel.font = [UIFont systemFontOfSize:17];
    _QFSLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [_BlayerView addSubview:_QFSLabel];

    QFLabel = [[UILabel alloc] init];
    QFLabel.text = @"分钟";
    QFLabel.font = [UIFont systemFontOfSize:12];
    QFLabel.textColor = [UIColor colorWithHexString:@"737f7f"];
    [_BlayerView addSubview:QFLabel];

    SView = [[UIView alloc] init];
    SView.layer.cornerRadius = 3;
    SView.layer.masksToBounds = YES;
    SView.backgroundColor = [UIColor colorWithHexString:@"#4869ba"];
    [_BlayerView addSubview:SView];

    SLabel = [[UILabel alloc] init];
    SLabel.textColor = [UIColor colorWithHexString:@"#4869ba"];
    SLabel.text = @"深度睡眠";
    SLabel.font = [UIFont systemFontOfSize:14];
    [_BlayerView addSubview:SLabel];

    _SXSLabel = [[UILabel alloc] init];
    _SXSLabel.text = @"0";
    _SXSLabel.font = [UIFont systemFontOfSize:17];
    _SXSLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];;
    [_BlayerView addSubview:_SXSLabel];

    SXLabel = [[UILabel alloc] init];
    SXLabel.text = @"小时";
    SXLabel.font = [UIFont systemFontOfSize:12];
    SXLabel.textColor = [UIColor colorWithHexString:@"737f7f"];
    [_BlayerView addSubview:SXLabel];

    _SFSLabel = [[UILabel alloc] init];
    _SFSLabel.text = @"0";
    _SFSLabel.font = [UIFont systemFontOfSize:17];
    _SFSLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [_BlayerView addSubview:_SFSLabel];

    SFLabel = [[UILabel alloc] init];
    SFLabel.text = @"分钟";
    SFLabel.font = [UIFont systemFontOfSize:12];
    SFLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_BlayerView addSubview:SFLabel];



}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_BlayerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
    }];

    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_BlayerView).offset(15);
    }];
    [QView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(42);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(20);
        make.width.height.mas_equalTo(18);
    }];

    [QLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(QView.mas_right).offset(10);
        make.centerY.equalTo(QView);
    }];

    [QFLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(QLabel);
        make.top.equalTo(QLabel.mas_bottom).offset(12.5);
    }];

    [_QFSLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(QFLabel.mas_left);
        make.bottom.equalTo(QFLabel);
    }];

    [QXLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_QFSLabel.mas_left);
        make.bottom.equalTo(_QFSLabel);
    }];

    [_QXSLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(QXLabel.mas_left);
        make.bottom.equalTo(QXLabel);
    }];

    [SFLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(QLabel);
        make.bottom.equalTo(self).offset(-30);
    }];

    [_SFSLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SFLabel.mas_left);
        make.bottom.equalTo(SFLabel);
    }];

     [SXLabel mas_updateConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(_SFSLabel.mas_left);
         make.bottom.equalTo(_SFSLabel);
     }];

    [_SXSLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SXLabel.mas_left);
        make.bottom.equalTo(SXLabel);
    }];

    [SLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(QLabel);
        make.bottom.equalTo(SXLabel.mas_top).offset(-12.5);
    }];

    [SView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SLabel.mas_left).offset(-10);
        make.centerY.equalTo(SLabel);
        make.width.height.mas_equalTo(18);
    }];

//    [_chart mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.width.mas_equalTo(133);
//        make.top.equalTo(QView);
//        make.left.equalTo(_BlayerView).offset(30);
//    }];
//    _chart.backgroundColor = [UIColor orangeColor];
//    [_chart setNeedsLayout];
}
-(void)dealloc{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
