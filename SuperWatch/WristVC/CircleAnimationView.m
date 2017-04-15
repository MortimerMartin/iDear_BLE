//
//  CircleAnimationView.m
//  SuperWatch
//
//  Created by pro on 17/3/2.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CircleAnimationView.h"
#import "UIView+CLExtension.h"
#import "UIColor+HexString.h"
#import "Masonry.h"

@interface CircleAnimationView ()
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic , strong) UILabel * progressLabel;

@end
@implementation CircleAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self seupProgressLabel];
//        [self seupGraidLayer];
    }

    return self;
}
- (UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:30];
        _progressLabel.textColor = [UIColor colorWithHexString:@"#0fc2af"];
        _progressLabel.center = CGPointMake(77.5, 77.5);
        [self addSubview:_progressLabel];
    }

    return _progressLabel;
}
- (void)seupProgressLabel{
    self.progressLabel.text = @"100%";

    CGPoint center = CGPointMake(77.5, 77.5);
    CGFloat radius = 60;
    CGFloat startA = - M_PI_2;  //设置进度条起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 ;  //设置进度条终点位置

    //绘制背景
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 10; //线的宽度
    shapeLayer.strokeColor = [[UIColor  colorWithHexString:@"#dfe7e7"] CGColor] ; //指定path的渲染颜色,这里可以设置任意不透明颜色
    shapeLayer.opacity = 1;//背景颜色的透明度
    shapeLayer.fillColor = [[UIColor clearColor] CGColor]; //填充色为无色
    shapeLayer.frame = self.bounds;
UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    shapeLayer.path = [path CGPath];
    [self.layer addSublayer:shapeLayer];

}

- (void)seupGraidLayer{
    CGPoint center = CGPointMake(77.5, 77.5);
    CGFloat radius = 60;
    CGFloat startA = M_PI_2;  //设置进度条起点位置
    CGFloat endA = M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置

    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = 15;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_progressLayer];


    CAGradientLayer * cradient = [CAGradientLayer layer];
    cradient.frame = self.bounds;
    [cradient setColors:[NSArray arrayWithObjects:
                         (id)[[UIColor colorWithHexString:@"#35d4a1"] CGColor],

                         (id)[[UIColor colorWithHexString:@"#1ac7ab"] CGColor],
                         nil]];
    [cradient setMask:self.progressLayer];

    [self.layer addSublayer:cradient];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _progressLabel.center = CGPointMake(self.cl_width/2, self.cl_height/2);
}
- (void)drawProgress:(CGFloat )progress
{
    if (progress !=0) {


//        _progressLabel.text = [NSString stringWithFormat:@"%d%%",p];

        if (progress>1) {
            _progress = 1;
            int p = progress*100;

            _progressLabel.text = [NSString stringWithFormat:@"%d%%",p];
        }else{
            _progress = progress;
            int p = progress*1000;
//            NSLog(@",,,,,,,,%f",progress);
            if (p<10) {
                _progressLabel.text = [NSString stringWithFormat:@"0.%d%%",p];
            }else if (p >= 10 && p <100){
                NSString * top = [[NSString stringWithFormat:@"%d",p] substringWithRange:NSMakeRange(0, 1)];
                NSString * last = [[NSString stringWithFormat:@"%d",p] substringWithRange:NSMakeRange(1, 1)];
                _progressLabel.text = [NSString stringWithFormat:@"%@.%@%%",top,last];
            }else{
                NSString * top = [[NSString stringWithFormat:@"%d",p] substringWithRange:NSMakeRange(0, 2)];
                NSString * last = [[NSString stringWithFormat:@"%d",p] substringWithRange:NSMakeRange(2, 1)];
                _progressLabel.text = [NSString stringWithFormat:@"%@.%@%%",top,last];
            }

        }

    }else{
            _progressLabel.text = @"0%";
        
    }

    _progressLayer.opacity = 0;
//    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {


    [self seupGraidLayer];
}


@end
