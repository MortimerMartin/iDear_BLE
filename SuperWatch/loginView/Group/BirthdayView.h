//
//  BirthdayView.h
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JVFloatLabeledTextField;

typedef void(^isBithDayBlock)(void);
typedef void(^isChooseDateBlock)(NSString * date);
@interface BirthdayView : UIView

@property (nonatomic , strong) JVFloatLabeledTextField * birthDayField;

@property (nonatomic , copy) isBithDayBlock  isBackBlock;

@property (nonatomic , copy) isBithDayBlock  isNextBlock;

//日期传参数
@property (nonatomic , copy) isChooseDateBlock isDateBlock;

@end
