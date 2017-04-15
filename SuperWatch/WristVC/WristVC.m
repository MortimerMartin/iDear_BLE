//
//  WristVC.m
//  SuperWatch
//
//  Created by pro on 17/3/3.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "WristVC.h"
#import "MJRefresh.h"

#import "UIColor+HexString.h"
#import "WristHeadView.h"
#import "UserCenter.h"
#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "WristCellHeadView.h"
#import "ChartsCellHeadView.h"
#import "SetocVC.h"

#import "YSXViewController.h"

#import "MyPlayVC.h"

#import "XLHeadVController.h"

#import "SMSleepVController.h"
#import "WritShadeView.h"
#import "SearchAnimationView.h"
#import "DeviceListView.h"
#import "UINavigationController+ShowNotification.h"
#import "MyBle.h"
@interface WristVC ()<MyBleDelegate,UITableViewDelegate ,UITableViewDataSource,SelectBLEDelegate,SearchBLEDelegate>
{
    float progress;  //进度
    float element_S; //电量
    NSString * connect_S; //设备连接状态；
    int current_Step; //当前步数
    int mubiao_Step; // 目标步数；
    int goal_step;

    int sleep_alltime; //昨天睡眠时长;
    int sleep_Deep; //深度睡眠;
    int sleep_Light; //浅度睡眠;

    int  head_seven; //心跳;
    NSUInteger  head_num_five;

    NSString * Calories; //卡洛里

    NSString * distanceK; //步行距离
    NSString * distanceTime; //sport时间

    int Unit; //单位  0 表示公制  1表示英制
    int Blestatus; //手环状态

    int SleepQuality_top; // 睡眠数据
    int SleepQuality_bottom;
    int SleepQuality_status;

    BOOL isStart;
    BOOL noFindBle;

    BOOL bleinfoisSuccess;//数据同步状态
    NSMutableArray * arrayPeripheral;
    NSMutableArray * arrayPeripheralStatus;
//    NSMutableArray * headArrayFive;
//    NSMutableArray * headArray_five;
}
@property (nonatomic , strong) NSMutableArray * headArrayFive;


@property (nonatomic , strong) NSMutableArray * wristArray; // 列表内容
@property (nonatomic , strong) NSArray * funArray; // 列表功能
@property (nonatomic , strong) UIImageView * titleImg; //头像
@property (nonatomic , strong) UILabel * titleName; //名字
/**
 *       ____          |~~~j
 *     _/  |l_\___     |~~~~j
 *    /__x____x__\     |
 *       0    0        |老司机带你上路
 */
@property (nonatomic , strong)UITableView * tableView;
/** /  LOVE  LIFE
 * 列表section视图
 */
@property (nonatomic , strong) WristHeadView * headView;
@property (nonatomic , strong) WristCellHeadView * CellHead;
@property (nonatomic , strong) WristCellHeadView * CellHead1;
@property (nonatomic , strong) ChartsCellHeadView * CellChartsHead;

/**
 * 数据同步动画
 */
@property (nonatomic , strong) WritShadeView * shadeView;
/**
 * 搜索设备
 */
@property (nonatomic , strong) SearchAnimationView * searchLD;
/**
 * 找到设备
 */
@property (nonatomic , strong) DeviceListView * Dlist;
@property (nonatomic , assign) int searchTime_save;
@property(nonatomic) CGAffineTransform Selftransform;
@end

@implementation WristVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyBle  sharedManager].delegate = self;

    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [_searchLD pauserTimer];
        _searchLD.hidden = YES;

        [_shadeView pauserTimeAndHidden];
        //获取单位
        [self ReadBitUnit];
        //获取电量
        [[MyBle sharedManager] GetBatteryLevel];

//        [[MyBle sharedManager] ReadHistoryGoalWithDay:0];
        //开始记步或停止
//        if (isStart) {
//            isStart = NO;
//            [[MyBle sharedManager] stopGo];
            [[MyBle sharedManager] startGo];

        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"startHeartRateMode"]) {

            [[MyBle sharedManager] StartHeartRateMode];
        }



        [[MyBle sharedManager] GetGoal];
        sleep_alltime = 0;
        sleep_Deep = 0;
        sleep_Light = 0;
        [[MyBle sharedManager] getDetailDataWithDay:1];
