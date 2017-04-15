//
//  DeleteHistoryCell.h
//  SuperWatch
//
//  Created by Mortimer on 17/3/24.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteHistoryCell : UITableViewCell

@property (nonatomic , strong) UIButton * deleteBtn;

@property (nonatomic , assign) BOOL isEdit;
@property (nonatomic , copy) NSString * left_time;
@property (nonatomic , copy) NSString * right_content;

@end
