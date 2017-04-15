//
//  SearchAnimationView.m
//  SuperWatch
//
//  Created by pro on 17/2/13.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SearchAnimationView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "CALayer+PauseAimate.h"
@interface SearchAnimationView ()
{
    int time;
}
@property (nonatomic , strong) UIImageView * imgView;

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic , strong) UILabel * promitLabel;

@end
@implementation SearchAnimationView

-(void)startTimer{

    [self pauserTimer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePromitLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];


    time = 0;
    [self addImgViewAnimation];
    [self.imgView.layer resumeAnimate];
}

- (void)pauserTimer{
    [self.timer invalidate];
    self.timer = nil;
//    _imgView.transform = CGAffineTransformRotate(_imgView.transform, 0.1);
    [self.imgView.layer pauseAnimate];
}
/**
 *  雷达旋转方法
 */
- (void)transformView{
    [UIView animateWithDuration:0.1 animations:^{
            _imgView.transform = CGAffineTransformRotate(_imgView.transform, 0.1);
    }];

}
-(void)setTimeP:(int)timeP{
    _timeP = timeP;
    time = timeP+3;


}

-(void)setSeachtransform:(CGAffineTransform)Seachtransform{
    _Seachtransform = Seachtransform;
    _imgView.transform = CGAffineTransformRotate(Seachtransform, M_PI*2*(double)(_timeP/60));
}
- (void)updatePromitLabel{
//      [self transformView];

    if ([_promitLabel.text isEqualToString:@"查找设备中·"]) {
        _promitLabel.text = @"查找设备中··";
    } else if ([_promitLabel.text isEqualToString:@"查找设备中··"]){
        _promitLabel.text = @"查找设备中···";
    } else if ([_promitLabel.text isEqualToString:@"查找设备中···"]){
        _promitLabel.text = @"查找设备中·";
    }else{
        _promitLabel.text = @"查找设备中·";
    }

    time++;
    if (time>15) {
        [self pauserTimer];
        //代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(nofind_MyBle)]) {
            [self.delegate nofind_MyBle];
        }
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchBleTime:WithTransform:)]) {
            [self.delegate SearchBleTime:time WithTransform:_imgView.transform];
        }
    }


}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];

        [self setupSearchAnimationView];
    }

    return self;
}


- (void)setupSearchAnimationView{

    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"connect_icon_find"];
    [self addSubview:_imgView];

    _promitLabel = [[UILabel alloc] init];
    _promitLabel.text =@"查找设备中·";
    _promitLabel.font = [UIFont systemFontOfSize:15];
    _promitLabel.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    [self addSubview:_promitLabel];

    _timeP = 0;

//    [self startTimer];

}


- (void)layoutSubviews{
    [super layoutSubviews];

    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
        make.width.height.mas_equalTo(220);
    }];

    [_promitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_imgView.mas_bottom).offset(50);
    }];

}

- (void)addImgViewAnimation
{

    // 1.创建基本动画
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    // 2.给动画设置一些属性
    rotationAnim.fromValue = @(_timeP/60*M_PI * 2);
    rotationAnim.toValue = @(M_PI * 2*(1-_timeP/60));
    rotationAnim.repeatCount = NSIntegerMax;
    rotationAnim.duration = 10;

    // 3.将动画添加到iconView的layer上面
    [self.imgView.layer addAnimation:rotationAnim forKey:nil];

    
}

-(void)dealloc{

    [self pauserTimer];
//    [self.imgView.layer removeFromSuperlayer];
    [self.imgView.layer removeAllAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
