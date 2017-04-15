//
//  DeviceListView.h
//  SuperWatch
//
//  Created by pro on 17/2/13.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol SelectBLEDelegate <NSObject>

- (void)didSelectRow:(NSInteger)index;// 学习协议 代理

@end
@interface DeviceListView : UIView

/**
 *            ^   刷新设备列表
 *          、~~,
 *       ___／  \___
 *      /ooo ooo ooo\
 *      |nn nn nn nn|
 *     C|WW WWWWW WW|D
 *      |!!! !!! !!!|
 *      \ xxx x xxx /
 *       \_qq_v_pp_/             */
- (void)reloadDeviceListView:(NSMutableArray *)list WithPeripheral:(NSMutableArray *)status;
/**
 *  设备列表代理
 *
 */
@property (nonatomic , assign) id<SelectBLEDelegate> delegate; // 代理属性

@end
