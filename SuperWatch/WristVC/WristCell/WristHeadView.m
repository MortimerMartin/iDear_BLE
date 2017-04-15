//
//  WristHeadView.m
//  SuperWatch
//
//  Created by pro on 17/3/2.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "WristHeadView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "CircleAnimationView.h"
#import "UIView+CLExtension.h"
//5,5s的设备
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface WristHeadView ()

{
    UILabel * current_B;
    UILabel * finishi_B;
}
@property (nonatomic , strong) UIView * backSView;


@property (nonatomic , strong) UIImageView * LYimg;
@property (nonatomic , strong) UILabel * LY_status;
@property (nonatomic , strong) UIImageView * element; //电池
@property (nonatomic , strong) UIView * element_status;
@property (nonatomic , strong) UILabel * element_num;

@property (nonatomic , strong) CircleAnimationView * progressView;

@property (nonatomic , strong) UIView * currentView;
@property (nonatomic , strong) UILabel * currentLabel;
@property (nonatomic , strong) UILabel * current_status;


@property (nonatomic , strong) UIView * finishView;
@property (nonatomic , strong) UILabel * finishLabel;
@property (nonatomic , strong) UILabel * finish_status;

@end
@implementation WristHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupWristHeadView];
    }

    return self;
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self.progressView drawProgress:progress];
}
-(void)setSHFill:(BOOL)SHFill{
    _SHFill = SHFill;
    if (SHFill != YES) {
        _backSView.layer.cornerRadius = 4;
        _backSView.layer.masksToBounds = YES;
        _backSView.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
        _backSView.layer.borderWidth = 0.5;
    }

}
-(void)setElement_D:(int)element_D{
    _element_D = element_D;
    _element_num.text = [NSString stringWithFormat:@"%d%%",element_D];

    if (element_D>100) {
        element_D = 100;
        _element_num.text = @"100%";
    }



        CGFloat x = 30.0*((double)(100 - element_D)/100);



    NSLog(@">>>>>>>>Power%f",x);
//    [_element_status mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_element).offset(x);
//    }];
    if (x == 0.0) {
        _element_status.cl_x = x+3;
        _element_status.cl_width = 30.0-4;
    }else{
        if (_element_D>70 && _element_D<90) {

            _element_status.cl_x = x+1.5;
            _element_status.cl_width = 30.0-x-2.5;
        }else{
            _element_status.cl_x = x-1;
            _element_status.cl_width = 30.0-x;
        }

    }


    if (element_D>30) {
        _element_status.backgroundColor = [UIColor colorWithHexString:@"#38c750"];
    }else if (element_D<30 && element_D>10){
        _element_status.backgroundColor = [UIColor colorWithHexString:@"#f0d312"];
    }else{
        _element_status.backgroundColor = [UIColor colorWithHexString:@"#d23030"];
    }
}


-(void)setConnect_status:(NSString *)connect_status{
    _connect_status = connect_status;
    if (connect_status == nil) {
        connect_status = @"未连接";
    }
    
    if (_SHFill == YES) {
        _LY_status.text = [NSString stringWithFormat:@"设备连接状态:  %@",connect_status];
    }else{
        _LY_status.text = connect_status;
        _LYimg.image = [UIImage imageNamed:@"home_icon_bracelet_s"];
    }

}

- (void)setCurrent_b:(int)current_b{
    _current_b = current_b;
    if (current_b >=1000) {
        int a = current_b/1000;

        int b = current_b%1000;
        if (b==0) {
            _current_status.text = [NSString stringWithFormat:@"%d,000",a];
        }else{

            if (b<100) {
                _current_status.text = [NSString stringWithFormat:@"%d,0%d",a,b];


            }else{
                _current_status.text = [NSString stringWithFormat:@"%d,%d",a,b];
            }

        }

    }else{
        _current_status.text = [NSString stringWithFormat:@"%d",current_b];
    }

}

- (void)setFinish_b:(int)finish_b{
    _finish_b = finish_b;

    if (finish_b >=1000) {
        int a = finish_b/1000;
        int b = finish_b%1000;
        if (b==0) {
            _finish_status.text = [NSString stringWithFormat:@"%d,000",a];
        }else{
            _finish_status.text = [NSString stringWithFormat:@"%d,%d",a,b];
        }

    }else{
        _finish_status.text = [NSString stringWithFormat:@"%d",finish_b];
    }

};
- (void)setupWristHeadView{

    _backSView = [[UIView alloc] init];
    _backSView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backSView];

    _LYimg = [[UIImageView alloc] init];
    _LYimg.image = [UIImage imageNamed:@"measure_icon_bluetooth"];
    [_backSView addSubview:_LYimg];

    _LY_status = [[UILabel alloc] init];
    _LY_status.font = [UIFont systemFontOfSize:15];
    _LY_status.textColor = [UIColor colorWithHexString:@"#737f7f"];
    _LY_status.text = @"设备连接状态:  未连接";
    [_backSView  addSubview:_LY_status];

    _element = [[UIImageView alloc] init];
    _element.image = [UIImage imageNamed:@"bracelet_icon_person"];
    [_backSView  addSubview:_element];

    _element_status = [[UIView alloc] initWithFrame:CGRectMake(3, 1, _element.image.size.width-4, _element.image.size.height-2)];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_element_status.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(2,2)];
