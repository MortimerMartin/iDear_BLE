//
//  SetocCell.h
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetocCell : UITableViewCell
@property (nonatomic , copy) NSString * set_name;
@property (nonatomic , assign) int lineHidden;
@property (nonatomic , strong) UISwitch * setOpenBtn;
@end
