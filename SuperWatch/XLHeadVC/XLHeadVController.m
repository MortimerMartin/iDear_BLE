//
//  XLHeadVController.m
//  SuperWatch
//
//  Created by pro on 17/3/5.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "XLHeadVController.h"
#import "XLHeadDescriptView.h"
#import "XLHeadView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "XLVC.h"
#import "MyBle.h"
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface XLHeadVController ()<UITableViewDelegate , UITableViewDataSource , MyBleDelegate>
{
    NSString * startString;//开始时间
    NSString * endString;

    NSDate * select_time;

    int Max_head_value;//最大值
    int Min_head_value;//最小值
    int Ave_head_value;//平均数

    int reloadSection;
}
@property (nonatomic ,strong)UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * headValuesArray;
@property (nonatomic , strong) NSMutableArray * headValuesDateArray;

@property (nonatomic , strong) UILabel * timeLabel;

@end

@implementation XLHeadVController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyBle sharedManager].delegate = self;
    if ([MyBle sharedManager].activePeripheral.state == 2) {
          [[MyBle sharedManager] ReadHistoryHeartRateWithNumber:0];
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupXLHeadDView];
    [self setXLNavigationView];
    reloadSection = 0;
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
        case CMD_GET_HISTORY_HEARTRATE://获取历史心率数据
        {
            int year   =  (buf[2]-buf[2]/16*6)+2000;
            int month  =  (buf[3]-buf[3]/16*6);
            int day    =  (buf[4]-buf[4]/16*6);
            int hour   =  (buf[5]-buf[5]/16*6);
            int minute = (buf[6]-buf[6]/16*6);
            NSString * strData1 = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",buf[7],buf[8],buf[9],buf[10],buf[11],buf[12]];
            NSString * strData2 = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",buf[13],buf[14],buf[15],buf[16],buf[17],buf[18]];
            NSString * textStr =[NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d (%@,%@)\n",year,month,day,hour,minute,strData1,strData2];

            if ([self.timeLabel.text isEqualToString:[NSString stringWithFormat:@"%d-%02d-%02d",year,month,day]]) {
                [_headValuesDateArray addObject:[NSString stringWithFormat:@"%02d:%02d",hour,minute]];

                NSArray * values = [self ComparatorArray:@[@(buf[7]),@(buf[8]),@(buf[9]),@(buf[10]),@(buf[11]),@(buf[12]),@(buf[13]),@(buf[14]),@(buf[15]),@(buf[16]),@(buf[17]),@(buf[18])]];

                Ave_head_value = (buf[7]+buf[8]+buf[9]+buf[10]+buf[11]+buf[12]+buf[13]+buf[14]+buf[15]+buf[16]+buf[17]+buf[18])/values.count;
                //时间段里的平均心率值
                [_headValuesArray addObject:@(Ave_head_value)];
                if (Ave_head_value > [[[NSUserDefaults standardUserDefaults] valueForKey:@"Ave_head_value"] intValue]) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(Ave_head_value) forKey:@"Ave_head_value"];

                }

                Max_head_value = [values.lastObject intValue];
                if (Max_head_value > [[[NSUserDefaults standardUserDefaults] valueForKey:@"Max_head_value"] intValue]) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(Max_head_value) forKey:@"Max_head_value"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%02d:%02d",hour,minute] forKey:@"Max_value_time"];
                }
                Min_head_value = [values.firstObject intValue];
                if (Min_head_value > [[[NSUserDefaults standardUserDefaults] valueForKey:@"Min_head_value"] intValue]) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(Min_head_value) forKey:@"Min_head_value"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%02d:%02d",hour,minute] forKey:@"Min_value_time"];
                }


                reloadSection = 0;
            }else{
                if (reloadSection == 0) {
                    [_tableView reloadData];
                }
                reloadSection++;

            }
            NSLog(@"headData%@",textStr);

        }
            break;
        default:
            break;
    }

}

//数组排序
- (NSArray *)ComparatorArray:(NSArray *)arr{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };

    return  [arr sortedArrayUsingComparator:cmptr];
    
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

- (void)setupXLHeadDView{

    _headValuesArray = [NSMutableArray arrayWithArray:@[@80,@90,@60,@120,@101]];
    _headValuesDateArray = [NSMutableArray arrayWithArray:@[@"10:00",@"11:25",@"12:00",@"16:00",@"14:00"]];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

}


- (void)setXLNavigationView{
    UIView * navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    [navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(107);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
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
    tilte.text = @"我的心率";
    [navigationView addSubview:tilte];

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(loadXLMessage:) forControlEvents:UIControlEventTouchUpInside];


    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    leftButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [navigationView addSubview:leftButton];

    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
     [navigationView addSubview:rightButton];

    _timeLabel = [[UILabel alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    select_time = [NSDate date];
    _timeLabel.text = [formatter stringFromDate:select_time];
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

    [rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navigationView).offset(-4);
        make.centerY.height.width.equalTo(btn);
    }];

    [tilte mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navigationView);
        make.centerY.equalTo(btn);
        make.height.mas_equalTo(30);
        make.height.mas_equalTo(90);
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

-(void)loadXLMessage:(UIButton *)sender{

//    PersonHistoryVC * history = [[PersonHistoryVC alloc] init];
//    history.beginString = startString;
//    history.endString = endString;
//    history.userId = _userID;
//    history.Persontitle = @"心率明细";
    //    if (_isFamily == YES) {
    //        [self.navigationController pushViewController:history animated:YES];
    //    }else{
//    [self.navigationController pushViewController:history animated:YES];
    XLVC * xlvc = [[XLVC alloc] init];
    [self.navigationController pushViewController:xlvc animated:YES];
}



-(void)leftReloadXLHeadView{

    NSTimeInterval  oneTime = -24*60*60;
    NSDate * yesterday = [select_time dateByAddingTimeInterval:oneTime];
    select_time = yesterday;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _timeLabel.text = [formatter stringFromDate:yesterday];
}

- (void)rightReloadXLHeadView{

    NSTimeInterval  oneTime = 24*60*60;
    NSDate * tomorrow = [select_time dateByAddingTimeInterval:oneTime];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:tomorrow];
    if (time<= -86000) {
        return;
    }
    
    select_time = tomorrow;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _timeLabel.text = [formatter stringFromDate:tomorrow];
}
- (void)popXLHeadView{

    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XLHeadVCell"];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        XLHeadView  * xlheadView = [[XLHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 196)];
        xlheadView.name = @"心率";
        xlheadView.content = @"84";
        xlheadView.values = _headValuesArray;
        xlheadView.dates = _headValuesDateArray;
        xlheadView.color = [UIColor colorWithHexString:@"#fb5cb9"];
        [xlheadView refreshView];
        return xlheadView;
    }else if (section == 1) {
        XLHeadDescriptView * descriptView = [[XLHeadDescriptView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 108)];

        descriptView.left_head = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Ave_head_value"] intValue]] ? [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Ave_head_value"] intValue]] : @"0";
        descriptView.mid_head = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Max_head_value"] intValue]] ? [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Max_head_value"] intValue]] : @"0";
        descriptView.right_head = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Min_head_value"] intValue]] ? [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Min_head_value"] intValue]] : @"0";
        descriptView.left_time = _timeLabel.text;
        descriptView.mid_time =  [[NSUserDefaults standardUserDefaults] objectForKey:@"Max_value_time"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Max_value_time"] : @"00:00";
        descriptView.right_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"Min_value_time"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Min_value_time"] : @"00:00";
        return descriptView;
    }

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 200.f;
    }
    return 108.f;
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
