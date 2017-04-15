//
//  PersonInfoCell.h
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoCell : UITableViewCell

@property (nonatomic , copy) NSString * info_name;
@property (nonatomic , copy) NSString * info;
@property (nonatomic , copy) NSString * info_img;
/**
 *
 *             ________
 *         ____\_\_\_\_\
 *       |   __________===== o o o o  [显示上面的线]
 *       |__/   /c_/
 *
 */
@property (nonatomic , assign) BOOL showTopLine;

@end
