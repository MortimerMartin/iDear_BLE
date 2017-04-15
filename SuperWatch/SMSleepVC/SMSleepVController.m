//
//  SMSleepVController.m
//  SuperWatch
//
//  Created by pro on 17/3/6.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SMSleepVController.h"
#import "SMSleepCell.h"
#import "SMSleepSectionHeadView.h"
#import "SMSleepHeadView.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "UIColor+HexString.h"
#import "MyBle.h"
#import "SVProgressHUD.h"
//#import "XLVC.h"
#import "SleepMXVC.h"
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kSMSleepCell @"kSMSleepCell"
@interface SMSleepVController ()<UITableViewDelegate , UITableViewDataSource,MyBleDelegate>
{
    NSMutableArray * sleepDataArray;
    NSDate * label_time;
    BOOL errorD;

    int mysleep_light;//浅度睡眠

    int mysleep_deep;//深度睡眠
    int mysleep_all;
}
@property (nonatomic ,strong)UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * SMSArray;
@property (nonatomic , strong) NSMutableArray * statusArray;

@property (nonatomic , strong) UIView * Bview;

@property (nonatomic , strong) SMSleepHeadView * headView ;

@property (nonatomic , strong) UILabel * timeLabel;
@end

@implementation SMSleepVController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    sleepDataArray = [NSMutableArray array];
    [MyBle sharedManager].delegate = self;
    self.navigationController.navigationBarHidden = YES;

    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  getDetailDataWithDay:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (_headView.release_chart) {
//        _headView.release_chart();
//    }
    if (errorD != YES) {
       [_headView releaseobserve];
    }
    errorD = NO;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
   self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupChartSMSleepHeadView];
    [self setupSMSleepVCView];
    [self setSMNavigationView];

    // Do any additional setup after loading the view.
}
#pragma mark bleDelegate