//        [[MyBle sharedManager] getDetailDataWithDay:1];
//        [[MyBle sharedManager] ReadHistoryHeartRateWithNumber:0];
        connect_S = @"已连接";
        _headView.connect_status = connect_S;
    }else{
        //检查是否有蓝牙被系统蓝牙连上
        NSArray * bleArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0xfff0"]]];
        if (bleArray.count > 0) {
            
            [_searchLD pauserTimer];
            [_searchLD removeFromSuperview];

            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MybleConnect"] == YES) {

                [self performSelector:@selector(connectMyble) withObject:nil afterDelay:2];
            }


        }else{
            [self ScanPeriPheral];
            connect_S = @"未连接";
            _headView.connect_status = connect_S;
        }

    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if ([MyBle sharedManager].activePeripheral.state == 2) {
//        [[MyBle sharedManager] stopGo];
//    }


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    arrayPeripheral = [NSMutableArray array];
    arrayPeripheralStatus = [NSMutableArray array];
    if ([MyBle sharedManager].activePeripheral.state !=2) {
        [[MyBle sharedManager] CentralManagerSetUp];
    }


    [self setupNavigation];

    [self setupTableView];

//    [self setupWritShadeView];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]) {
        [self reloadDlistView];

        [self searchDlistMethod];

        
            dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
            dispatch_after(delayTime1, dispatch_get_main_queue(), ^{

                [_searchLD pauserTimer];
                [_searchLD removeFromSuperview];
                [_Dlist removeFromSuperview];
                
            });
    }else{

        [_searchLD pauserTimer];
        [_searchLD removeFromSuperview];
        [_Dlist removeFromSuperview];

        bleinfoisSuccess = NO;

        [self setupWritShadeView];

        dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));

        dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
            if (bleinfoisSuccess == YES) {
                if (_shadeView.hidden == NO) {
                    [_shadeView pauseWritTimer:@"数据同步完成"];
                }else{

                    [_shadeView pauseWritTimer:@"数据同步完成"];
                }
            }else{
                [_shadeView pauseWritTimer:@"数据同步超时"];

            }




        });
    }

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];



    progress = 0.0;
    element_S = 0;
    current_Step = 0;
    mubiao_Step =10000;
    connect_S = @"未连接";
    head_seven = 0;
    head_num_five = 0;
    sleep_alltime = 0;
    sleep_Deep = 0;
    sleep_Light = 0;

    if (_current_step_Y && _current_step_Y != 0) {
        current_Step = _current_step_Y;
    }
    if (_finish_step_E && _finish_step_E != 0) {
        mubiao_Step = _finish_step_E;
    }
    if (_power_V && _power_V != 0.0) {
        element_S = _power_V;
    }

    if ([_connect_O isEqualToString:@"已连接"]) {
        connect_S = @"已连接";
    }
    if (_progress_L && _progress_L != 0.0) {
        progress = _progress_L;
    }

    //扫描设备

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    // Do any additional setup after loading the view.
}

-(void)becomeActive:(NSNotification *)notification{

    if (_searchLD.hidden == NO) {
        NSString *savedTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"time"];
        NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];

        int timeD = ([time intValue] - [savedTime intValue]) + _searchTime_save;

        if (timeD > 0 && timeD<60) {

            _searchLD.Seachtransform = _Selftransform;
            [_searchLD startTimer];
            _searchLD.timeP = timeD;

        }else{
            [_searchLD pauserTimer];
            [_searchLD removeFromSuperview];
            [_Dlist removeFromSuperview];
        }

        
    }

}
-(void)enterBackground:(NSNotification *)notification{
    [_searchLD pauserTimer];

    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"time"];

    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
/**
 * 同步数据
 */
