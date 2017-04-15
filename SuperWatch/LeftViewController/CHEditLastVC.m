//
//  CHEditLastVC.m
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CHEditLastVC.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "CHEditLastTVCell.h"
#import "UINavigationController+ShowNotification.h"
#import "MyBle.h"
@interface CHEditLastVC ()<UITableViewDelegate , UITableViewDataSource,MyBleDelegate>
{
    BOOL selectChange;
    NSDictionary * selectObject;
    BOOL select_Phone;
    BOOL select_SMS;
}
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic , strong) NSArray * CHEditLastArray;

@end

@implementation CHEditLastVC
static NSString * kCHEditLastTVCell = @"kCHEditLastTVCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCHEditLastNavigationView];
    [self setupCHEditTableView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupMyBleManager];
}

- (void)setupCHEditTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[CHEditLastTVCell class] forCellReuseIdentifier:kCHEditLastTVCell];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _CHEditLastArray = @[@[@"12小时制",@"24小时制"],@[@"来电提醒",@"短信提醒"],@[@"公里（km)",@"米 (m)"],@[@"中文",@"English"]];

    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];

}
/**
 * 设置手环代理
 */
- (void)setupMyBleManager{
    [MyBle sharedManager].delegate = self;
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        //获取总开关状态
        //[self readAncs];
        //获取ANSC分开关状态
        [self claerNotifaction];
        //获取时间模型
        [[MyBle sharedManager] GetTimeMode];
        //获取距离单位
        [self readDistanceUnit];
    }
}
//手环协议
-(void)readAncs{
    uint8_t b[] = {0x59,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int sam = 0;
    for (int j = 0; j < 15; j++) {
        sam +=b[j];
    }
    b[15] = sam;
    NSMutableData * data = [[NSMutableData alloc] initWithBytes:b length:16];
    [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];

}

-(void)readDistanceUnit{
    //距离单位
    [[MyBle sharedManager] GetDistanceUnit];
}
#pragma mark 蓝牙协议

-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI
{

}
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len
{
    switch (buf[0]) {
        case 0x12:// 恢复出厂设置成功回调
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"恢复出厂设置成功!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case 0x22://蓝牙 mac地址
        {
            NSString * strMac = [NSString stringWithFormat:@"蓝牙的MAC地址:%02x%02x%02x%02x%02x%02x",buf[1],buf[2],buf[3],buf[4],buf[5],buf[6]];


        }
            break;
        case 0x27:// 手环的版本号
        {
           //for (int i = 0; i<16; i++)
            //NSLog(@"buf[%d]= 0x%02x",i,buf[i]);
            NSString * strMac = [NSString stringWithFormat:@"当前设备版本行:%x%x%x%x-20%02x%x%02x",buf[1],buf[2],buf[3],buf[4],buf[5],buf[6],buf[7]];


        }
            break;
        case 0x2e:// 重启手环成功
        {


            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"手环重启成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
           [alert show];
        }
            break;
        case 0x3d: // 设置手环名字成功回调
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"设置手环成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case 0x3e:// 获取设备名字成功回调
        {

            NSString * strName = [NSString stringWithFormat:@"设备名字:%c%c%c%c%c%c%c%c%c%c%c%c%c%c",buf[1],buf[2],buf[3],buf[4],buf[5],buf[6],buf[7],buf[8],buf[9],buf[10],buf[11],buf[12],buf[13],buf[14]];

        }
            break;
        case 0x59:
        {
//            SegANCS.selectedSegmentIndex = buf[1];
         //   [self claerNotifaction];
        }
            break;
        case 0x11:
        {
            if ([_Edit_title isEqualToString:@"提醒"]) {
                select_Phone = (buf[1] == 1?YES:NO);
                select_SMS = (buf[3] == 1?YES:NO);
            }
            [_tableView reloadData];
//            switch_Phone.on =(buf[1]==1?YES:NO);
//            switch_Wechat.on =(buf[2]==1?YES:NO);
//            switch_SMS.on =(buf[3]==1?YES:NO);
//            switch_Facebook.on =(buf[4]==1?YES:NO);
//            switch_whatsapp.on =(buf[5]==1?YES:NO);
//            swtich_twitter.on =(buf[6]==1?YES:NO);
//            switch_QQ.on =(buf[7]==1?YES:NO);
        }
            break;

        case CMD_GET_USER_PARAMETER:
        {
            int sex  = buf[1];

            //km
            if (0) {
                int height = buf[3];
                int weight = buf[4];
                int stride = buf[5];//步伐
            }else{//公里
                float height = buf[3]/2.54;
                float weight = buf[4]*2.2046;
                float stride = buf[5]/2.54;
            }

        }
            break;

        case CMD_SET_DISTANCE_UNIT:
        {
            [self.navigationController showNotificationWithString:@"设置距离单位成功"];
        }
            break;
        case CMD_SET_TIME:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"设置时间成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case CMD_SET_USER_PARAMETER:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"设置基础信息成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case CMD_GET_TIME_MODE://时间进制
        {
            NSInteger indexPath = buf[1];//显示当前手环时间进制
           // if (indexPath == 0) {
           //     self.select_result = @"12小时制";
           // }else{
             //   self.select_result = @"";
           // }
        }
            break;
        case CMD_SET_TIME_MODE :
        {

            [self.navigationController showNotificationWithString:@"设置时间模式成功"];
        }
            break;
        case CMD_GET_DISTANCE_UNIT:
        {
            NSInteger indexPath = buf[1];//显示当前手环的距离单位设置
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
    //设置时间格式 和 距离单位
    [[MyBle sharedManager] enable];
}
-(void)SetCenter:(CBCentralManager*)center ble:(CBPeripheral*)myPeripheral
{

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_Edit_title isEqualToString:@"时间"]) {
        return 2;
    }

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CHEditLastTVCell * cell = [tableView dequeueReusableCellWithIdentifier:kCHEditLastTVCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCHEditLastTVCell forIndexPath:indexPath];
    }

    if (indexPath.section ==0) {
        if ([_Edit_title isEqualToString:@"时间"]) {
            cell.title = _CHEditLastArray[0][indexPath.row];

            if ([_select_result isEqualToString:_CHEditLastArray[0][indexPath.row]]) {
                selectObject = @{@"indexPath":indexPath};
                cell.showRight_fun = 1;
            }else{
                cell.showRight_fun = 0;
            }
        }else if ([_Edit_title isEqualToString:@"信息提醒"] || [_Edit_title isEqualToString:@"来电提醒"]){
            cell.title = _CHEditLastArray[1][indexPath.row];
            cell.showRight_fun = 2;
            if ([_Edit_title isEqualToString:_CHEditLastArray[1][indexPath.row]]) {
                cell.first_switch.on = select_Phone;

            }else{
                cell.first_switch.on = select_SMS;
            }
            [cell.first_switch addTarget:self action:@selector(notificationSelect:) forControlEvents:UIControlEventValueChanged];
        }else if ([_Edit_title isEqualToString:@"距离单位"]){
            cell.title = _CHEditLastArray[2][indexPath.row];
            if ([_select_result isEqualToString:_CHEditLastArray[2][indexPath.row]]) {
                selectObject = @{@"indexPath":indexPath};
                cell.showRight_fun = 1;
            }else{
                cell.showRight_fun = 0;
            }
        }else if ([_Edit_title isEqualToString:@"语言"]){
            cell.title = _CHEditLastArray[3][indexPath.row];
            if ([_select_result isEqualToString:_CHEditLastArray[3][indexPath.row]]) {
                selectObject = @{@"indexPath":indexPath};
                cell.showRight_fun = 1;
            }else{
                cell.showRight_fun = 0;
            }

        }else{
            cell.title = @"错误";
            cell.showRight_fun = 0;
        }


    }else{
        cell.showRight_fun = 3;
    }


    if (indexPath.row == 1) {
        cell.isTwo = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if ([_Edit_title isEqualToString:@"时间"]) {
            [self judgeResultIndexPath:indexPath WithIndex:0 About:_Edit_title] ;

        }else if ([_Edit_title isEqualToString:@"信息提醒"]){


        }else if ([_Edit_title isEqualToString:@"距离单位"]){
            [self judgeResultIndexPath:indexPath WithIndex:2 About:_Edit_title];

        }else if ([_Edit_title isEqualToString:@"语言"]){
            [self judgeResultIndexPath:indexPath WithIndex:3 About:_Edit_title];
        }else{
            
        }


    }else{
        if ([_Edit_title isEqualToString:@"时间"]) {
            // indexpath.section == 1
            // 设置手环时间
            [self setBleDeviceTime];
        }

    };

}
//只能二选一;
- (void)judgeResultIndexPath:(NSIndexPath *)indexPath WithIndex:(int)index About:(NSString *)function{
//    if (indexPath.row ==0) {
        NSIndexPath * select_row = selectObject[@"indexPath"];
        if (indexPath.row == select_row.row) {
            return;
        }else{

            self.select_result = _CHEditLastArray[index][indexPath.row];
            if ([function isEqualToString:@"距离单位"]) {
                [self setKmorMile:(int)indexPath.row];
            }else if ([function isEqualToString:@"时间"]){
                [self setTimeChane12or24:(int)indexPath.row];
            }else if ([function isEqualToString:@"语言"]){

            }

            if (_selectResult) {
                _selectResult(_Edit_title,_select_result);
            }
            __weak typeof(self) weakSelf = self;
            [weakSelf.tableView reloadData];
        }


}
//恢复出产设置
-(void)resetDevice{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] reset];
    }
}
//获取手环电量
-(void)GetDeviceLevel{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] GetBatteryLevel];
    }
}
//获取MAC地址
-(void)GetMacAddress{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  GetMacAddress];
    }
}
//获取设备版本号
-(void)GetDeviceVersion{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  getVersion];
    }
}
//重设MCU
- (void)RestDeviceMCU{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  MCUReset];
    }
}

