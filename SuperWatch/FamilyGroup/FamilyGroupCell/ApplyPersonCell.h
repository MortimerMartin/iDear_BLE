//
//  ApplyPersonCell.h
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyPersonCell : UITableViewCell
@property (nonatomic , strong ) NSString * isAgree;
@property (nonatomic , strong) UIButton * agreeBtn;
@property (nonatomic , strong) UIButton * disagreenBtn;

@property (nonatomic , copy) NSString * headURL;
@property (nonatomic , copy) NSString * applyname;
@property (nonatomic , copy) NSString * applydescript;



@end