- (void)setupWritShadeView{
    _shadeView = [[WritShadeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_shadeView];
    [_shadeView startWritTimer];
}

/**
 * 搜索设备
 */
-(void)searchDlistMethod{
    [_searchLD removeFromSuperview];
    _searchLD = [[SearchAnimationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:_searchLD];
    _searchLD.delegate = self;

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_searchLD];
//    [_searchLD startTimer];
}
#pragma mark                    SearchMyBle
-(void)nofind_MyBle{

    [[MyBle sharedManager].CM stopScan];
    [self.navigationController showNotificationWithString:@"未找到设备"];
    connect_S = @"未连接";
    _headView.connect_status = connect_S;
    [_searchLD removeFromSuperview];
    [_Dlist removeFromSuperview];

}
-(void)SearchBleTime:(int)time WithTransform:(CGAffineTransform)transform{
    _searchTime_save = time;
    NSLog(@"%d",time);

    _Selftransform = transform;
}
/**
 * 刷新设备列表
 */
-(void)reloadDlistView{

    [_Dlist removeFromSuperview];


    _Dlist = [[DeviceListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _Dlist.delegate = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:_Dlist];
//    [self.view addSubview:_Dlist];
}
#pragma mark                    SelectDlist

-(void)didSelectRow:(NSInteger)index{

    Blestatus = 1;
    //停止扫描
    [[MyBle sharedManager].CM stopScan];
    //连接设备
    [[MyBle sharedManager] connectPeripheral:[arrayPeripheral objectAtIndex:index]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MybleConnect"];
    [_Dlist removeFromSuperview];

}
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~手环~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * 手环读取单位
 */
- (void)ReadBitUnit{
    [[MyBle sharedManager] GetDistanceUnit];
}
/**
 * 扫描手环
 */
-(void)ScanPeriPheral{
    //查找设备动画
    [_searchLD startTimer];
    //判断连接状态
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        //           如果连接
        //  1. 断开
        [[MyBle sharedManager] disconnect:[MyBle sharedManager].activePeripheral];
        //  2. 连接
        [self performSelector:@selector(ScanMyFitble) withObject:nil afterDelay:1];
    }else{
        //            未连接
        [self performSelector:@selector(ScanMyFitble) withObject:nil afterDelay:2];
    }
}
- (void)ScanMyFitble{

    [arrayPeripheral removeAllObjects];
    [arrayPeripheralStatus removeAllObjects];

    //检查是否有蓝牙被系统蓝牙连上
    NSArray * bleArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0xfff0"]]];
    if (bleArray.count > 0) {
//        for (int i =0; i<[bleArray count]; i++) {
//            CBPeripheral * ble = [bleArray objectAtIndex:i];
//            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"RSSI",[NSNumber numberWithBool:YES],@"IsConnect", nil];
//            [arrayPeripheral addObject:ble];
//            [arrayPeripheralStatus addObject:dict];
//        }
            [self performSelector:@selector(connectMyble) withObject:nil afterDelay:2];
        //隐藏查找动画界面
        [_searchLD pauserTimer];
        [_searchLD removeFromSuperview];
        return;
    }

            //隐藏查找动画界面
//    [_searchLD pauserTimer];
//    [_searchLD removeFromSuperview];


    [[MyBle sharedManager] findBLEPeripheralsWithRepeat:YES];

    noFindBle = YES;


//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));
//    
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        if (noFindBle == YES) {
//            [_Dlist removeFromSuperview];
//            [self.navigationController showNotificationWithString:@"未找到手环"];
//        }
//    });


}

/**
 *  又要延时？
 */
-(void)delayFindBlePRepeat{
    // 猜测 找到手环 并重新设置


}
/**
 *  连接 手环
 */
- (void)connectMyble{

    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] disconnect:[MyBle sharedManager].activePeripheral];
    }else{
        CBUUID * uuid = [CBUUID UUIDWithString:@"0xfff0"];
        NSArray * PeripheraArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[uuid]];

        if (PeripheraArray.count>0) {
            [[MyBle sharedManager] connectPeripheral:PeripheraArray[0]];

        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请连接蓝牙" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }


}

/**
 * 开始通信
 */

- (void)StartBitorStopBitgo{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        if (!isStart) {
            isStart = YES;
            [[MyBle sharedManager] startGo];
        }else{
            isStart = NO;
            [[MyBle sharedManager] stopGo];
        }


    }

}
 /**
  * 读取历史心率
  */
-(void)ReadHeartRate{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        Blestatus = 2;
//        int number;
//        [[MyBle sharedManager] ReadHistoryHeartRateWithNumber:number];

    }
}
/**                               ^^
 *   删除数据 >>>>>>>>>>>>>>>>>   \(0)/   <<<<<<<<<<<<<<<<<<<<<<
 */
-(void)DeleteHistoryDataWithDay{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
//        int day;
//        [[MyBle sharedManager] DeledeHistoryDataWithDay:day];
    }

}

/**
 *     llllllllllllllllllll```获得每天目标达成率```lllllllllllllll
 */
-(void)readHishtoryGoalWithDay{
//    int day;
//    [[MyBle sharedManager] ReadHistoryGoalWithDay:day];
}
/**
 *  jjjjjjjjjjjjjjjjjjjjjj   获取总数据  LLLLLLLLLLLLLLLL
 */
-(void)GetTotalDatWithDay{
//    int day;
//    [[MyBle sharedManager] getTotalDataWithDay:day];
}
/**
 *  获取详细数据
 */
-(void)readDetailDatWithDay{
    if ([MyBle sharedManager].activePeripheral.state == 2) {

//        int day;
//        [[MyBle sharedManager] getDetailDataWithDay:day];
    }
}
/**
 *  设置目标步数
 */
-(void)SetStepGoal{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] SetGoal:10000];
    }
}
/**
 *  获取目标步数
 */
-(void)GetStepGoal{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] GetGoal];
    }
}