-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI
{

}
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len
{
    switch (buf[0]) {
        case CMD_GET_DETAIL_DATA:
        {
            if(buf[1]==0xff)
            {
                [SVProgressHUD showErrorWithStatus:@"没有数据"];
            }
            else
            {
                //    AA BB CC: 表示这一天的年，月，日。
                //            DD: 为时间刻度索引，如00:0000:15为这天的第0个时间刻度，索引值为0。
                //                23:4524:00为这天的第95个时间刻度，索引值为95。最大取值为95。
                //            EE: 如果EE = 0xF0表示这是运动数据，如果EE =0xFF表示这是睡眠质量监测数据, EE=0x00表示无有效数据。
                //                运动数据格式：
                //                FF GG 为卡路里，两个字节，低字节在前 （卡路里显示时请除以10，旧设计是除以100，但2字节无符号数的范围有限，以100为缩放因子容易溢出。）
                //                HH II 为步数，两个字节，低字节在前
                //                JJ KK 为距离，两个字节，低字节在前
                //                AA BB 位于 1) 报文JJ KK后面的两个字节：是这15分钟内，头两个字节的步数，
                if(buf[6]==0xff)
                {


                    NSLog(@"睡眠数据");
                    int TotalSleep  = 0;
                    if(buf[5]%2==0){
                        TotalSleep = buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13];
                    }
                    else{
                        TotalSleep = buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13]+buf[14];
                    }

                    int deep = 0;
                    int light = 0;
                    if (TotalSleep < 60) {
                        mysleep_deep += [self getNumFromTime:buf[5]];
                        deep = [self getNumFromTime:buf[5]];
                        NSString * strTime = [NSString stringWithFormat:@"%02d:%02d~%02d:%02d",buf[5]*15/60,buf[5]*15%60,(buf[5]+1)*15/60,(buf[5]+1)*15%60];
                        [_SMSArray addObject:strTime];
                        [_statusArray addObject:@"深度睡眠"];
                    }else if (TotalSleep >= 60 && TotalSleep< 120){
                        mysleep_light += [self getNumFromTime:buf[5]];;
                        light = [self getNumFromTime:buf[5]];
                        NSString * strTime = [NSString stringWithFormat:@"%02d:%02d~%02d:%02d",buf[5]*15/60,buf[5]*15%60,(buf[5]+1)*15/60,(buf[5]+1)*15%60];
                        [_SMSArray addObject:strTime];
                        [_statusArray addObject:@"浅度睡眠"];
                    }else{
                        NSLog(@"醒着");
                    }
                    NSLog(@"%02d:%02d~%02d:%02d",buf[5]*15/60,buf[5]*15%60,(buf[5]+1)*15/60,(buf[5]+1)*15%60);
                    //                    NSLog(@"time_%d__%d____%d",sleep_Deep,sleep_Light,sleep_alltime);
                    mysleep_all += (deep + light);

                    

                    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",buf[5]],@"count",[NSString stringWithFormat:@"%d",TotalSleep],@"SleepQuality",nil];

                    [sleepDataArray addObject:dict];
                }

                if (buf[5] == 95) {
                    [self getTimeFromnum:mysleep_light Status:1];
                    [self getTimeFromnum:mysleep_deep Status:2];
                    [_headView reloadVBPieChart:mysleep_deep lightSleep:mysleep_light];
                    [_headView reloadSMSleepTime:mysleep_all];

                    [_tableView reloadData];
                }

            }
        }
            break;


        default:
            break;
    }

}
-(void)Disconnected
{

}
-(void)start
{
    [[MyBle sharedManager] enable];
}
-(void)SetCenter:(CBCentralManager*)center ble:(CBPeripheral*)myPeripheral
{

}
-(void)getTimeFromnum:(int)time Status:(int)status{
    int minuteT = time%60;
    int hours = time/60;
    int days = time/60/24;

    if (minuteT>0 && hours <=0 && days<=0) {
        if (status == 1) {
            [_headView reloadLgihtSMSleep:0 LightMin:minuteT];
        }else{
            [_headView reloadDeepSMSleep:0 DeepMin:minuteT];
        }
    }else if (hours>0 && days<=0){
        if (status == 1) {
            [_headView reloadLgihtSMSleep:hours LightMin:minuteT];
        }else{
            [_headView reloadDeepSMSleep:hours DeepMin:minuteT];
        }

    }else if (days >0){
        if (status == 1) {
            [_headView reloadLgihtSMSleep:(hours+days*24) LightMin:minuteT];
        }else{
            [_headView reloadDeepSMSleep:(hours+days*24) DeepMin:minuteT];
        }

    }else{
        if (status == 1) {
            [_headView reloadLgihtSMSleep:0 LightMin:minuteT];
        }else{
            [_headView reloadDeepSMSleep:0 DeepMin:minuteT];
        }

    }

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
-(NSMutableArray *)GetSleepArray{
    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * data  in sleepDataArray) {
        int count = ((NSString*)[data objectForKey:@"count"]).intValue;
        NSString * strTime = [NSString stringWithFormat:@"%02d:%02d~%02d:%02d",count*15/60,count*15%60,(count+1)*15/60,(count+1)*15%60];

        NSString * strSleepQuality = [data objectForKey:@"SleepQuality"];

        if ([strSleepQuality intValue]<60) {
            strSleepQuality = @"深度睡眠";
            [arr addObject:@[strTime , strSleepQuality]];
        }else if ([strSleepQuality intValue]>= 60 && [strSleepQuality intValue]<120){
            strSleepQuality = @"浅度睡眠";
             [arr addObject:@[strTime , strSleepQuality]];
        }else{
            //醒着
        }

    }

    return arr;
}

- (void)setupChartSMSleepHeadView{
    _headView = [[SMSleepHeadView alloc] initWithFrame:CGRectMake(0, 107, self.view.frame.size.width, 228)];
    [self.view addSubview:_headView];

}

- (void)setupSMSleepVCView{



    _SMSArray = [NSMutableArray array];
    _statusArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
  _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[SMSleepCell class] forCellReuseIdentifier:kSMSleepCell];

    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _Bview = [[UIView alloc] init];
    _Bview.layer.cornerRadius = 3;
    _Bview.layer.masksToBounds = YES;
    _Bview.layer.borderWidth = 0.5f;
    _Bview.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
    [self.view addSubview:_Bview];
    [_Bview addSubview:_tableView];




//    [_Bview mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(_headView.mas_bottom);
//    }];




}

