//
//  MyPlayVC.m
//  SuperWatch
//
//  Created by pro on 17/3/5.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "MyPlayVC.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "NSDate+Extension.h"
#import "MyPlayCCell.h"
#import "MyPlayHeadView.h"
#import "MyBle.h"
#import "SVProgressHUD.h"
#import "XHDatePickerView.h"
#import "SportVC.h"
#define kMyPlayCCell @"kMyPlayCCell"
#define kMyPlayHistoryHeadView @"kMyPlayHistoryHeadView"
@interface MyPlayVC ()<UICollectionViewDelegate , UICollectionViewDataSource,MyBleDelegate>
{
    NSString * startString;
    NSString * endString;

    int  Sport_steps; // 步数
    float Calories;   // 卡洛里
    float Sport_distance;  //距离
    NSString * Sport_distance_time;
}
@property (nonatomic ,strong)UICollectionView * collectionView;
@property (nonatomic , strong) UIButton * startBtn;
@property (nonatomic , strong) UIButton * endBtn;
@property (nonatomic , strong) MyPlayHeadView * head;

@property (nonatomic , strong) NSMutableArray * PlayValues;
@property (nonatomic , strong) NSMutableArray * PlayDates;
@property (nonatomic , strong) NSMutableArray * PlayItems;

@end

@implementation MyPlayVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyBle sharedManager].delegate = self;

    self.navigationController.navigationBarHidden = YES;
    if ([MyBle sharedManager].activePeripheral.state == 2) {

    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupPlayCollectionView];
    [self setPlayNavigationView];
    // Do any additional setup after loading the view.
}

- (void)setupPlayCollectionView{

    _PlayValues = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,@0,@0,@0]];
    _PlayDates = [NSMutableArray array];
    _PlayItems = [NSMutableArray arrayWithArray:@[@[@"卡路里",@"步行距离"],@[@"0kcal",@"0km"]]];

    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    self.collectionView=collectionView;
    [self.view addSubview:collectionView];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.showsVerticalScrollIndicator=NO;
    collectionView.backgroundColor=[UIColor colorWithHexString:@"#eff4f4"];
    [_collectionView registerClass:[MyPlayCCell class] forCellWithReuseIdentifier:kMyPlayCCell];

    [_collectionView registerClass:[MyPlayHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyPlayHistoryHeadView];


}

#pragma mark UICollectionViewDataSource && UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_PlayItems count] > 0) {
        return [_PlayItems[0] count];
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyPlayCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyPlayCCell forIndexPath:indexPath];
    cell.name = _PlayItems[0][indexPath.item];
    cell.content = _PlayItems[1][indexPath.item];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{




    NSTimeInterval oneDay = 24 * 60 * 60 * 1;
    NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];

    [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

    [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];



}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return   CGSizeMake(168, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 12, 8, 12);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

// 定义headview的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 188);
}

//// 定义section的边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//    return UIEdgeInsetsMake(8, 12, 8, 12);
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{


    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        _head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyPlayHistoryHeadView forIndexPath:indexPath];
        _head.color = [UIColor colorWithHexString:@"#feae2d"];

        if (_PlayValues.count >0 && _PlayDates.count >0) {


            _head.values = _PlayValues;
            _head.dates = _PlayDates;
            _head.content = @"10000步";
            _head.name = @"步数";
            _head.setOffX = 1;
            [_head refreshView];
        }

        return _head;
    }
      UICollectionReusableView * headView = [collectionView dequeueReusableCellWithReuseIdentifier:@"kErrorCollectionCell" forIndexPath:indexPath];
    return headView;
}


/**
 *     获得每天目标达成率
 */
//-(void)readHishtoryGoalWithDay{
//    int day;
//    [[MyBle sharedManager] ReadHistoryGoalWithDay:day];
//}
/**
 *     获取总数据
 */
//-(void)GetTotalDatWithDay{
//    int day;
//    [[MyBle sharedManager] getTotalDataWithDay:day];
//}
/**
 *     获取详细数据
 */