#pragma mark BLE Delegate
-(void)FindDeviceWithDevice:(CBPeripheral *)device RSSI:(NSNumber *)RSSI{
    noFindBle = NO; //是否走这个代理;
    int value = RSSI.intValue;
    NSLog(@">>>>>>>%d",value);
    if (value<0 && value>=-70) {
        NSString * strName = device.name;
        if (strName.length == 0) {
            strName = @"LOVE LIFE-iDear";
        }

        if ([arrayPeripheral containsObject:device]) {
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:RSSI,@"RSSI",@NO,@"IsConnect", nil];
            NSUInteger index = [arrayPeripheral indexOfObject:device];
            [arrayPeripheralStatus replaceObjectAtIndex:index withObject:dict];
        }else{
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:RSSI,@"RSSI",@NO,@"IsConnect", nil];
            [arrayPeripheral addObject:device];
            [arrayPeripheralStatus addObject:dict];
        }

        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]) {
            //刷新  设备列表
            [_Dlist reloadDeviceListView:arrayPeripheral WithPeripheral:arrayPeripheralStatus];
        }else{
            Blestatus = 1;
            //停止扫描
            [[MyBle sharedManager].CM stopScan];
            //连接设备
            [[MyBle sharedManager] connectPeripheral:[arrayPeripheral objectAtIndex:0]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MybleConnect"];
        }


    }else{

        if (_Dlist) {
            [_Dlist removeFromSuperview];
        }
    }
}

