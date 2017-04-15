//
//  SMSleepCell.h
//  SuperWatch
//
//  Created by pro on 17/3/6.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSleepCell : UITableViewCell
@property (nonatomic , copy) NSString * time;
@property (nonatomic , copy) NSString * status;
@property (nonatomic , assign) BOOL lastrow;

@end
