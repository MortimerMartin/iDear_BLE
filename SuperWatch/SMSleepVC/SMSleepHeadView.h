//
//  SMSleepHeadView.h
//  SuperWatch
//
//  Created by pro on 17/3/6.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBPieChart.h"

//typedef void(^releaseChart)(void);
@interface SMSleepHeadView : UIView

@property (nonatomic , copy) NSString * qianTime;
@property (nonatomic , copy) NSString * shenTime;
@property (nonatomic , copy) NSString * allTime;
@property (nonatomic , retain) NSArray * biliArray;
@property (nonatomic , strong) VBPieChart *chart;

//@property (nonatomic , copy) releaseChart release_chart;
-(void)releaseobserve;

/**
 刷新VBPieChart

 @param deep 深度睡眠
 @param light 浅度睡眠
 */
-(void)reloadVBPieChart:(int )deep lightSleep:(int)light;

/**
 刷新头视图浅度睡眠时间

 @param hour 小时
 @param min 分钟
 */
-(void)reloadLgihtSMSleep:(int)hour LightMin:(int)min;

/**
 刷新头视图深度睡眠时间

 @param hour 小时
 @param min 分钟
 */
-(void)reloadDeepSMSleep:(int)hour DeepMin:(int)min;

/**
 刷新头视图总时间

 @param alltime 总时间
 */
-(void)reloadSMSleepTime:(int)alltime;
@end