//开始通信
-(void)DisplayRece:(Byte *)buf length:(int)len{
    switch (buf[0]) {
            //开始实时计步
        case CMD_BEGIN_SEND_STEP:
            {   //  步数
                current_Step = buf[1]*256*256+buf[2]*256+buf[3];
                _headView.current_b = current_Step;

                if (goal_step) {
                    progress = (float)current_Step/goal_step;
                }else{
                    progress = (float)current_Step/mubiao_Step;
                }

                _headView.progress = progress;

                connect_S = @"已连接";

                _headView.connect_status = connect_S;

//                NSString * Step = [NSString stringWithFormat:@"%d",buf[1]*256*256+buf[2]*256+buf[3]];
                //   目标
//                mubiao_Step = buf[4]+buf[5]*256+buf[6]*256*256;
//                _headView.finish_b = mubiao_Step;

                //    卡洛里

                Calories = [NSString stringWithFormat:@"%.1f",(buf[7]*256*256+buf[8]*256+buf[9])*0.01 - 0.05>0?(buf[7]*256*256+buf[8]*256+buf[9])*0.01-0.05:0];






                float distance =( (buf[10]*256*256+buf[11]*256+buf[12])*0.01-0.05)>0?((buf[10]*256*256+buf[11]*256+buf[12])*0.01-0.05):0;

                if (Unit == 0) {
                    distanceK = [NSString stringWithFormat:@"%.1f km",distance];
                }else{
                    distanceK = [NSString stringWithFormat:@"%.1f mile",distance*0.6213712];


                }

//                NSString * strtime = [NSString stringWithFormat:@"%d",buf[14] + buf[13]*256];
                int time = (int)(buf[14] + buf[13]*256);
                int minuteT = time%60;
                int hours = time/60;
                int days = time/60/24;
                if (minuteT>0 && hours <=0 && days<=0) {
                    distanceTime = [NSString stringWithFormat:@"共: %d分钟",minuteT];
                }else if (hours>0 && days<=0){
                    distanceTime = [NSString stringWithFormat:@"共: %d小时%d分钟",hours,minuteT];
                }else if (days >0){
                    distanceTime = [NSString stringWithFormat:@"共: %d天%d小时%d分钟",days,hours,minuteT];
                }else{
                    distanceTime = [NSString stringWithFormat:@"共: %d分钟",minuteT];
                }
                _CellHead.fun_content = distanceTime;


                _CellHead.fun_top =  [NSString stringWithFormat:@"已消耗卡路里：%@ kcal",Calories];

                _CellHead.fun_bottom = [NSString stringWithFormat:@"步行距离：%@",distanceK];

                [[MyBle sharedManager] GetBatteryLevel];

                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                bleinfoisSuccess = YES;
//                [[MyBle sharedManager] ReadHistoryGoalWithDay:0];
            }
            break;
            //获得距离单位
         case CMD_GET_DISTANCE_UNIT:
            {
                if (buf[1] == 0) {
                    //  km
                    Unit = 0;

                }else{
                    //  Mile
                    Unit = 1;
                }

            }
            break;
        case CMD_GET_POWER:
        {//获得电量
            NSLog(@"电池电量%hhu",buf[1]);
            bleinfoisSuccess = YES;
            element_S = buf[1]*20;
            _headView.element_D = element_S;
        }
            break;
        case CMD_GET_HISTORY_HEARTRATE:
        {
            int year = (buf[2]-buf[2]/16*6)+2000;
            int month = (buf[3]-buf[3]/16*6);
            int day = (buf[4]-buf[4]/16*16);
            int hour = (buf[5]-buf[5]/16*6);
            int minute =(buf[6]-buf[6]/16*6);

            NSString * strData1 = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",buf[7],buf[8],buf[9],buf[10],buf[11],buf[12]];
            NSString * strData2 = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",buf[13],buf[14],buf[15],buf[16],buf[17],buf[18]];
            NSString * textStr =[NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d (%@,%@)\n",year,month,day,hour,minute,strData1,strData2];
        }
            break;
        case CMD_GET_DETAIL_DATA://获得详细数据
        {

            if (buf[1] == 0xff) {
                [self.navigationController showNotificationWithString:@"没有数据"];
            }else{
                //    AA BB CC: 表示这一天的年，月，日。
                //            DD: 为时间刻度索引，如00:0000:15为这天的第0个时间刻度，索引值为0。
                //                23:4524:00为这天的第95个时间刻度，索引值为95。最大取值为95。
                //            EE: 如果EE = 0xF0表示这是运动数据，如果EE =0xFF表示这是睡眠质量监测数据, EE=0x00表示无有效数据。
                //                运动数据格式：
                //                FF GG 为卡路里，两个字节，低字节在前 （卡路里显示时请除以10，旧设计是除以100，但2字节无符号数的范围有限，以100为缩放因子容易溢出。）
                //                HH II 为步数，两个字节，低字节在前
                //                JJ KK 为距离，两个字节，低字节在前
                //                AA BB 位于 1) 报文JJ KK后面的两个字节：是这15分钟内，头两个字节的步数，
                if (buf[6] == 0xff) {//睡眠数据
                    int totalSleep = 0;
                    if (buf[5]%2 == 0) {
                        totalSleep = buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13];
                    }else{
                        totalSleep = buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13]+buf[14];
                    }
                    int deep = 0;
                    int light = 0;
                    if (totalSleep < 60) {
                        sleep_Deep += [self getNumFromTime:buf[5]];
                        deep = [self getNumFromTime:buf[5]];
                    }else if (totalSleep >= 60 && totalSleep< 120){
                        sleep_Light += [self getNumFromTime:buf[5]];;
                        light = [self getNumFromTime:buf[5]];
                    }else{
                        NSLog(@"醒着");
                    }
                    NSLog(@"%02d:%02d~%02d:%02d",buf[5]*15/60,buf[5]*15%60,(buf[5]+1)*15/60,(buf[5]+1)*15%60);
//                    NSLog(@"time_%d__%d____%d",sleep_Deep,sleep_Light,sleep_alltime);
                    sleep_alltime += (deep + light);


//                    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",buf[5]],@"count",[NSString stringWithFormat:@"%d",totalSleep],@"SleepQuality", nil];
                }else{
                    float calories = (buf[7]+buf[8]*256)*0.1;
                    int step = buf[9]+buf[10]*256;
                    float distance = (buf[11]+buf[12]*256)*0.01;

                               NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",buf[5]],@"count" ,[NSString stringWithFormat:@"%.1f",calories],@"Calories",[NSString stringWithFormat:@"%d",step],@"Step",[NSString stringWithFormat:@"%.1f",distance],@"Distance",nil];

                }

                if (buf[5] == 95) {
                    bleinfoisSuccess = YES;
                    [_shadeView pauseWritTimer:@"数据同步完成"];
                    
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    //发送读取总数据命令
//                    [self GetTotalDatWithDay];
                }

            }
        }
            break;
        case CMD_GET_TOTAL_DATA: //获得总数据
        {
            //
            //            校验正确且执行OK返回：	0x07 AA BB CC DD EE FF GG HH II JJ KK LL MM NN CRC
            //            校验错误或执行Fail返回：	0x87 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
            //
            //            回复描述(共有两条回复，两条回复数据中的前五个字节含义相同)：
            //            AA 表示命令索引值，这个命令将回复两条，第1条索引值为0，第二条为1
            //            BB 表示这是前几天的数据。
            //            CC DD EE 表示年月日(如果年月日全为0,则表示这一天没有存储数据)
            //            第一条回复
            //            FF GG HH 为总步数
            //            II JJ KK 为3字节的跑步步数/有氧步数，高字节在前。
            //            LL MM NN 为3字节的卡路里值，高字节在前。（卡路里显示时请除以100，保留两位小数）
            //
            //            第二条回复
            //            FF GG HH 为3字节的步行距离，高字节在前。
            //            II JJ 为2字节的运动时间，单位为分钟。
            //            KK LL 为总2字节的睡眠时间，高字节在前，单位为分钟。

            if (buf[1] == 0) {
                int step = buf[6]*256*256 + buf[7]*256 + buf[8];
                float Calories = (buf[12]*256*256 + buf[13]*256+buf[14])*0.01-.05;

                NSString * str = [NSString stringWithFormat:@"\n20%02d-%02d-%02d Total Data:\n Total Step:%d\n Total Caloires:%.1f Kcal",(buf[3]-buf[3]/16*6),buf[4]-buf[4]/16*6,buf[5]-buf[5]/16*6,step,Calories];
            }else{

                float distance = (buf[6]*256*256 + buf[7]*256 + buf[8])*0.01-0.05;
                int RunTime = buf[9]*256 + buf[10];
                NSString * str = [NSString stringWithFormat:@"\n Total Distance:%.1fkm\n Activity Time:%d Min",distance,RunTime];

//                [self readHishtoryGoalWithDay];
            }
        }
            break;
//        case CMD_GET_GOAL_DATA://获得每天目标达成率
//        {
//            progress = (buf[11]*256+buf[2])*0.1;
//            NSLog(@"MMmmmmmmmmmmmMM%f",progress);
//            _headView.progress = progress;

//               [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            NSString * goal = [NSString stringWithFormat:@"\n Daily Goal:%.1f %%",(buf[11]*256+buf[2])*0.1];
//        }
//            break;
        case CMD_SET_GOAL://设置目标步数成功回调
        {

        }
            break;
        case CMD_GET_GOAL://获取目标步数
        {
            mubiao_Step = buf[1]*256*256 + buf[2]*256+buf[3];

            if (!mubiao_Step) {
                mubiao_Step = 10000;
            }
            goal_step = mubiao_Step;
            _headView.finish_b = mubiao_Step;
        }
            break;

        case 0x2c:
        {

            head_num_five++;
            NSLog(@"心跳哦%d",buf[1]);


            if (head_num_five == 5) {
                head_num_five = 0;

                int num_object = buf[1];
                NSLog(@"head_num_fuve%lu",(unsigned long)head_num_five);
                if (num_object>=0) {
//                        [_headArrayFive addObject:@(num_object)];
                    [_headArrayFive replaceObjectAtIndex:head_num_five withObject:@(num_object)];
                }else{
                    [_headArrayFive replaceObjectAtIndex:head_num_five withObject:@(0)];
                }


                NSLog(@"%lu",(unsigned long)_headArrayFive.count);


                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];

                

            }else{

                 int num_object = buf[1];
                NSLog(@"head_num_fuve%lu",(unsigned long)head_num_five);
                if (num_object>=0) {

//                    [_headArrayFive addObject:@(num_object)];
                    [_headArrayFive replaceObjectAtIndex:head_num_five withObject:@(num_object)];
                }else{
                    [_headArrayFive replaceObjectAtIndex:head_num_five withObject:@(0)];
                }

            }



        }
            break;
        case CMD_HEARTRATE_MODE:
        {
            uint8_t b[] = {0x2c,buf[1],0,0,0,0,0,0,0,0,0,0,0,0,0,0};

            int sam =0 ;
            for (int i = 0; i<15; i++) {
                sam  += b[i];
            }
            b[15] = sam;
            NSMutableData *data = [[NSMutableData alloc] initWithBytes:b length:16];
            [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];
        }
            break;
        default:
            break;
    }
}

