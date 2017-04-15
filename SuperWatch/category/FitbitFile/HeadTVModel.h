//
//  HeadTVModel.h
//  SuperWatch
//
//  Created by Mortimer on 17/4/7.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BQLDBModel.h"

@interface HeadTVModel : BQLDBModel

@property (nonatomic) NSInteger timeid;  //日期
@property (nonatomic) NSInteger AveageheadValue; //平均数
@property (nonatomic) NSInteger MaxheadValue;  //最大值
@property (nonatomic) NSInteger  MinheadValue; //最小值

@end
