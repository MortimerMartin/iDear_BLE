//
//  BleDefines.h
//  Created by Tony on 10/22/2012.
//  Copyright (c) 2012 Jess Tech. All rights reserved.
//
#ifndef BleDefines_h
#define BleDefines_h



//Service
#define ISSC_SERVICE_UUID                          0xfff0
//接收
#define ISSC_CHAR_RX_UUID                          0xfff7
//发送
#define ISSC_CHAR_TX_UUID                          0xfff6

#define CMD_SET_TIME               0x01      //设置时间


#define CMD_GET_TIME               0x41     //获得时间


#define CMD_GET_NOW_DATA           0x48     //获得现在的内存数据


#define CMD_SET_USER_PARAMETER     0x02     //设置用户信息

#define CMD_GET_USER_PARAMETER     0x42     //获得用户信息


#define CMD_BEGIN_SEND_STEP        0x09      //开始实时计步


#define CMD_END_SEND_STEP          0x0A      //关闭实时计步


#define CMD_GET_TOTAL_DATA         0x07      //获得总数据


#define CMD_GET_DETAIL_DATA        0x43     //获得详细数据


#define CMD_GET_GOAL_DATA          0x08     //获得每天目标达成率


#define CMD_SET_ALARM              0x23     //设置闹钟


#define CMD_GET_ALARM              0x24     //获得闹钟


#define CMD_SET_ACTIVE_ALARM       0x25     //设置运动闹钟

#define CMD_GET_ACTIVE_ALARM       0x26     //获得运动闹钟

#define CMD_SET_GOAL               0x0B     //设置目标
#define CMD_GET_GOAL               0x4B     //获取目标


#define CMD_BEGIN_OTA              0x47      //进入升级状态

#define CMD_SET_DISTANCE_UNIT      0x0F      //设置距离单位


#define CMD_GET_DISTANCE_UNIT      0x4F      //获得距离单位

#define CMD_SET_TIME_MODE          0x37      //设置时间模式


#define CMD_GET_TIME_MODE          0x38      //获得时间模式


#define CMD_DEL_DATA               0x04      //删除数据


#define CMD_GET_VERSION            0x27      //获得版本号


#define CMD_SET_POWER_DOWN_MODE    0X12      //休眠

#define CMD_STEP_OR_SLEEP          0X36      //进入步数或睡眠模式
#define CMD_STEP_OR_SLEEP_ERROR    0x92

#define CMD_SET_DEV_ID             0X05      //设置设备ID
#define CMD_SET_DEV_ID_ERROR       0x85

#define CMD_GET_POWER              0X13      //获得电量

#define CMD_GET_MAC                0X22      //获得MAC地址


#define CMD_MCU_RESET             0x2E      //重新启动


#define CMD_CALL_MSG               0X4D      //来电和信息
#define CMD_CALL_MSG_ERROR         0xcd

#define CMD_GET_DATA_MAP           0x46      //获得30天数据分布
#define CMD_GET_DATA_MAP_ERROR     0xc6




#define CMD_GET_AutoHeartRateZone  0x2b  //获取自动开启心率的区间
#define CMD_SET_AutoHeartRateZone  0x2a  //设置自动开启心率的区间


#define CMD_GET_BaseHeartRate  0x6d  //获取基础心率值
#define CMD_SET_BaseHeartRate  0x6c  //设置基础心率值

#define CMD_HEARTRATE_MODE  0x19  //开启或者关闭实时心率
#define CMD_GET_HISTORY_HEARTRATE  0x2F  //获取历史心率数据

#define CMD_GET_MaxHeartRate  0x69  //获取最大心率值
#define CMD_SET_MaxHeartRate  0x68  //设置最大心率值


#define CMD_SET_USER_NAME          0x3D     //设置用户名
#define CMD_GET_USER_NAME          0x3E     //设置用户名


#define CMD_SET_ANCS_TOTAL 0X58 //设置ANSC总开关状态
#define CMD_GET_ANCS_TOTAL 0x59  //获取ANSC总开关状态

#define CMD_SET_ANCS_DETAIL 0X10 //设置ANSC分开关状态
#define CMD_GET_ANCS_DETAIL 0x11  //获取ANSC分开关状态






#endif