//-(void)readDetailDatWithDay{
//    if ([MyBle sharedManager].activePeripheral.state == 2) {
//
//        int day;
//        [[MyBle sharedManager] getDetailDataWithDay:day];
//    }
//}
#pragma mark bleDelegate

-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI
{

}
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len
{
    switch (buf[0]) {
        case CMD_GET_DETAIL_DATA: //获得详细数据
        {
            if(buf[1]==0xff)
            {
                [SVProgressHUD  showErrorWithStatus:@"没有数据"];
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


                  //  NSLog(@"睡眠数据");
                  //  int TotalSleep  = 0;
                  //  if(buf[5]%2==0){
                  //      TotalSleep = buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13];
                  //  }else{
                 //       TotalSleep = buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13]+buf[14];
                 //   }
                 //   NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",buf[5]],@"count",[NSString stringWithFormat:@"%d",TotalSleep],@"SleepQuality",nil];



                }
                else
                {
                    float calories = (buf[7]+buf[8]*256)*0.1;
                    int step  =  buf[9] +buf[10]*256;
                    float  distance = (buf[11]+buf[12]*256)*0.01;

                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",buf[5]],@"count" ,[NSString stringWithFormat:@"%.1f",calories],@"Calories",[NSString stringWithFormat:@"%d",step],@"Step",[NSString stringWithFormat:@"%.1f",distance],@"Distance",nil];
                    [_PlayValues addObject:dic];
                }
                if(buf[5]==95)
                {
                    //发送读取总数据的命令
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
            if(buf[1]==0)
            {
                Sport_steps = buf[6]*256*256 +buf[7]*256 +buf[8];
                NSLog(@"step = %d",Sport_steps);
                Calories = (buf[12]*256*256 +buf[13]*256+buf[14])*0.01-0.05;
              //  strTextView  = [NSString stringWithFormat:@"\n20%02d-%02d-%02d Total Data:\n Total Step:%d\n Total Caloires:%.1f Kcal",(buf[3]-buf[3]/16*6),buf[4]-buf[4]/16*6,buf[5]-buf[5]/16*6,step,Calories];
            }
            else
            {

                Sport_distance =( buf[6]*256*256 + buf[7]*256 +buf[8])*0.01-0.05;
                int time = buf[9]*256 +buf[10];
                int minuteT = time%60;
                int hours = time/60;
                int days = time/60/24;
                if (minuteT>0 && hours <=0 && days<=0) {
                    Sport_distance_time = [NSString stringWithFormat:@"共: %d分钟",minuteT];
                }else if (hours>0 && days<=0){
                    Sport_distance_time = [NSString stringWithFormat:@"共: %d小时%d分钟",hours,minuteT];
                }else if (days >0){
                    Sport_distance_time = [NSString stringWithFormat:@"共: %d天%d小时%d分钟",days,hours,minuteT];
                }else{
                    Sport_distance_time = [NSString stringWithFormat:@"共: %d天%d小时%d分钟",days,hours,minuteT];
                }

              //  strTextView  = [strTextView stringByAppendingString:[NSString stringWithFormat:@"\n Total Distance:%.1fkm\n Activity Time:%d Min",distance,RunTime]];
                //发送读取完成率的命令

//                [self readHishtoryGoalWithDay];

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


- (void)setPlayNavigationView{

    UIView * navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    [navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(107);
    }];
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissMyPlayView) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets= UIEdgeInsetsMake(0, -15, 0, 0);
    [navigationView addSubview:btn];

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(loadSportMessage:) forControlEvents:UIControlEventTouchUpInside];

    UILabel * tilte = [[UILabel alloc] init];
    tilte.font = [UIFont systemFontOfSize:19];
    tilte.textAlignment = NSTextAlignmentCenter;
    tilte.textColor = [UIColor colorWithHexString:@"#565c5c"];
    tilte.text = @"我的运动";
    [navigationView addSubview:tilte];

    NSTimeInterval oneDay = 24 * 60 * 60 * 1;
    NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.backgroundColor = RGBA(234, 235, 235, 1);
    [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _startBtn.layer.cornerRadius = 4;
    _startBtn.layer.masksToBounds = YES;
    [navigationView addSubview:_startBtn];

    UIView * centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor colorWithHexString:@"#565c5c"];
    [navigationView addSubview:centerView];

    _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _endBtn.backgroundColor = RGBA(234, 235, 235, 1);
    //    [_endBtn setTitle:@"结束日期" forState:UIControlStateNormal];
    [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [_endBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    _endBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _endBtn.layer.cornerRadius = 4;
    _endBtn.layer.masksToBounds = YES;
    [navigationView addSubview:_endBtn];

    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(bianliPlayInfo:) forControlEvents:UIControlEventTouchUpInside];

    [_startBtn addTarget:self action:@selector(showstartPlayView) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn addTarget:self action:@selector(showstartPlayView) forControlEvents:UIControlEventTouchUpInside];

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
        make.right.equalTo(navigationView).offset(6);
        make.centerY.height.width.equalTo(btn);
    }];

    [_startBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn);
        make.bottom.equalTo(navigationView).offset(-6);
    }];

    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_startBtn.mas_right).offset(3);
        make.right.equalTo(_endBtn.mas_left).offset(-3);
        make.centerY.equalTo(_startBtn);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];

    [_endBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(_startBtn);
        make.right.equalTo(okBtn.mas_left).offset(-12);
    }];

    [okBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_endBtn.mas_right).offset(10);
        make.centerY.equalTo(_startBtn);
        make.centerX.equalTo(rightBtn);
