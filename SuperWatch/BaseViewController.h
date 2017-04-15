//
//  BaseViewController.h
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


- (NSString *)getCurrentDay;

- (NSString *)getSevenDaysMessage;

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;



/**
 比较两个日期相差多少天

 @param date 开始日期
 @param endDate 结束日期
 @return 相差天数
 */
-(int)dateStartTime:(NSDate *)date endTime:(NSDate *)endDate;

/**
 比较两个日期相差多长时间

 @param startDate 开始时间
 @param endDate 结束时间
 @return 目前是以 1 和 －1 判断是否大于30天 （可以比较出相差多少分，多少秒，多少天）
 */
-(int)compareStareDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
@end
