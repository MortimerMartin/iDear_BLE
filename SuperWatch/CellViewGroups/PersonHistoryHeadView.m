
//
//  PersonHistoryHeadView.m
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonHistoryHeadView.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "BEMSimpleLineGraphView.h"
#import "Masonry.h"
@interface PersonHistoryHeadView ()<BEMSimpleLineGraphDelegate , BEMSimpleLineGraphDataSource>


@property (nonatomic , strong) UILabel * contentLabel;
@property (nonatomic , strong) UILabel * nameLabel;
@property (nonatomic , strong) UIScrollView * scrollView;
@property (nonatomic , strong) BEMSimpleLineGraphView * chartsView;

@end
@implementation PersonHistoryHeadView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setupPersonHistoryHeadView];
    }
    return self;
}

- (void)setupPersonHistoryHeadView{
    _backGroundView = [[UIView alloc] init];
    _backGroundView.layer.cornerRadius = 5;
    _backGroundView.layer.masksToBounds = YES;
    _backGroundView.layer.borderColor = [UIColor colorWithHexString:@"#9aa9a9"].CGColor;
    _backGroundView.layer.borderWidth = 0.5;
    [self addSubview:_backGroundView];

    _scrollView = [[UIScrollView  alloc] init];
    _scrollView.contentSize = CGSizeMake(self.cl_width  * 2, self.cl_height - 24);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_backGroundView addSubview:_scrollView];

    _chartsView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, self.cl_height - 24)];
    //WithFrame:CGRectMake(-60, 0, _scrollView.contentSize.width + 40, self.cl_height - 24)
    _chartsView.delegate = self;
    _chartsView.dataSource = self;
  _chartsView.backgroundColor = [UIColor whiteColor];


    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat loacattions[2] = {0,1};
    NSArray * colors = @[(__bridge id)[UIColor colorWithHexString:@"#01d772"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#0dd7B7"].CGColor];

    CGGradientRef gradientRef =  CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, loacattions);

    CGColorSpaceRelease(colorSpace);


//    CGGradientRef gradientRef = [self CGGradientWithColors];

    _chartsView.gradientBottom = gradientRef;
    CGGradientRelease(gradientRef);



    _chartsView.colorTop = [UIColor whiteColor];
    _chartsView.colorTouchInputLine = [UIColor whiteColor];
    _chartsView.colorLine = [UIColor whiteColor];
    _chartsView.colorBottom =  [UIColor colorWithHexString:@"#0dd7b7"];

    _chartsView.colorXaxisLabel = [UIColor whiteColor];
    _chartsView.labelFont = [UIFont systemFontOfSize:12];

    _chartsView.colorBackgroundPopUplabel = [UIColor clearColor];

    _chartsView.enableTouchReport = YES;
    _chartsView.enablePopUpReport = YES;
    _chartsView.enableYAxisLabel = YES;
    _chartsView.autoScaleYAxis = YES;

    self.chartsView.alwaysDisplayDots = NO;
//    self.chartsView.alwaysDisplayPopUpLabels = YES;
    //    self.myGraph.enableReferenceXAxisLines = YES;
    _chartsView.enableReferenceYAxisLines = YES;
    //    self.myGraph.colorYaxisLabel = (__bridge UIColor * _Nonnull)([UIColor whiteColor].CGColor);
    _chartsView.enableReferenceAxisFrame = YES;
    _chartsView.animationGraphStyle = BEMLineAnimationDraw;
    // Dash the y reference lines
    _chartsView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];

    // Show the y axis values with this format string
    _chartsView.formatStringForValues = @"%.1f";

    // Setup initial curve selection segment
    _chartsView.enableBezierCurve = YES;


    [_scrollView addSubview:_chartsView];

    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:24];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#0fc2af"];
    [self addSubview:_contentLabel];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self addSubview:_nameLabel];


}

- (void)setSetOffX:(int)setOffX{
    _setOffX = setOffX;
    if (setOffX == 1) {
    _chartsView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width +42, self.cl_height - 24)];
    }
}

-(void)setColor:(UIColor *)color{
    _color = color;
  _chartsView.colorBottom =  color;
    if (color) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat loacattions[2] = {0,1};
        NSArray * colors = @[(__bridge id)color.CGColor];

        CGGradientRef gradientRef =  CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, loacattions);

        CGColorSpaceRelease(colorSpace);
        _chartsView.gradientBottom = gradientRef;
    }
}
- (void)setName:(NSString *)name{
    _name = name;
    _nameLabel.text = name;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = content;
}

- (void)refreshView{

    
  
    [self.chartsView reloadGraph];
}
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph{
    return 0;
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

//    NSString *label = [self labelForDateAtIndex:index];
//    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];



    if (index >= self.dates.count) {
        return @"";
    }
    return self.dates[index];
}

//- (NSString *)labelForDateAtIndex:(NSInteger)index {
//    NSDate *date = self.dates[index];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"MM月dd日";
//    NSString *label = [df stringFromDate:date];
//    return label;
//}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self labelForDateAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    //    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //        self.labelValues.alpha = 0.0;
    //        self.labelDates.alpha = 0.0;
    //    } completion:^(BOOL finished) {
    //        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    //        self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
    //
    //        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //            self.labelValues.alpha = 1.0;
    //            self.labelDates.alpha = 1.0;
    //        } completion:nil];
    //    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    //    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    //    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    if (_name && [_name isEqualToString:@"体重"]) {
        return @" kg";
    }
    return @"";
}

//
//- (CGGradientRef)CGGradientWithColors{
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat loacattions[2] = {0,1};
//    NSArray * colors = @[(__bridge id)[UIColor colorWithHexString:@"#01d772"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#0dd7B7"].CGColor];
//
//    CGGradientRef gradientRef =  CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, loacattions);
//
//    CGColorSpaceRelease(colorSpace);
//
////    CGGradientRelease(gradientRef);
//
//    return gradientRef;
//}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {

        if (_setOffX ==1) {
            make.left.equalTo(self).offset(12);
            make.top.equalTo(self);
            make.bottom.right.equalTo(self).offset(-12);
        }else{
            make.left.top.equalTo(self).offset(12);
            make.bottom.right.equalTo(self).offset(-12);
        }

    }];


    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_backGroundView);
    }];

//    [_chartsView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_scrollView).offset(-20);
//        make.bottom.top.equalTo(_scrollView);
//        make.right.equalTo(_scrollView).offset(self.cl_width);
//    }];

    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backGroundView).offset(-11.5);
        make.top.equalTo(_backGroundView).offset(10);
    }];

    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
    }];
}

@end