//设置手环名字
-(void)setDeviceName{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] SetDeviceName:[NSString string]];
    }
}

//获取手环名字
-(void)GetDeviceName{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  GetDeviceName];
    }
}
//设置ANCS(闹钟)
-(void)setTotalAlarm{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        //设置闹钟开关
        [[MyBle sharedManager] setTotalAlarm:NO];
    }

}
//设置 距离单位
-(void)setKmorMile:(int)index{
    [[MyBle sharedManager] SetKmAndMile:index];
}
//设置 时间单位
-(void)setTimeChane12or24:(int)index{
    NSLog(@"pppppp%d",index);
    [[MyBle sharedManager] SetTimeChange12And24:index];
}
// 设置 性别 年龄 高度 体重 步幅
-(void)setBleAboutInfo{
    int sex;
    int age;
    int height , weight , stride;
    // 0代表 km 1代表 mile(英里)
    if (0) {

    }else{
        height = ((float)height * 2.54)+0.5;
        weight = (weight * 0.45)+0.5;
        stride = (stride * 2.54)+ 0.5;
    }

    struct INFO info;
    info.gender = sex;
    info.age = age;
    info.heigth = height;
    info.weight = weight;
    info.stride = stride;
    [[MyBle sharedManager] setInfo:info];

    //同时设置最大心率
    [[MyBle sharedManager] SetMaxHeartRate:220 - age];
}

