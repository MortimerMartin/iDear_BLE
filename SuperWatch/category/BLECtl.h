//
//  BLECtl.h
//  BLECtl
//
//  Created by hubin on 2014-4-25.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


// 项目中必须导入基库 <CoreBluetooth/CoreBluetooth.h>

@protocol BLECtlDelegate <NSObject>

@optional
- (void)bleCtlDidBeginConnect:(CBPeripheral *)aPeripheral;            // 开始连接时（start Connecting）
- (void)bleCtlDidDisconnectPeripheral:(CBPeripheral *)aPeripheral;    // 断开连接时 （Disconnecting）
- (void)bleCtlDidConnectPeripheral:(CBPeripheral *)aPeripheral MacData:(NSData *)mac; // 连接成功时（Connected）
- (void)bleCtlDidFailToConnectPeripheral:(CBPeripheral *)aPeripheral; // 连接失败时（fail to connect）

- (void)bleCtlDidReceivedData:(NSDictionary *)receiveDic;//接收到的数据 （receive dictionary）

@end


@interface BLECtl : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (assign, nonatomic) id <BLECtlDelegate> delegate;        // 代理（Delegate）
@property (retain, nonatomic) CBCentralManager *manager;           // 中心管理者（CentralManager）
@property (strong, nonatomic) CBPeripheral     *currentPeripheral; // 当前连接着的设备（Connected Devices）
@property (strong, nonatomic) NSData *MacData;                     // 设备的MAC地址（MAC Address of the Device）
@property (strong, nonatomic) NSString *SendDataToBlueString;//需要发送给称的人体参数
// SendDataToBlueString 的格式规定在通信协议中有相关说明，在此只给示例: NSString *test = @"FE030100AA1901B0";
// 1 FE 包头
// 2 03 组号
// 3 01 男  00 女
// 4 00 运动员级别  0 普通  1 业余   2 专业
// 5 AA 身高
// 6 19 年龄
// 7 01 单位   01 千克  02 lb(英石)  03 ST:LB(英磅)
// 8 异或校检和
//  最后一位B0: bytes[7] = bytes[1]^bytes[2]^bytes[3]^bytes[4]^bytes[5]^bytes[6];

// SendDataToBlueString, refers to Bluetooth Communication Protocol, example is: NSString *test = @"FE030100AA1901B0";
// 1 FE First Byte
// 2 03 User Group
// 3 01 Male  00 Famele
// 4 00 Athlete Level  0 Common  1 Amateur   2 Professional
// 5 AA Height
// 6 19 Age
// 7 01 Unit   01 kg  02 lb(st)  03 ST:LB(lb)
// 8 CheckorSum
//  Last Byte B0: bytes[7] = bytes[1]^bytes[2]^bytes[3]^bytes[4]^bytes[5]^bytes[6];
+ (BLECtl *)instance;      // 实例化（Instantiation）
- (void)setCentralManager; // 在实例化之后必须执行此方法以激活 系统的中心管理者（Activate CentralManager after Instantiation-）

- (void)scan; // 调用此方法时将开始搜索（Start Scanning when using this command）
- (void)stop; // 调用此方法时将停止搜索（Stop Scanning when using this command）

@end
