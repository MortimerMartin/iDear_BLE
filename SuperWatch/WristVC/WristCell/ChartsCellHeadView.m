//
//  ChartsCellHeadView.m
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ChartsCellHeadView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "BEMSimpleLineGraphView.h"
#import "UIView+CLExtension.h"
#define KDevice_Is_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface ChartsCellHeadView ()<BEMSimpleLineGraphDelegate , BEMSimpleLineGraphDataSource>
{
    UIView * leftView;
}
@property (nonatomic , strong) UIView * backGroundView;
@property (nonatomic , strong) UIView * whiteView;
@property (nonatomic , strong) UIImageView * fun_img;
@property (nonatomic , strong) UILabel * fun_label;
@property (nonatomic , strong) UILabel * fun_status;

/**            ***
 *     心跳图    *
 ***            **/
@property (nonatomic , strong) BEMSimpleLineGraphView * chartsView;
@property (nonatomic , strong) NSArray * values;
@property (nonatomic , strong) NSArray * dates;
@property (nonatomic , strong) UIView * bottomView;

@property (nonatomic , strong) UIImageView * imgBL;

@end
@implementation ChartsCellHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupheartCell];
        [self setupChartsView];
    }
    return self;
}

-(void)setImg_name:(NSString *)img_name{
    _img_name = img_name;
    _fun_img.image =[UIImage imageNamed:img_name];
}

- (void)setFun_name:(NSString *)fun_name{
    _fun_name = fun_name;
    _fun_label.text = fun_name;
}
- (void)setFun_content:(NSString *)fun_content{
    _fun_content = fun_content;
    _fun_status.text = fun_content;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    _backGroundView.layer.borderColor = color.CGColor;
    _whiteView.backgroundColor = color;
    _fun_label.textColor = color;
}

-(void)setHeartValue:(NSArray *)heartValue{
    _heartValue = heartValue;


    _values = [heartValue copy];
    _dates = @[@""];
    [_chartsView reloadGraph];
}

