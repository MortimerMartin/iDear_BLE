//
//  WristVC.h
//  SuperWatch
//
//  Created by pro on 17/3/3.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^reloadBleData)(NSArray *  data);
@interface WristVC : BaseViewController
@property (nonatomic , copy) reloadBleData Wrist_block;


@property (nonatomic , assign) int current_step_Y;
@property (nonatomic , assign) int finish_step_E;
@property (nonatomic , assign) float progress_L;
@property (nonatomic , copy) NSString * connect_O;
@property (nonatomic , assign) float power_V;

@end
