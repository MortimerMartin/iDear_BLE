//
//  HomePersonCell.h
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^reportBlock)(void);
//typedef void(^deleteBlock)(void);

@interface HomePersonCell : UITableViewCell

@property (nonatomic , copy) NSString * headURL;
@property (nonatomic , copy) NSString * family_name;
@property (nonatomic , copy) NSString * family_sex;
@property (nonatomic , copy) NSString * family_age;

@property (nonatomic , assign) BOOL isHidentView;

@property (nonatomic , assign) BOOL isMe;

//@property (nonatomic , copy) reportBlock report_block;
//@property (nonatomic , copy) deleteBlock delete_block;
//@property (nonatomic , copy) deleteBlock edit_block;
@property (nonatomic , strong) UIButton * reportBtn;

//@property (nonatomic , strong) UIImageView * isEdit;

@property (nonatomic , strong) UIButton * deletBtn;
@property (nonatomic , strong) UIButton * editBtn;
@end
