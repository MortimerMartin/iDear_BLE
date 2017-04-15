//
//  MyBle.h
//  MyBle
//
//  Created by  on 16/5/25.
//  Copyright © 2016年 杨赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "BleDefines.h"

typedef struct AutoHeart{
    int open;
    int startHour;
    int startMinute;
    int endHour;
    int endMinute;
    int week;
}autoHeart;

typedef struct INFO{
    int gender;
    int age;
    int heigth;
    int weight;
    int stride;
}info;

typedef struct ALARM{
    int phone;
    int message;
    int QQ;
    int WeiXin;
}MyAlarm;

typedef struct CLOCK{
    int number;
    int type;
    int hour;
    int minute;
    int week7;
    int week1;
    int week2;
    int week3;
    int week4;
    int week5;
    int week6;
}MyClock;

typedef struct DeviceTime {
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int second;
} MyDeviceTime;


typedef struct ACTIVITYALARM{
    int startHour;
    int startMinute;
    int endHour;
    int endMinute;
    int week;
    int intervalTime;
    int leastStep;
} MyActivityAlarm;


#pragma mark 蓝牙代理服务
@protocol MyBleDelegate
-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI;
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len;
-(void)Disconnected;
-(void)start;
-(void)SetCenter:(CBCentralManager*)center ble:(CBPeripheral*)myPeripheral;
@end


@interface MyBle : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate,CBPeripheralManagerDelegate>
{
     
}


@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic)CBPeripheralManager * manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;
@property(nonatomic,retain) NSMutableArray *_subscribedCentrals;
@property(nonatomic,retain) CBMutableCharacteristic* mycharacteristic;
@property (nonatomic,retain)id<MyBleDelegate>delegate;

@property BOOL  isDfuTarg;
@property (nonatomic,retain) NSString * strIdentifier;
+(MyBle *)sharedManager;
-(void)enableRead:(CBPeripheral*)p;
-(void)DisableRead:(CBPeripheral*)p;

-(void)CentralManagerSetUp;
-(void)PeripheralManagerSetUp;
-(void)findBLEPeripheralsWithRepeat:(BOOL)isRepeat;
-(BOOL)isScan;
-(void)connectPeripheral:(CBPeripheral *)peripheral;
-(void)disconnect:(CBPeripheral *)peripheral;
-(void)writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data;
-(void)readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p;

-(void)addMyService;


#pragma mark bluetoothApi

-(void)enable;
-(void)disable;
-(void)startGo;
-(void)stopGo;
/**
 * 设置个人信息 并 获取
 */
-(void)setInfo:(info)info;
-(void)getInfo;

-(void)setDeviceTime:(MyDeviceTime)time;
-(void)getDeviceTime;

-(void)getDetailDataWithDay:(int)day;
-(void)getTotalDataWithDay:(int)day;

-(void)startOTA;
/**
 * 获取手环版本号
 */
-(void)getVersion;

-(void)setTotalAlarm:(BOOL)open;
-(void)getTotalAlarm;

-(void)setDetailAlarm:(MyAlarm)alarm;
-(void)getDetailAlarm;

-(void)readClockWithType:(int)number;
-(void)setClock:(MyClock)clock;

-(void)setActivityAlarm:(MyActivityAlarm)activityAlarm;
-(void)getActivityAlarm;

-(void)reset;
-(void)Open;
/**
 * 获取手环mac地址
 */
-(void)GetMacAddress;
/**
 * 获取手环电量
 */
-(void)GetBatteryLevel;
/**
 * 重启手环
 */
-(void)MCUReset;
/**
 * 设置手环名字
 */
-(void)SetDeviceName:(NSString*)strName;
-(void)GetDeviceName;
/**
 * 获取手环单位  km or mile
 */
-(void)GetDistanceUnit;
/**
 * 获取手环时间模式  12 or 24
 */
-(void)GetTimeMode;
/**
 * 设置最大心率值
 */
-(void)SetMaxHeartRate:(int)maxHeartRate;
/**
 * 设置时间模式
 */
-(void)SetTimeChange12And24:(int)TimeType;
/**
 * 设置距离单位
 */
-(void)SetKmAndMile:(int)DistanceType;

-(void)DeledeHistoryDataWithDay:(int)day;
-(void)ReadHistoryGoalWithDay:(int)day;

-(void)SetBaseHeartRate:(int)BaseHeartRate;
-(void)GetBaseHeartRate;

-(void)SetAutoHeartZone:(autoHeart)MyAutoHeart;
-(void)GetAutoHeartZone;

-(void)StartHeartRateMode;
-(void)StopHeartRateMode;

-(void)ReadHistoryHeartRateWithNumber:(int)Number;
//设置目标步数  和  获取目标步数
-(void)SetGoal:(int)Goal;
-(void)GetGoal;


@end
