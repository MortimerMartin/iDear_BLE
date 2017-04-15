//
//  ViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ViewController.h"

#import "UIColor+HexString.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "Masonry.h"


#import "MMExampleDrawerVisualStateManager.h"
#import "UIView+CLExtension.h"
#import "homeVC.h"
#import "homZVC.h"
#import "LeftViewController.h"
#import "SVProgressHUD.h"
#import "UserCenter.h"

#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+ShowNotification.h"

#import "JPUSHService.h"

//#import "ZYselectDeviceView.h"
#import "ClickViewVC.h"
#import "TDPersonHeadView.h"
#import "WristHeadView.h"
#import "ZYScalesViewController.h"
#import "WristVC.h"
#import "WritShadeView.h"
#import "MyBle.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MyBleDelegate>
{

    float progress; //进度
    float element_S; //电量
    NSString * last_tzl_time; //体质秤上次连接时间
    NSString * connect_sh_status; //手环连接状态
    int goal_sh_step; //手环目标步数
    int  current_sh_step; //当前步数
    int default_goal_step;// 默认目标步数
    NSString * person_tzc_status;

    BOOL synchronize_status;//数据同步
    NSMutableArray * Ble_array;//蓝牙；
}




@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) UIImageView * titleImg;
@property (nonatomic , strong) UILabel * titleName;

@property (nonatomic , strong) NSMutableArray * infoArr;


@property (nonatomic , strong) UIView * shadeView;
@property (nonatomic , strong) UIView * redView;
@property (nonatomic , strong) NSDictionary  * personInfos;


//初始化 选择手环或者体质秤
//@property (nonatomic , strong) ZYselectDeviceView * selectDeviceView;
//手环设备连接状态
@property (nonatomic , strong) WristHeadView * headView;
//体质秤连接状态
@property (nonatomic , strong) TDPersonHeadView * tdpPersonHeadView;
//数据同步视图
@property (nonatomic , strong) WritShadeView * synchronize;//同步

@property (nonatomic , strong) NSMutableArray  * TDPersonArray;

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMExampleCenterControllerRestorationKey"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    //self.navigationController.navigationBar.hidden = YES;

    LeftViewController * left = [[LeftViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    left.isShow = ^(BOOL show , NSString * source,NSString * userName) {
        [weakSelf showView:show];

        if ( source.length == 0 || [source isEqualToString: @""] || source == NULL || source == nil || [source isKindOfClass:[NSNull class]]) {
            if ([UserCenter shareUserCenter].source) {
                [weakSelf.titleImg sd_setImageWithURL:[NSURL URLWithString:[UserCenter shareUserCenter].source]];
            }else{
                weakSelf.titleImg.image = [UIImage imageNamed:@"icon"];
            }

        }else{
             [weakSelf.titleImg sd_setImageWithURL:[NSURL URLWithString:source]];
        }

        if (userName) {
            weakSelf.titleName.text = userName;
        }else{
            weakSelf.titleName.text = [UserCenter shareUserCenter].name ? [UserCenter shareUserCenter].name : @"iDear";
        }

    };
    [self.mm_drawerController setLeftDrawerViewController:left];
    [self setupLeftMenuButton];


//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_F"]) {
//
//        if (_selectDeviceView.hidden == NO) {
//            _selectDeviceView.hidden = YES;
//        }
//    }

    [MyBle sharedManager].delegate = self;
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        //已连接情况下。。
        [self.synchronize pauserTimeAndHidden];
        //获取手环电量
        [[MyBle sharedManager] GetBatteryLevel];
        //获取手环目标步数
        [[MyBle sharedManager] GetGoal];
        //获取数据
        [[MyBle sharedManager] stopGo];
        [[MyBle sharedManager] startGo];
    }else{
        //检查是否有蓝牙被系统蓝牙连上
        NSArray * bleArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0xfff0"]]];
        if (bleArray.count > 0) {

            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MybleConnect"] == YES) {
                [self performSelector:@selector(connectMybleVC) withObject:nil afterDelay:1];
            }


        }else{

            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]) {
                //判断连接状态
                if ([MyBle sharedManager].activePeripheral.state == 2) {
                    //           如果连接
                    //  1. 断开
                    [[MyBle sharedManager] disconnect:[MyBle sharedManager].activePeripheral];
                    //  2. 连接
                    [self performSelector:@selector(ScanMyFitble) withObject:nil afterDelay:1];
                }else{
                    //            未连接
                    [self performSelector:@selector(ScanMyFitble) withObject:nil afterDelay:1];
                }
            }
        }
    }

}


