//
//  CHEditLastTVCell.h
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHEditLastTVCell : UITableViewCell
@property (nonatomic , copy) NSString * title;
@property (nonatomic , assign) int showRight_fun;
//@property (nonatomic , copy) NSString * time_title;
@property (nonatomic , assign) BOOL isTwo;
@property (nonatomic , strong) UISwitch * first_switch;
@end