//断开连接
-(void)Disconnected{
    [self.navigationController showNotificationWithString:@"断开连接"];
    connect_S = @"断开连接";
    _headView.connect_status = connect_S;
}

//开始
-(void)start{
    if (Blestatus == 1) {//读取历史心率
        [[MyBle sharedManager] enableRead:[MyBle sharedManager].activePeripheral];
        // 设置单位
        [self ReadBitUnit];
        //获取电量
        [[MyBle sharedManager] GetBatteryLevel];
        //开始
//        [[MyBle sharedManager] stopGo];
        [[MyBle sharedManager] startGo];


          [[MyBle sharedManager] GetGoal];



        NSDate * lastDate = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        NSString * string = [dateFormatter stringFromDate:lastDate];
        [[NSUserDefaults standardUserDefaults]  setValue:string forKey:@"LastConnect"];

        Blestatus = 0 ;

        connect_S = @"已连接";
        _headView.connect_status = connect_S;

        [_Dlist removeFromSuperview];
    }else{

        [[MyBle sharedManager] enable];

        // 设置单位
        [self ReadBitUnit];

        //获取电量
        [[MyBle sharedManager] GetBatteryLevel];

        [[MyBle sharedManager] startGo];

        [[MyBle sharedManager] GetGoal];


    }

    bleinfoisSuccess = YES;



    [self startHeartRateMode]; //心率监测。。

     [[MyBle sharedManager] getDetailDataWithDay:1];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MybleConnect"]; //连接状态
}

