//
//  WritShadeView.m
//  SuperWatch
//
//  Created by Mortimer on 17/3/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "WritShadeView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UIView+Extension.h"
@interface WritShadeView ()

@property (nonatomic , strong) NSTimer * Writimer;
@property (nonatomic , strong) UIView * centerView;
@property (nonatomic , strong) UILabel * statusLabel;
@property (nonatomic , strong) UIImageView * statusImg;

@end
@implementation WritShadeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:0.9];
        [self setupWristShadeView];
        self.hidden = YES;
    }
    return self;
}

/**
 *  开启计时器>
 */
-(void)startWritTimer{
    self.hidden = NO;

   NSTimer * timer   = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatusLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    self.Writimer = timer;

    if (_statusImg.hidden == YES) {
        _statusImg.hidden = NO;
        [self layoutWritSubViews];
    }
}
/**
 *  关闭计时器>
 */
- (void)pauseWritTimer:(NSString *)status{
    [_Writimer invalidate];
    _Writimer = nil;;

    _statusLabel.text = status;
    _statusImg.hidden = YES;

    [UIView animateWithDuration:2 animations:^{
//        _statusLabel.center = _centerView.center;
//
        [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_centerView).offset(10);
            make.right.bottom.equalTo(_centerView).offset(-10);
        }];

//        CGRect frame = _centerView.frame;
//        CGRect frame1 = _statusLabel.frame;
//        frame.size.width = 100;
//        frame.size.height = 40;
//        frame1.size.width = 80;
//        frame1.size.height = 30;
//        _centerView.frame = frame;
//        _statusLabel.frame = frame1;
//        _statusLabel.center = _centerView.center;
//        _centerView.height = 80;
//        _centerView.size = CGSizeMake(100, 40);
//        _statusLabel.size = CGSizeMake(80, 30);
//        _statusLabel.text = @"数据同步完成";
//        _centerView.center = self.center;
//        _statusLabel.center = CGPointMake(_centerView.center.x - 30, _centerView.center.y);
//        [self layoutWristEndView];
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:2 animations:^{
            _centerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }completion:^(BOOL finished) {
            self.alpha = 0;
            self.hidden = YES;
        }];

    }];
}
-(void)pauserTimeAndHidden{
    [_Writimer invalidate];
    _Writimer = nil;
//    self.alpha = 0;
    self.hidden = YES;
//    [self removeFromSuperview];
}
/**
 *  旋转方法
 */
- (void)updateStatusLabel{
    if ([_statusLabel.text isEqualToString:@"数据同步中..."]) {
        _statusLabel.text = @"数据同步中.";
    }else if ([_statusLabel.text isEqualToString:@"数据同步中."]){
        _statusLabel.text = @"数据同步中..";
    }else if ([_statusLabel.text isEqualToString:@"数据同步中.."]){
        _statusLabel.text = @"数据同步中...";
    }else{
        _statusLabel.text = @"数据同步中.";
    }
    _statusImg.transform = CGAffineTransformRotate(_statusImg.transform, -10);
}


- (void)setupWristShadeView{

    UIView * view = [[UIView alloc] init];
    view.layer.cornerRadius = 4.0f;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.centerView = view;

    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = @"数据同步中...";
    label.textColor = [UIColor colorWithHexString:@"#565c5c"];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    self.statusLabel = label;

    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"measure_icon_schedule"];
    [view addSubview:imgView];
    self.statusImg = imgView;



}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self layoutWritSubViews];

}

/**
 *  添加约束
 */
- (void)layoutWritSubViews{

    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(200);
    }];

    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerView);
        make.top.equalTo(_centerView).offset(10);
    }];

    [_statusImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerView);
        make.top.equalTo(_statusLabel.mas_bottom).offset(10);
        make.width.height.mas_equalTo(23.5);
    }];
}
/**
 *  更新约束
 */
- (void)layoutWristEndView{
    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];

    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_centerView).offset(10);
        make.right.bottom.equalTo(_centerView).offset(-10);
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
