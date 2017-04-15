//
//  UserNameView.h
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JVFloatLabeledTextField;

typedef void(^isNameBlock)(void);
@interface UserNameView : UIView
//头像
@property (nonatomic , strong) UIImageView * headView;

@property (nonatomic , strong) JVFloatLabeledTextField * Account;

@property (nonatomic , strong) UIButton * nextBtn;

@property (nonatomic , strong) UILabel * headTitle;

@property (nonatomic , copy) isNameBlock isName;
//@property (nonatomic , copy) isNameBlock  isMove;

@end