//设置 蓝牙管理中心
-(void)SetCenter:(CBCentralManager *)center ble:(CBPeripheral *)myPeripheral{


}

-(void)startHeartRateMode{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"startHeartRateMode"]) {

        [[MyBle sharedManager] StartHeartRateMode];
    }else{
        [[MyBle sharedManager] StopHeartRateMode];
    }
}


/** ____________________________初始化界面____________________________
 *
 */
- (void)setupTableView{
    _tableView  =[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
//    _tableView.alpha = 0.9;
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    // 5.设置分割线样式
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        return ;
//    }];
//    UIView * view = [[UIView alloc] initWithFrame:_tableView.frame];
//
//    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 101, self.view.frame.size.width, 101)];
//    img.image = [UIImage imageNamed:@"background"];
//    [view addSubview:img];
//    _tableView.backgroundView = view;
    _funArray = @[@[@"measure_icon_sport",@"measure_icon_sleep",@"measure_icon_heart"],@[@"运动",@"睡眠",@"心率"]];
    _wristArray = [NSMutableArray arrayWithArray:@[@[@"共：0分钟",@"暂无数据",@"当前心率"] ,@[@"已消耗卡路里：0.0 kcal",@"浅度睡眠时间：暂未获得睡眠数据"],@[@"步行距离：0.0 km",@"深度睡眠时间：暂未获得睡眠数据"],@[@0,@0,@0,@0,@0]]];
    _headArrayFive = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,@0]];
//    headArray_five = [NSMutableArray arrayWithCapacity:5];
}

/*** /
 *  刷新手环数据
 * /
 */
