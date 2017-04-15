//
//  CHEditLastVC.h
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^selectChange)(NSString * select_fun, NSString * select_content);
typedef void(^selectPhoneorsms)(BOOL phone, BOOL sms);
@interface CHEditLastVC : BaseViewController
@property (nonatomic , copy) NSString * Edit_title;//设置名字
@property (nonatomic , copy) NSString * select_result;//根据选项 显示相应的结果
//二选一结果回调
@property (nonatomic , copy) selectChange  selectResult;
//uiswich结果回调
@property (nonatomic , copy) selectPhoneorsms selectPSResult;

@property (nonatomic , assign) BOOL phone_notification;
@property (nonatomic , assign) BOOL sms_notification;

@end
