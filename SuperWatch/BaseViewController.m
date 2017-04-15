//
//  BaseViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BaseViewController.h"
//#import "UIView+MJExtension.h"
//#import "UIColor+HexString.h"
//#import "UIImage+ZYImage.h"
//#import "Masonry.h"
//#import "NSDate+Extension.h"
@interface BaseViewController ()
//{
//    UIView * shadeView;
//    UIView * centerView;
//}
//
//@property (nonatomic , strong)UIDatePicker * pickView;;
//@property (nonatomic , strong) UIButton * okBtn;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        NSLog(@"Date1 is in the past");
        return -1;
    }
    NSLog(@"Both dates are the same");
    return 0;

}

/**
 * 开始到结束的时间差
 */


-(int)dateStartTime:(NSDate *)date endTime:(NSDate *)endDate{

    NSTimeInterval time = [endDate timeIntervalSinceDate:date];
    int day = (int)time / (24 * 3600);
    return day;
}

+ (int)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{



    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;

//    int second = (int)value %60;//秒
//    int minute = (int)value /60%60;
//    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);

    return day;
}


- (NSString *)getSevenDaysMessage{
    NSTimeInterval oneDay = 24 * 60 * 60 * 1;
    NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:seven];

}

- (NSString *)getCurrentDay{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(int)compareStareDate:(NSDate *)startDate EndDate:(NSDate *)endDate{

//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 如果是真机调试，转换这种欧美时间，需要设置locale
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
//    NSDate *createDate = [fmt dateFromString:_created_at];

    //日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //想获取的差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay;
    //计算连个日期的差值
    NSDateComponents * cmps = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    //获取某个时间的年月日
    NSDateComponents * startCmps = [calendar components:unit fromDate:startDate];
    NSDateComponents * endCmps = [calendar components:unit fromDate:endDate];

    if (startCmps.year == endCmps.year) { //一样
        if (cmps.day<=30) {
//            if (cmps.day == 1) {//昨天
//                fmt.dateFormat = @"昨天 HH:mm";
//                return [fmt stringFromDate:createDate];
//                return 1;
//            }else if (cmps.day == 0){//今天
//                return 1;
//                if (cmps.hour > 1) {//一小时前
////                    return [NSString stringWithFormat:@"%d小时前", cmps.hour];
//                    return 1;
//                }else if (cmps.minute >= 1){//几分钟前
////                    return [NSString stringWithFormat:@"%d分钟前", cmps.minute];
//                    return 1;
//                }else{//刚刚
//                    return @"刚刚";
//                    return 1;
//                }
//
//            }else{ // 今年的其他日子
//                fmt.dateFormat = @"MM-dd HH:mm";
//                return [fmt stringFromDate:createDate];
//            }
            return 1;

        }else{
            return -1;
        }

    }else{// 非今年

        return -1;
    }
    //错误
    return -1;

}

//- (void)addPickDateView{
//
//    shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 107, self.view.mj_w, self.view.mj_h - 107)];
//    shadeView.backgroundColor = RGBA(0, 0, 0, 0.6);
//
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadeView)];
//    [shadeView addGestureRecognizer:tap];
//    [self.view addSubview:shadeView];
//    //    [self bringSubviewToFront:shadeView];
//
//    centerView = [[UIView alloc] init];
//    centerView.layer.cornerRadius = 5;
//    centerView.layer.masksToBounds = YES;
//    centerView.backgroundColor = [UIColor whiteColor];
//    [shadeView addSubview:centerView];
//
//
//    _pickView =  [[UIDatePicker alloc] init];
//
//    _pickView.datePickerMode = UIDatePickerModeDate;
//    [_pickView setMaximumDate:[NSDate date]];
//
//
//
//    [_pickView setMinimumDate:[NSDate date:@"1990-1-1" WithFormat:@"yyyy-MM-dd"]];
//    [centerView addSubview:_pickView];
//
//    _okBtn = [[UIButton alloc] init];
//    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
//    //    _okBtn.backgroundColor = [UIColor redColor];
//    [_okBtn setTitleColor:[UIColor colorWithHexString:@"0fc2af"] forState:UIControlStateNormal];
//    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [_okBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [_okBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
//    _okBtn.layer.cornerRadius = 3;
//    _okBtn.layer.masksToBounds = YES;
//    _okBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
//    _okBtn.layer.borderWidth = 1;
//    [centerView addSubview:_okBtn];
//
//
//
//    [_okBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//
////    UIView *  Line = [[UIView alloc] init];
////    Line.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
////    [centerView addSubview:Line];
//
//    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(shadeView).offset(11);
//        make.right.equalTo(shadeView).offset(-11);
//        make.bottom.equalTo(shadeView).offset(-11);
//        make.height.mas_equalTo(300);
//    }];
//
////    [Line mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.left.right.equalTo(centerView);
////        make.bottom.equalTo(_pickView.mas_top);
////        make.height.mas_equalTo(0.5);
////    }];
//    [_pickView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_okBtn.mas_top);
//        make.top.left.right.equalTo(centerView);
//    }];
//
//    [_okBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(centerView);
//        make.height.mas_equalTo(30);
//
//    }];
//
//
//}
//
//- (NSString *)timeFormat
//{
//    NSDate *selected = [self.pickView date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
//    return currentOlderOneDateStr;
//}
//
//- (void)chooseDate:(UIButton *)sender{
//
//
//
//    NSString * dateBlock = [self timeFormat];
//
//
//
//    //    if (_isDateBlock) {
//    //        _isDateBlock(dateBlock);
//    //    }
//    
//    [self removeShadeView];
//    
//    //    shadeView.hidden = YES;
//}


//- (void)removeShadeView{
//    [UIView animateWithDuration:1 animations:^{
//        shadeView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [shadeView removeFromSuperview];
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