- (void)loadNewDatas{
//    element_S = 19;
//    progress= progress+0.01;
//    NSLog(@"%f",progress);
//    self.headView.progress = progress;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}


#pragma mark UITableViewDelegate && UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {

        _headView = [[WristHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 227)];
        _headView.SHFill = YES;
        _headView.connect_status = connect_S;
        _headView.progress = progress;
        _headView.element_D = element_S;
        _headView.current_b = current_Step;

        _headView.finish_b = mubiao_Step;
        return _headView;

    }else if (section == 1){
        _CellHead = [[WristCellHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
        _CellHead.color = [UIColor colorWithHexString:@"#f88027"];
        _CellHead.img_name = _funArray[0][section-1];
        _CellHead.fun_name = _funArray[1][section-1];
        if (distanceTime) {
            _CellHead.fun_content = distanceTime;
        }else{
            _CellHead.fun_content = _wristArray[0][section-1];
        }

        if (Calories) {
            _CellHead.fun_top = [NSString stringWithFormat:@"已消耗卡路里：%@ kcal",Calories];
        }else{
            _CellHead.fun_top = _wristArray[1][section-1];
        }
        if (distanceK) {
            _CellHead.fun_bottom = [NSString stringWithFormat:@"步行距离：%@",distanceK];
        }else{
            _CellHead.fun_bottom = _wristArray[2][section -1];
        }


        return _CellHead;
    }else if (section == 2){
        _CellHead1 = [[WristCellHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
        _CellHead1.color = [UIColor colorWithHexString:@"#50c0e5"];
        _CellHead1.img_name = _funArray[0][section - 1];
        _CellHead1.fun_name = _funArray[1][section-1];

        if (sleep_alltime>0) {

            _CellHead1.fun_content = [NSString stringWithFormat:@"共:%@",[self getTimeFromnum:sleep_alltime]];
        }else{
            _CellHead1.fun_content = _wristArray[0][section-1];
        }


        if (sleep_Light > 0) {
            _CellHead1.fun_top = [NSString stringWithFormat:@"浅度睡眠时间:%@",[self getTimeFromnum:sleep_Light]];
        }else{
            _CellHead1.fun_top = _wristArray[1][section-1];
        }

        if (sleep_Deep > 0) {
            _CellHead1.fun_bottom = [NSString stringWithFormat:@"深度睡眠时间:%@",[self getTimeFromnum:sleep_Deep]];
        }else{
            _CellHead1.fun_bottom = _wristArray[2][section -1];
        }


        return _CellHead1;
    }else{
        _CellChartsHead = [[ChartsCellHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
        _CellChartsHead.color = [UIColor colorWithHexString:@"#fb5cb9"];
        _CellChartsHead.img_name = _funArray[0][section - 1];
        _CellChartsHead.fun_name = _funArray[1][section - 1];
        _CellChartsHead.fun_content = _wristArray[0][section - 1];

        if ( _headArrayFive.count > 0 ) {

            _CellChartsHead.heartValue = _headArrayFive;
        }else{
            _CellChartsHead.heartValue = _wristArray[3];
        }

        
        return _CellChartsHead;

    }

    return nil;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section != 0) {
        return([UIScreen mainScreen].bounds.size.height - 227.0-64)/3;
    }
    return 227.0f;
}

-(NSString *)getTimeFromnum:(int)time{
    int minuteT = time%60;
    int hours = time/60;
    int days = time/60/24;
    NSString * time1 = nil;
    if (minuteT>0 && hours <=0 && days<=0) {
        time1 = [NSString stringWithFormat:@" %d分钟",minuteT];
    }else if (hours>0 && days<=0){
        time1 = [NSString stringWithFormat:@" %d小时%d分钟",hours,minuteT];
    }else if (days >0){
        time1 = [NSString stringWithFormat:@" %d天%d小时%d分钟",days,hours,minuteT];
    }else{
        time1 = [NSString stringWithFormat:@" %d天%d小时%d分钟",days,hours,minuteT];
    }

    return time1;
}
-(int)getNumFromTime:(int)time{
    int num = 0;
    int lastHour = (time + 1)*15/60;
    int firstHour = time*15/60;

    int lastMin = (time + 1)*15%60;
    int firstMin = time*15%60;

    int hour = lastHour - firstHour;
    int min = lastMin - firstMin;

    num = (hour*60+min);
    return num;
}
/**
*     < 头部导航栏 >
* < 修改字体颜色及字体大小 >
*/
- (void)setupNavigation{


    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

//    UIButton * buttonView = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 26, 26)];
//    [buttonView addTarget:self action:@selector(leftPersonVC:) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView setImage: [UIImage imageNamed:@"nav_btn_person"] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(9 , 8, 40, 22)];
    label.text = @"返回";
    label.font= [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithHexString:@"565c5c"];

    UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 13, 6, 12)];
    back.image =  [UIImage imageNamed:@"icon_back"];
    back.userInteractionEnabled = YES;
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [view1 addSubview:label];
    [view1 addSubview:back];


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popSCVCCenter:)];
    [view1 addGestureRecognizer:tap];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view1];

    UIView * view = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 160, 40)];

    _titleImg = [[UIImageView alloc] init];
    if ([UserCenter shareUserCenter].source) {
        [_titleImg sd_setImageWithURL:[NSURL URLWithString:[UserCenter shareUserCenter].source]];
    }else{
        _titleImg.image = [UIImage imageNamed:@"icon"];
    }

    _titleImg.layer.cornerRadius = 12;
    _titleImg.layer.masksToBounds = YES;
    [view addSubview:_titleImg];

    _titleName = [[UILabel alloc] init];
    _titleName.text= [UserCenter shareUserCenter].name ? [UserCenter shareUserCenter].name : @"iDear";
    _titleName.font = [UIFont systemFontOfSize:19.0];

    _titleName.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [view addSubview:_titleName];
    self.navigationItem.titleView = view;

    [_titleImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view).offset(-20);
        make.centerY.equalTo(view);
        make.width.height.mas_equalTo(24);
    }];

    [_titleName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleImg.mas_right).offset(5);
        make.centerY.equalTo(_titleImg);
    }];

    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 60, 40)];
    [rightBtn setTitle:@"开关" forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, -18)];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightBtn addTarget:self action:@selector(setVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];


 


    
}
- (void)popSCVCCenter:(UIButton *)sender{
    [_searchLD pauserTimer];
    if (_Wrist_block) {
        if (!element_S) {
            element_S = 0;
        }

        if (!current_Step) {
            current_Step = 0;
        }

        if (!mubiao_Step) {
            mubiao_Step = 0;
        }

        if (!progress) {
            progress = 0;
        }
        _Wrist_block(@[@(element_S ),@(current_Step),@(mubiao_Step),@(progress),connect_S]);
    }

    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setVC:(UIButton *)sender{

    if (_searchLD.hidden == NO) {
        [_searchLD pauserTimer];
    }

    SetocVC * ocVC = [[SetocVC alloc] init];
    __weak typeof(self) weakSelf = self;
    ocVC.resetTimerBlock = ^{
        if (_searchLD.hidden == NO) {

            [weakSelf.searchLD startTimer];
            weakSelf.searchLD.Seachtransform = weakSelf.Selftransform;
            weakSelf.searchLD.timeP = weakSelf.searchTime_save;
        }

    };
    [self.navigationController pushViewController:ocVC animated:YES];


    
//    YSXViewController * ocVC = [[YSXViewController alloc] init];
//    [self.navigationController pushViewController:ocVC animated:YES];


//    MyPlayVC * vc = [[MyPlayVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

//    XLHeadVController * vc = [[XLHeadVController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

//    SMSleepVController * vc = [[SMSleepVController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