//
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//
//    maskLayer.frame = _element_status.bounds;
//
//    maskLayer.path = maskPath.CGPath;
//
//    _element_status.layer.mask = maskLayer;
   // _element_status.layer.cornerRadius = 2;
  //  _element_status.layer.masksToBounds = YES;
    _element_status.backgroundColor = [UIColor colorWithHexString:@"#38c750"];
    [_element addSubview:_element_status];

    _element_num = [[UILabel alloc] init];
    _element_num.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    _element_num.text = @"0%";
    _element_num.font = [UIFont systemFontOfSize:13];
    [_backSView  addSubview:_element_num];

    _progressView = [[CircleAnimationView alloc] init];
//    _progressView.backgroundColor = [UIColor redColor];
    [_backSView  addSubview:_progressView];



    _currentView = [[UIView alloc] init];
    _currentView.layer.cornerRadius = 3;
    _currentView.layer.masksToBounds = YES;
    _currentView.backgroundColor = [UIColor colorWithHexString:@"0fc2af"];
    [_backSView  addSubview:_currentView];

    _currentLabel = [[UILabel alloc] init];
    _currentLabel.text = @"当前步数";
    _currentLabel.textColor = [UIColor colorWithHexString:@"0fc2af"];
    _currentLabel.font = [UIFont systemFontOfSize:14];

    [_backSView  addSubview:_currentLabel];


    _current_status = [[UILabel alloc] init];
    _current_status.textColor = [UIColor colorWithHexString:@"565c5c"];
    _current_status.font = [UIFont systemFontOfSize:23];
    [_backSView  addSubview:_current_status];

    current_B = [[UILabel alloc] init];
    current_B.font = [UIFont systemFontOfSize:15];
    current_B.textColor = [UIColor colorWithHexString:@"#737f7f"];
    current_B.text = @"步";
    [_backSView  addSubview:current_B];


    _finishView = [[UIView alloc] init];
    _finishView.layer.cornerRadius = 3;
    _finishView.layer.masksToBounds = YES;
    _finishView.backgroundColor = [UIColor colorWithHexString:@"#dfe7e7"];
    [_backSView  addSubview:_finishView];

    _finishLabel = [[UILabel alloc] init];
    _finishLabel.text = @"目标步数";
    _finishLabel.font = [UIFont systemFontOfSize:14];
    _finishLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backSView  addSubview:_finishLabel];

    _finish_status = [[UILabel alloc] init];
    _finish_status.textColor = [UIColor colorWithHexString:@"#565c5c"];
    _finish_status.font = [UIFont systemFontOfSize:23];
    [_backSView  addSubview:_finish_status];

    finishi_B = [[UILabel alloc]  init];
    finishi_B.font = [UIFont systemFontOfSize:15];
    finishi_B.textColor = [UIColor colorWithHexString:@"#565c5c"];
    finishi_B.text = @"步";
    [_backSView  addSubview:finishi_B];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutWristHeadView];
}


- (void)layoutWristHeadView{
    [_backSView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_SHFill == YES) {
            make.left.right.bottom.top.equalTo(self);
        }else{
            make.left.top.equalTo(self).offset(12.5);
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-12.5);;
        };
    }];
    
    [_LYimg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_backSView).offset(12);
        make.width.height.mas_equalTo(20);
    }];

    [_LY_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_LYimg.mas_right).offset(12);
        make.centerY.equalTo(_LYimg);
    }];

    [_element_num mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backSView).offset(-12);
        make.centerY.equalTo(_LYimg);

    }];

    [_element mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_element_num.mas_left).offset(-6);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(_LYimg);
    }];

//    [_element_status mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_element).offset(1);
//        make.left.equalTo(_element).offset(3);
//        make.bottom.right.equalTo(_element).offset(-1);
//    }];


    [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LY_status.mas_bottom).offset(18);
//        make.centerX.equalTo(_LY_status);

        if (kDevice_Is_iPhone5) {
            make.left.equalTo(_LYimg);
        }else{
            make.left.equalTo(_LY_status).offset(-5);
            //        make.centerY.equalTo(self).offset(30);

        }
//        make.centerY.equalTo(self).offset(30);
        make.width.height.mas_equalTo(155);
    }];


    [_currentLabel mas_updateConstraints:^(MASConstraintMaker *make) {

        if (kDevice_Is_iPhone5) {
            make.right.equalTo(_element_num.mas_right);
        }else{
            make.right.equalTo(_element);

        }
        make.top.equalTo(_progressView).offset(13);
    }];

    [_currentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_currentLabel.mas_left).offset(-12);
        make.width.height.mas_equalTo(17);
        make.centerY.equalTo(_currentLabel);
    }];

    [current_B mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_currentLabel);
        make.top.equalTo(_currentLabel.mas_bottom).offset(22);
    }];

    [_current_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(current_B.mas_left);
        make.bottom.equalTo(current_B);
    }];

    [_finishLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_currentLabel);
        make.top.equalTo(current_B.mas_bottom).offset(22);
    }];

    [_finishView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_finishLabel.mas_left).offset(-12);
        make.width.height.mas_equalTo(17);
        make.centerY.equalTo(_finishLabel);
        make.centerX.equalTo(_currentView);
    }];

    [finishi_B mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_currentLabel);
        make.top.equalTo(_finishLabel.mas_bottom).offset(22);
    }];

    [_finish_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(finishi_B.mas_left);
        make.bottom.equalTo(finishi_B);
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