//        make.right.equalTo(navigationView).offset(-12);

    }];


    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [navigationView addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(navigationView);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
}
-(void)loadSportMessage:(UIButton *)sender{
//    PersonHistoryVC * history = [[PersonHistoryVC alloc] init];
//    history.beginString = startString;
//    history.endString = endString;
//    history.userId = _userID;
//    history.Persontitle = @"心率明细";
    //    if (_isFamily == YES) {
    //        [self.navigationController pushViewController:history animated:YES];
    //    }else{
//    [self.navigationController pushViewController:history animated:YES];

    SportVC * sport = [[SportVC alloc] init];
    [self.navigationController pushViewController:sport animated:YES];
}

- (void)dismissMyPlayView{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)showstartPlayView{
    XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
        NSLog(@"\n开始时间： %@，结束时间：%@",startDate,endDate);




        [_startBtn setTitle:[startDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

        [_endBtn setTitle:[endDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];


        if (!startDate) {
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            startDate = seven;
            [_startBtn setTitle:[startDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }


        if (!endDate) {
            endDate = [NSDate date];
            [_endBtn setTitle:[endDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }



        if ([self dateStartTime:startDate endTime:endDate] <0) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的时间区间"];
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            return ;
        }

        if ([self dateStartTime:startDate endTime:endDate] >30) {
            [SVProgressHUD showErrorWithStatus:@"请输入小于30天的日期"];
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            
            [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            return;
        }



        if (!startDate) {
            [SVProgressHUD showInfoWithStatus:@"您可以同时选择开始时间"];

            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            return;

        }

        if (!endDate) {
            [SVProgressHUD showInfoWithStatus:@"您可以同时选择结束时间"];


            [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            return;

        }


        startString = [startDate stringWithFormat:@"yyyy-MM-dd"];
        endString = [endDate stringWithFormat:@"yyyy-MM-dd"];
        
    }];
    datepicker.datePickerStyle = DateStyleShowYearMonthDay;
    datepicker.dateType = DateTypeStartDate;
    datepicker.minLimitDate = [NSDate date:@"1990-1-1" WithFormat:@"yyyy-MM-dd"];
    datepicker.maxLimitDate = [NSDate date];
    [datepicker show];
    
}

- (void)bianliPlayInfo:(UIButton *)sender{


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