//设置时间
-(void)setBleDeviceTime{
    if([MyBle sharedManager].activePeripheral.state==2){


        NSDate * senddate = [NSDate date];
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond;
        NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
        NSInteger  month  = [conponent month];
        NSInteger  year  = [conponent year];
        NSInteger  day = [conponent day];
        NSInteger  hour = [conponent hour];
        NSInteger  minute = [conponent minute];
        NSInteger  second = [conponent second];

        struct DeviceTime time;
        time.year = (int)year;
        time.month = (int)month;
        time.day = (int)day;
        time.hour = (int)hour;
        time.minute = (int)minute;
        time.second = (int)second;

        [[MyBle sharedManager] setDeviceTime:time];

    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请先连接蓝牙!" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
//获取信息
-(void)getDeviceInfo{
    [[MyBle sharedManager]  getInfo];
}
//设置通知
-(void)SetNotifaction{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        //1.电话通知 2.Wechat(微信) 3.SMS(短信) 4.facebook 5.whatsapp 6.twitter 7.QQ
        uint8_t b[] = {0x10,(select_Phone == YES?1:0),0,(select_SMS == YES?1:0),0,0,0,0,0,0,0,0,0,0,0,0};
        int sam = 0;
        for (int j = 0; j< 15; j++) {
            sam+=b[j];
            b[15] = sam;
            NSMutableData * data = [[NSMutableData alloc] initWithBytes:b length:16];
            [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];
        }
    }
}
//清空通知
-(void)claerNotifaction{
    if([MyBle sharedManager].activePeripheral.state==2){
        uint8_t b[] = {0x11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        int sam = 0;
        for (int j = 0; j < 15; j++)
            sam += b[j];
        b[15] = sam;
        NSMutableData *data = [[NSMutableData alloc] initWithBytes:b length:16];
        [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];
    }
}
-(void)notificationSelect:(UISwitch *)sender{

//    sender.on = !sender.on;
    UIView  * view = sender.superview;

    UIView * view1 = view.superview;

    if ([view1 isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view1];
      //  CHEditLastTVCell * cell = (CHEditLastTVCell *)view1;

        if ([MyBle sharedManager].activePeripheral.state == 2) {
            if (indexPath.row == 1) {
              //  select_Phone =cell.first_switch.on;
                select_Phone = sender.on;
            }else{
               // select_SMS = cell.first_switch.on;
                select_SMS = sender.on;
            }

            //设置短信 和 来电通知
            [self SetNotifaction];
        }else{

            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请打开蓝牙并连接手环" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (sender.on== NO) {
                    sender.on = YES;
                }else{
                    sender.on = NO;
                }
            }];

            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];


        }

//        CHEditLastTVCell * cell =[_tableView dequeueReusableCellWithIdentifier:kCHEditLastTVCell forIndexPath:indexPath];
//

    }

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 25.0f;
    }

    return 12.5f;
};

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)setCHEditLastNavigationView{



    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(9 , 8, 40, 22)];
    label.text = @"返回";
    label.font= [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithHexString:@"565c5c"];

    UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 13, 6, 12)];
    back.image =  [UIImage imageNamed:@"icon_back"];
    back.userInteractionEnabled = YES;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [view addSubview:label];
    [view addSubview:back];


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popCHEditLastCenter:)];
    [view addGestureRecognizer:tap];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    if ([_Edit_title containsString:@"信息"]) {
        self.title = @"信息设置";
    }else{
        self.title = [NSString stringWithFormat:@"%@设置",_Edit_title];
    };


}


- (void)popCHEditLastCenter:(UITapGestureRecognizer *)tap{
    if ([_Edit_title isEqualToString:@"信息提醒"]) {
        if (_selectPSResult) {
            _selectPSResult(select_Phone,select_SMS);
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
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