- (void)setupChartsView{
    _chartsView = [[BEMSimpleLineGraphView alloc] init];
//    _chartsView.backgroundColor = [UIColor greenColor];
//WithFrame:CGRectMake(-42, 0, self.cl_width -42, 80)
    _chartsView.delegate = self;
    _chartsView.dataSource = self;
    //    _chartsView.gradientBottom = [self CGGradientWithColors];
//    _chartsView.backgroundColor = [UIColor redColor];
    _chartsView.colorTop = [UIColor clearColor];
    _chartsView.colorTouchInputLine = [UIColor whiteColor];
    _chartsView.colorLine = [UIColor clearColor];
    _chartsView.colorBottom =  [UIColor clearColor];
//    _chartsView.colorXaxisLabel = [UIColor whiteColor];
    _chartsView.labelFont = [UIFont systemFontOfSize:12];

    _chartsView.colorBackgroundPopUplabel = [UIColor clearColor];

    _chartsView.enableTouchReport = YES;
    _chartsView.enablePopUpReport = YES;
    _chartsView.enableYAxisLabel = YES;
    _chartsView.autoScaleYAxis = YES;
    _chartsView.enableXAxisLabel = YES;
    self.chartsView.alwaysDisplayDots = NO;

    _chartsView.enableReferenceAxisFrame = YES;
    _chartsView.animationGraphStyle = BEMLineAnimationDraw;
    // Dash the y reference lines
//    _chartsView.lineDashPatternForReferenceYAxisLines = @[@(1),@(1)];
    _chartsView.colorYaxisLabel = [UIColor clearColor];
    // Show the y axis values with this format string
//    _chartsView.formatStringForValues = @"%.1f";

    // Setup initial curve selection segment
    _chartsView.enableBezierCurve = NO;
    _chartsView.showLineG = NO;
    _chartsView.showValues = NO;
    _chartsView.closeDot_ViewColor = [UIColor colorWithHexString:@"#fb5cb9"];
//    _chartsView.colorXaxisLabel = [UIColor clearColor];
    [_bottomView addSubview:_chartsView];
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.values count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.values objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {

    if (index >= self.dates.count) {
        return @"";
    }
    return self.dates[index];
}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    if (_name && [_name isEqualToString:@"体重"]) {
//        return @" kg";
//    }
    return @"";
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    if (_values && _values.count>0) {
        self.fun_status.text = [NSString stringWithFormat:@"当前心率: %@",[self.values objectAtIndex:index]];
    }
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.fun_status.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.fun_status.text = [NSString stringWithFormat:@"平均心率: %i",[[self.chartsView calculatePointValueAverage] intValue]];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.fun_status.alpha = 1.0f;
            } completion:nil];
        }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    self.fun_status.text = [NSString stringWithFormat:@"平均心率: %i",[[self.chartsView calculatePointValueAverage] intValue]];


}
//- (CGGradientRef)CGGradientWithColors{
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat loacattions[2] = {0,1};
//    NSArray * colors = @[(__bridge id)[UIColor colorWithHexString:@"#01d772"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#0dd7B7"].CGColor];
//
//    CGGradientRef gradientRef =  CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, loacattions);
//
//    CGColorSpaceRelease(colorSpace);
//
//    //    CGGradientRelease(gradientRef);
//    
//    return gradientRef;
//}
- (void)setupheartCell{
    _imgBL = [[UIImageView alloc] init];
    _imgBL.image = [UIImage imageNamed:@"background"];
    [self addSubview:_imgBL];

    _backGroundView = [[UIView alloc] init];
    _backGroundView.layer.cornerRadius = 5;
    _backGroundView.layer.masksToBounds = YES;
    _backGroundView.layer.borderWidth = 1;
    _backGroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    _backGroundView.alpha = 0.9;
    [self addSubview:_backGroundView];


    _whiteView = [[UIView alloc] init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_backGroundView addSubview:_whiteView];

    _fun_img = [[UIImageView alloc] init];
    [_backGroundView addSubview:_fun_img];

    _fun_label = [[UILabel alloc] init];
    _fun_label.textAlignment = NSTextAlignmentCenter;
    _fun_label.font = [UIFont systemFontOfSize:16];
    [_backGroundView addSubview:_fun_label];

    _fun_status = [[UILabel alloc] init];
    _fun_status.textAlignment = NSTextAlignmentRight;
    _fun_status.font = [UIFont systemFontOfSize:14];
    _fun_status.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGroundView addSubview:_fun_status];

  [_backGroundView addSubview:self.bottomView];

}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
          [_backGroundView addSubview:self.bottomView];
        int j = 0;
        int h = 0;
        int L = 0;
        if (kDevice_Is_iPhone6Plus) {
            j = 22;
            h = 80;
            L = 17;
        }else if (kDevice_Is_iPhone5){
            j = 14;
            h = 49;
            L = 20;

        }else{
            j = 15;
            h = 60;
            L = 21;
        }
        for (int i =0; i<3; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, j*(i+1), self.cl_width-46, 0.5)];
            view.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
            [_bottomView addSubview:view];
        }


        for (int i = 0; i< L; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(j*(i+1), 0, 0.5, h)];
            view.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
            [_bottomView addSubview:view];
        }
    }

    return _bottomView;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_imgBL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(101);
    }];
    [_backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-6);
    }];

    [_whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_backGroundView);
        make.width.mas_equalTo(5);
    }];

    [_fun_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(15);
        make.top.equalTo(_backGroundView).offset(8);
        make.height.width.mas_equalTo(25);
    }];


    [_fun_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fun_img.mas_right).offset(10);
        make.centerY.equalTo(_fun_img);
    }];

    [_fun_status mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backGroundView).offset(-8);
        make.centerY.equalTo(_fun_img);
    }];
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fun_img);
        make.right.equalTo(_fun_status);
        make.bottom.equalTo(_backGroundView);
        if (kDevice_Is_iPhone5) {
            make.top.equalTo(_fun_label.mas_bottom).offset(3);
        }else{
            make.top.equalTo(_fun_label.mas_bottom).offset(17.5);
        }
        make.top.equalTo(_fun_label.mas_bottom).offset(17.5);
    }];
//    _chartsView.frame = CGRectMake(-42, 0, _bottomView.cl_width+42, _bottomView.cl_height);
    [_chartsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView);
        make.bottom.equalTo(_bottomView);
        make.top.right.equalTo(_bottomView);
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