- (void)ScanMyFitble{


    //检查是否有蓝牙被系统蓝牙连上
    NSArray * bleArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"0xfff0"]]];
    if (bleArray.count > 0) {

        [self performSelector:@selector(connectMybleVC) withObject:nil afterDelay:2];

        return;
    }


    [[MyBle sharedManager] findBLEPeripheralsWithRepeat:YES];

    
    
}

/**
 *  连接 手环
 */
- (void)connectMybleVC{

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

#pragma mark BLE Delegate
-(void)FindDeviceWithDevice:(CBPeripheral *)device RSSI:(NSNumber *)RSSI{

    int value = RSSI.intValue;

    if (value<0 && value>=-70) {
        NSString * strName = device.name;
        if (strName.length == 0) {
            strName = @"LOVE LIFE-iDear";
        }

        if (![Ble_array containsObject:device]) {

            [Ble_array addObject:device];

        }


            //停止扫描
            [[MyBle sharedManager].CM stopScan];
            //连接设备
            [[MyBle sharedManager] connectPeripheral:[Ble_array objectAtIndex:0]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MybleConnect"];


        synchronize_status = YES;
    }

    synchronize_status = NO;
}

//开始通信
-(void)DisplayRece:(Byte *)buf length:(int)len{
    switch (buf[0]) {
   

        case CMD_GET_POWER:
        {//获得电量
            element_S = buf[1] * 20;
            NSLog(@"电量%f",element_S);
            _headView.element_D = element_S;
        }
            break;


        case CMD_GET_GOAL://获取目标步数
        {
            int goal = buf[1]*256*256 + buf[2]*256+buf[3];
            goal_sh_step = goal;
            _headView.finish_b = goal_sh_step;

        }
            break;

        case CMD_BEGIN_SEND_STEP://开始时时记步
        {
            //步数
            current_sh_step = buf[1]*256*256+buf[2]*256+buf[3];
            _headView.current_b = current_sh_step;

            if (goal_sh_step) {
                progress = (float)current_sh_step/goal_sh_step;
            }else{
                progress = (float)current_sh_step/default_goal_step;
            }



            _headView.progress = progress;

            connect_sh_status = @"已连接";

            _headView.connect_status = connect_sh_status;

            [[MyBle sharedManager] GetBatteryLevel];//电量

            synchronize_status = YES;
            [_synchronize pauseWritTimer:@"数据同步完成"];
            [_synchronize pauserTimeAndHidden];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            goal_sh_step = buf[4]+buf[5]*256+buf[6]*256*256;
//            _headView.finish_b = goal_sh_step;
        }
            break;
        default:
            break;
    }
}

//断开连接
-(void)Disconnected{
    [self.navigationController showNotificationWithString:@"断开连接"];
    connect_sh_status = @"断开连接";
    _headView.connect_status = connect_sh_status;
}

//开始
-(void)start{
    connect_sh_status = @"已连接";
    _headView.connect_status = connect_sh_status;
    [[MyBle sharedManager] enable];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MybleConnect"];
    //获取手环电量
    [[MyBle sharedManager] GetBatteryLevel];
    //获取手环目标步数
    [[MyBle sharedManager] GetGoal];
    //获取数据
    [[MyBle sharedManager] startGo];

    synchronize_status = YES;
}

//设置 蓝牙管理中心
-(void)SetCenter:(CBCentralManager *)center ble:(CBPeripheral *)myPeripheral{
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.mm_drawerController setLeftDrawerViewController:nil];
    [self.navigationItem setLeftBarButtonItems:nil animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    current_sh_step = 0;
    goal_sh_step = 0;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"showRed" object:nil];

     [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    //改变导航栏
    [self setupNavigation];

    //设置首页
    [self setupVCtableView];



    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"]) {


        synchronize_status = NO;

        _synchronize = [[WritShadeView alloc] initWithFrame:_tableView.frame];
        [self.view addSubview:_synchronize];
        [_synchronize startWritTimer];

        Ble_array = [[NSMutableArray alloc] init];
        dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));

        dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
            if (synchronize_status == YES) {
                if (_shadeView.hidden == NO) {
                    [_synchronize pauseWritTimer:@"数据同步完成"];
                }else{

                    [_synchronize pauseWritTimer:@"数据同步完成"];
                }
            }else{
                [_synchronize pauseWritTimer:@"数据同步超时"];
                
            }
            
            
            
            
        });
    }


    if ([MyBle sharedManager].activePeripheral.state !=2) {
        [[MyBle sharedManager] CentralManagerSetUp];
    }

    //添加遮盖
    [self addLeftDrawShadeView];



    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];

}