- (void)setSMNavigationView{
    UIView * navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];

    [navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(107);
    }];
    [_headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
        make.height.mas_equalTo(228);
    }];

    _Bview.frame = CGRectMake(12, 347, self.view.frame.size.width - 24, 45);


    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_Bview);
    }];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popXLHeadView) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets= UIEdgeInsetsMake(0, -15, 0, 0);
    [navigationView addSubview:btn];

    UILabel * tilte = [[UILabel alloc] init];
    tilte.font = [UIFont systemFontOfSize:19];
    tilte.textAlignment = NSTextAlignmentCenter;
    tilte.textColor = [UIColor colorWithHexString:@"#565c5c"];
    tilte.text = @"我的睡眠";
    [navigationView addSubview:tilte];

    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    leftButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [navigationView addSubview:leftButton];

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(loadSleepMessage:) forControlEvents:UIControlEventTouchUpInside];


    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    [navigationView addSubview:rightButton];

    _timeLabel = [[UILabel alloc] init];
//    _timeLabel.text = @"2017-02-15";
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    label_time = [NSDate date];
    _timeLabel.text = [formatter stringFromDate:label_time];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [navigationView addSubview:_timeLabel];

    [leftButton addTarget:self action:@selector(leftReloadXLHeadView) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightReloadXLHeadView) forControlEvents:UIControlEventTouchUpInside];

    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView).offset(10);
        make.top.equalTo(navigationView).offset(30);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];

    [tilte mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navigationView);
        make.centerY.equalTo(btn);
        make.height.mas_equalTo(30);
        make.height.mas_equalTo(90);
    }];

    [rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navigationView).offset(-4);
        make.centerY.height.width.equalTo(btn);
    }];


    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tilte);
        make.bottom.equalTo(navigationView).offset(-10);
    }];

    [leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(60);
        if (kDevice_Is_iPhone5) {
            make.right.equalTo(_timeLabel.mas_left).offset(-55);
        }else{
            make.right.equalTo(_timeLabel.mas_left).offset(-132*([UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height));
        }
    }];

    [rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(60);
        if (kDevice_Is_iPhone5) {
            make.left.equalTo(_timeLabel.mas_right).offset(55);
        }else{
            make.left.equalTo(_timeLabel.mas_right).offset(132*([UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height));
        }
    }];


    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [navigationView addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(navigationView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)loadSleepMessage:(UIButton *)sender{

    errorD = YES;

//    XLVC * xlvc = [[XLVC alloc] init];
    SleepMXVC * sleep = [[SleepMXVC alloc] init];
    [self.navigationController pushViewController:sleep animated:YES];

}

-(void)leftReloadXLHeadView{

    NSTimeInterval  oneTime = -24*60*60;
    NSDate * yesterday = [label_time dateByAddingTimeInterval:oneTime];
    label_time = yesterday;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";

    mysleep_deep = 0;
    mysleep_light = 0;
    mysleep_all = 0;
    _timeLabel.text = [formatter stringFromDate:yesterday];
}

- (void)rightReloadXLHeadView{



    NSTimeInterval  oneTime = 24*60*60;
    NSDate * tomorrow = [label_time dateByAddingTimeInterval:oneTime];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:tomorrow];
    if (time<= -86000) {
        return;
    }
    label_time = tomorrow;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    mysleep_deep = 0;
    mysleep_light = 0;
    mysleep_all = 0;

    _timeLabel.text = [formatter stringFromDate:tomorrow];

}
- (void)popXLHeadView{

    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_SMSArray.count>0 && _statusArray.count>0) {
        _tableView.scrollEnabled = YES;
        return [_SMSArray count];
    }else{
        _tableView.scrollEnabled = NO;
        return 0;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMSleepCell * cell = [tableView dequeueReusableCellWithIdentifier:kSMSleepCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSMSleepCell forIndexPath:indexPath];
    }
//    cell.backgroundColor = [UIColor greenColor];
    if (_SMSArray>0 &&_statusArray.count>0) {
        cell.time = _SMSArray[indexPath.row];
        cell.status = _statusArray[indexPath.row];
        if (indexPath.row == _SMSArray.count-1) {
            cell.lastrow = YES;

            if ((40*[_SMSArray count]+45) > (self.view.frame.size.height - 347) ) {
                _Bview.height = self.view.frame.size.height - 359;
            }else{
                _Bview.height = 40*[_SMSArray count]+45;
            }

        }
    }else{
        _Bview.height = 45;
    }


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 45.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        SMSleepSectionHeadView * sectionHeadView = [[SMSleepSectionHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
//    sectionHeadView.backgroundColor = [UIColor redColor];
        return sectionHeadView;


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 45;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
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
