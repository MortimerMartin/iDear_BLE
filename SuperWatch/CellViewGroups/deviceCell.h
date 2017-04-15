//
//  deviceCell.h
//  SuperWatch
//
//  Created by pro on 17/2/13.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface deviceCell : UITableViewCell

@property (nonatomic , copy) NSString * device_name;

@property (nonatomic , copy) NSString * device_time;
/**
 * 选中设备
 */
@property (nonatomic , assign) BOOL selectD;

@end