/*
 * * *** ** * * ** *** * /  >|< 设置首页 >|<  \ * *** ** * ** *** *
 */

- (void)setupVCtableView{

    person_tzc_status = @"标准";
    default_goal_step = 10000;
    _TDPersonArray = [NSMutableArray array];//WithArray:@[@"20.1(标准)",@"172cm",@"54kg(标准)",@"14.9%(偏瘦)"]

    _tableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
     _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    // 5.设置分割线样式
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 6.隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * kTableViewNULL = @"kTableViewNULL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTableViewNULL];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kTableViewNULL forIndexPath:indexPath];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{



    if (section == 0) {

        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_SH"]) {

            _headView = [[WristHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 232)];
//            _headView.backgroundColor = [UIColor whiteColor];
            _headView.SHFill = NO;
            _headView.connect_status = connect_sh_status;
            _headView.progress = progress;
            _headView.element_D = element_S;

            _headView.current_b= current_sh_step;

            _headView.finish_b = goal_sh_step;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SDeviceViewF)];
            [_headView addGestureRecognizer:tap];
            return _headView;
        }else{
            ClickViewVC * clickView = [[ClickViewVC alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
            
            clickView.tableView_section = 0;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SDeviceViewF)];
            [clickView addGestureRecognizer:tap];
            return clickView;
            
        }


    }else if (section == 1){

        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_TZC"]) {
            _tdpPersonHeadView = [[TDPersonHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 232.0 - 64)];
            last_tzl_time = [self GetLastTZCConnectTime];
            if (!last_tzl_time) {
                last_tzl_time = @"";
            }
            _tdpPersonHeadView.time_connect = last_tzl_time; //上次连接时间
            _tdpPersonHeadView.person_status = person_tzc_status;//身体状况 更换图片
            _tdpPersonHeadView.personInfo = _TDPersonArray; //用户简略数据（bmi height weight tzl）

            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TDeviceViewF)];
            [_tdpPersonHeadView addGestureRecognizer:tap];
            return _tdpPersonHeadView;
        }else{
            ClickViewVC * clickView1 = [[ClickViewVC alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 60.0 - 64)];
            clickView1.tableView_section = 1;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TDeviceViewF)];
            [clickView1 addGestureRecognizer:tap];
            return clickView1;
        }


    }

    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_SH"]) {
            return 232.0f;
        }else{
            return 60.0f;
        }
    }else if (section == 1){
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_TZC"]) {

            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_SH"]) return [UIScreen mainScreen].bounds.size.height - 232.0f - 64.0;

            return [UIScreen mainScreen].bounds.size.height - 60.0f - 64.0;


        }else{

            return  [UIScreen mainScreen].bounds.size.height - 60.0f - 64.0;
        }

    }

    return 380.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
/*   ~~~~~~   * * *   择   * * *  备   * *** ** *
 * * ** *** *   选   * * *   设  * * *   ~~~~~~~
 */
//- (void)addZYSelectDeviceView{
//    _selectDeviceView = [[ZYselectDeviceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:_selectDeviceView];
//
//    [_selectDeviceView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.view).offset(64);
//    }];
//    UITapGestureRecognizer * Stap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SDeviceViewF)];
//    [_selectDeviceView.topView addGestureRecognizer:Stap];
//
//    UITapGestureRecognizer * Ttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TDeviceViewF)];
//    [_selectDeviceView.bottomView addGestureRecognizer:Ttap];
//
//};

//........SH..........//
- (void)SDeviceViewF{

//    [[NSUserDefaults standardUserDefaults] setValue:@"clickF" forKey:@"Click_F"];
    [[NSUserDefaults standardUserDefaults] setValue:@"clickSH" forKey:@"Click_SH"];
    WristVC * wrist = [[WristVC alloc] init];
    wrist.current_step_Y = current_sh_step;
    wrist.progress_L = progress;
    wrist.finish_step_E = goal_sh_step;
    wrist.power_V = element_S;
    wrist.connect_O = connect_sh_status;
    
    wrist.Wrist_block = ^(NSArray * data){
        element_S = [data[0] intValue];
        current_sh_step = [data[1] intValue];
        goal_sh_step = [data[2] intValue];
        progress = [data[3] doubleValue];
        connect_sh_status = data[4];

        _headView.connect_status = connect_sh_status;
        _headView.progress = progress;
        _headView.element_D = element_S;

        _headView.current_b= current_sh_step;

        _headView.finish_b = goal_sh_step;

        [_tableView reloadData];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:wrist animated:YES];

}

//......TZC............//
- (void)TDeviceViewF{
//    [[NSUserDefaults standardUserDefaults] setValue:@"clickF" forKey:@"Click_F"];
    [[NSUserDefaults standardUserDefaults] setValue:@"clickTZC" forKey:@"Click_TZC"];
    ZYScalesViewController * zys = [[ZYScalesViewController alloc] init];
    zys.reloadInfo = ^(NSString * name, NSString * imgURL){
        _titleName.text = name;
        [_titleImg sd_setImageWithURL:[NSURL URLWithString:imgURL]];
        last_tzl_time = [self GetLastTZCConnectTime];
        _tdpPersonHeadView.time_connect = last_tzl_time;


    };

//    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"Click_TZC"]) {
        zys.reloadTableview = ^{

            [_tableView reloadData];
        };
//    }
    [self.navigationController pushViewController:zys animated:YES];

}
/**
 *   获取上次连接时间  上传到服务器
 */
- (NSString*)GetLastTZCConnectTime{

    NSDate * lastdate = [[NSUserDefaults standardUserDefaults]  objectForKey:@"LastTlC_history"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-mm-dd HH:mm:ss";
    return  [formatter stringFromDate:lastdate];
}
/**
 * ** ** 遮盖 ** ** *
 **/
- (void)addLeftDrawShadeView{
    _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
    _shadeView.backgroundColor = RGBA(0, 0, 0, 0.75);

    [self.view addSubview:_shadeView];

//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//
//    [keyWindow addSubview:_shadeView];

    _shadeView.hidden = YES;
}



- (void)showView:(BOOL)show{

    if (show) {

        [UIView animateWithDuration:0.1 animations:^{
            _shadeView.alpha= 0.75;
            self.navigationController.navigationBar.hidden = YES;
            }completion:^(BOOL finished) {
            _shadeView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            _shadeView.alpha= 0;
            self.navigationController.navigationBar.hidden = NO;
        }completion:^(BOOL finished) {
            _shadeView.hidden = YES;
        }];
    }

}

//JPUSH通知
- (void)getNotification:(NSNotification *)sender{

    NSDictionary * dict = sender.userInfo;
    if ([dict[@"VCShow"] boolValue] == YES) {
        _redView.hidden = NO;
    }else{
        _redView.hidden = YES;
    }

    if ([dict[@"messageType"] isEqualToString:@"104"]) {

//        [self.navigationController showNotificationWithString:@"您被踢出家庭组"];
        [UserCenter shareUserCenter].homenumer = nil;
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"UserHomeNumber"];

    }else if ([dict[@"messageType"] isEqualToString:@"103"]){

//        [self.navigationController showNotificationWithString:@"您的申请已被审批"];
    }else if ([dict[@"messageType"] isEqualToString:@"101"]){

//        [self.navigationController showNotificationWithString:@"您的资料被修改"];
    }else if ([dict[@"messageType"] isEqualToString:@"102"]){
//        [self.navigationController showNotificationWithString:@"您有新的成员申请"];
    }else{

    }

}






//侧滑 和 点击事件
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}
// 家庭组
- (void)pushHomeView:(UIButton *)sender{


    [self loadDoQueryHomeNo];
  




}

/**
 *  体脂秤数据
 */
-(void)loadDataAboutTZCIinfo{
    NSDictionary * dict = @{};
    __weak typeof(self) weakSelf = self;
    [[DataManager manager ]postDataWithUrl:@"doAddBodyFat" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

            [weakSelf.TDPersonArray removeAllObjects];

            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"bmi"]];

            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"height"]];
            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"weight"]];
            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"bodyFat"]];
            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"muscleMass"]];
//            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"bodyWater"]];
//            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"bone"]];
//            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"visceralFat"]];
//            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"bmr"]];
//            [weakSelf.TDPersonArray addObject:dict1[@"data"][@"age"]];

            [weakSelf.tableView reloadData];

        }

    } failure:^(NSError *error) {

    }];

}
//家庭组 判断
- (void)loadDoQueryHomeNo{
    NSDictionary * dict = @{@"userId":@([[UserCenter shareUserCenter].userId intValue])};

    [[DataManager manager] postDataWithUrl:@"doQueryHomeNo" parameters:dict success:^(id json) {
        NSDictionary * dict1 =json;

        if (dict1[@"message"] == NULL || [dict1[@"message"] isKindOfClass:[NSNull class]] || dict1[@"message"] == nil || [dict1[@"message"] isEqualToString:@""]) {
            [UserCenter shareUserCenter].homenumer = nil;
            [[NSUserDefaults standardUserDefaults] setValue: [UserCenter shareUserCenter].homenumer forKey:@"UserHomeNumber"];
        }

    } failure:^(NSError *error) {


    }];


    if (![UserCenter shareUserCenter].homenumer) {
        homeVC * home = [[homeVC alloc] init];
        [self.navigationController pushViewController:home animated:YES];
    }else{
        homZVC * homeZ = [[homZVC alloc] init];
        homeZ.reloadNH = ^(NSString * name,NSString * head){
            if (name) {
                _titleName.text = name;
            }else{
                _titleName.text= [UserCenter shareUserCenter].name ? [UserCenter shareUserCenter].name : @"iDear";
            }

            if (head) {
                [_titleImg sd_setImageWithURL:[NSURL URLWithString:head]];
            }else{

                if ([UserCenter shareUserCenter].source) {
                    [_titleImg sd_setImageWithURL:[NSURL URLWithString:[UserCenter shareUserCenter].source]];

                }else{
                    _titleImg.image = [UIImage imageNamed:@"icon"];
                }
            }


        };
        [self.navigationController pushViewController:homeZ animated:YES];
    }
}

-(void)setupLeftMenuButton{
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];


    UIButton * buttonView = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 26, 26)];
    [buttonView addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView setImage: [UIImage imageNamed:@"nav_btn_person"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];


}
//**< 修改字体颜色及字体大小 >**//
- (void)setupNavigation{


    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UIView * view = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 160, 40)];
    //    view.backgroundColor = [UIColor redColor];
    _titleImg = [[UIImageView alloc] init];
//    _titleImg.backgroundColor = [UIColor orangeColor];
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

    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage: [UIImage imageNamed:@"nav_btn_family"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pushHomeView:) forControlEvents:UIControlEventTouchUpInside];
    _redView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 8, 8)];
    _redView.layer.cornerRadius = 4;
    _redView.layer.masksToBounds = YES;
    _redView.backgroundColor = [UIColor colorWithHexString:@"#f3471f"];
    _redView.hidden = YES;
    [rightBtn addSubview:_redView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];


//    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//    [doubleTap setNumberOfTapsRequired:2];
//    [self.view addGestureRecognizer:doubleTap];
//
//    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
//    [twoFingerDoubleTap setNumberOfTapsRequired:2];
//    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
//    [self.view addGestureRecognizer:twoFingerDoubleTap];



    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

//添加动画
//- (void)addZYAnimationView{
//    _animationView = [[SearchAnimationView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:_animationView];
//}
//移除动画
//- (void)removeZYAnimationView{
//
//    [_animationView pauserTimer];
//
//    [_animationView removeFromSuperview];
//
//    [self addZYDeviceListView];
//
//}

//- (void)addZYDeviceListView{
//    _deviceListView = [[DeviceListView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:_deviceListView];
//    [_deviceListView reloadDeviceListView:nil WithPeripheral:nil];
//}

// JPUSHService
- (void)networkDidLogin:(NSNotification *)notification {

    NSLog(@"已登录");


    if ([UserCenter shareUserCenter].userId == nil) {
        return;
    }

    NSString *aliasKey = [NSString stringWithFormat:@"%@", [UserCenter shareUserCenter].userId];
    NSLog(@"aliasKey = %@",aliasKey);

    [JPUSHService setTags:[NSSet set]  alias:[aliasKey lowercaseString] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];


}


- (void)dealloc {
    [self unObserveAllNotifications];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showRed" object:nil];

}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
