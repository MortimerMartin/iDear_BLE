//
//  CHEditVC.m
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CHEditVC.h"
#import "UIColor+HexString.h"
#import "PersonInfoCell.h"
#import "Masonry.h"
#import "CHEditLastVC.h"
#import "CHSHEditVC.h"
#import "MyBle.h"
@interface CHEditVC ()<UITableViewDelegate , UITableViewDataSource,MyBleDelegate>
{
    NSString * timeModel; // 12 or 24
    NSString * KmorMile;  // km of mile
    NSString * MSM_status; //信息提醒
    NSString * DS_status; // 定时提醒

    BOOL phone_notification;
    BOOL sms_notification;
}
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic , strong) NSArray * leftCHEditArray;
@property (nonatomic , strong) NSArray * rightCHEditArray;

@end

@implementation CHEditVC

static NSString * kLeftCHEditTableViewCell = @"kLeftCHEditTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCHEditNavigationView];
    [self setupCHEditTableView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyBle sharedManager].delegate = self;
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        //获取时间格式
        [[MyBle sharedManager] GetTimeMode];
        //获取运动单位
        [[MyBle sharedManager] GetDistanceUnit];
        //获取通知
        [self GetNotifaction];
    }
}

/****   * ** * ** * ** *         <*      1  1  1      *>
 *  /    * *  * *  * *        <*    获取通知并改变通知状态   *>
 * /      *    *    *            <*                   *>
 */
-(void)GetNotifaction{
    uint8_t b[] = {0x11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int sam = 0;
    for (int j = 0; j < 15; j++)
        sam += b[j];
    b[15] = sam;
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:b length:16];
    [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];

}

- (void)setupCHEditTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PersonInfoCell class] forCellReuseIdentifier:kLeftCHEditTableViewCell];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftCHEditArray = @[@[@"时间",@"语言",@"距离单位"],@[@"信息提醒",@"提醒"],@[@"硬件信息"],@[@"手环解绑"]];
    _rightCHEditArray=@[@[@"24小时制",@"中文",@"公里（km)"],@[@"开",@"开"]];

    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _leftCHEditArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_leftCHEditArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:kLeftCHEditTableViewCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLeftCHEditTableViewCell forIndexPath:indexPath];
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.showTopLine = YES;
        }
        if (indexPath.row == 2) {
            cell.info_name = [NSString stringWithFormat:@"步行%@",_leftCHEditArray[indexPath.section][indexPath.row]];
        }else{
            cell.info_name = [NSString stringWithFormat:@"%@设置",_leftCHEditArray[indexPath.section][indexPath.row]];
        }

    }else if (indexPath.section == 1){

        if (indexPath.row == 0) {
            cell.showTopLine = YES;
            cell.info_name =_leftCHEditArray[indexPath.section][indexPath.row];
        }else{
            cell.info_name = [NSString stringWithFormat:@"定时%@",_leftCHEditArray[indexPath.section][indexPath.row]];
        }
    }else  {
        cell.showTopLine = YES;
        cell.info_name = _leftCHEditArray[indexPath.section][indexPath.row];
    }

    if (indexPath.section !=2 && indexPath.section !=3) {

        cell.info = _rightCHEditArray[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            if (indexPath.row == 0 && timeModel) {
                cell.info = timeModel;
            }
            if (indexPath.row == 2 && KmorMile) {
                cell.info = KmorMile;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0 && MSM_status) {
                cell.info = MSM_status;
            }

        }

    }




    cell.selectionStyle  =  UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 12.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    return view;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CHEditLastVC * lastVc = [[CHEditLastVC alloc] init];
        lastVc.selectResult = ^(NSString * select_fun, NSString * select_content){

        };


        lastVc.Edit_title = _leftCHEditArray[indexPath.section][indexPath.row];


        if (indexPath.row == 0) {
            if (!timeModel) {
                lastVc.select_result = _rightCHEditArray[indexPath.section][indexPath.row];
            }else{
                lastVc.select_result = timeModel;
            }

        }else if (indexPath.row == 1){

        }else if (indexPath.row == 2){
            if (!KmorMile) {
                lastVc.select_result = _rightCHEditArray[indexPath.section][indexPath.row];
            }else{
                lastVc.select_result = KmorMile;
            }

        }else{

        }
        [self.navigationController pushViewController:lastVc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        CHEditLastVC * lastVc = [[CHEditLastVC alloc] init];
        lastVc.selectPSResult = ^(BOOL phone,BOOL sms){
            phone_notification = phone;
            sms_notification = sms;
            if (phone_notification == YES || sms_notification == YES) {
                MSM_status =@"开";
            }else{
                MSM_status = @"关";
            }
            [_tableView reloadData];
        };

        lastVc.Edit_title = _leftCHEditArray[indexPath.section][indexPath.row];

        lastVc.phone_notification = phone_notification;
        lastVc.sms_notification = sms_notification;

        [self.navigationController pushViewController:lastVc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row ==1){

    }else if (indexPath.section  ==2){
        CHSHEditVC * shedit = [[CHSHEditVC alloc] init];
        [self.navigationController pushViewController:shedit animated:YES];
    }else{

        if ([MyBle sharedManager].activePeripheral.state == 2) {
            [[MyBle sharedManager] setTotalAlarm:0];
        }
    }

}

- (void)setCHEditNavigationView{



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


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCHEditCenter:)];
    [view addGestureRecognizer:tap];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    self.title = @"手环设置";

}

#pragma mark bleDelegate

-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI
{

}
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len
{

    switch (buf[0]) {
        case CMD_GET_TIME_MODE://获得时间模式
        {
            if (buf[1] == 0) {
                timeModel = @"12小时制";
            }else if (buf[1] == 1){
                timeModel = @"24小时制";
            }else{
                timeModel = @"信息错误";
            }
            [_tableView reloadData];
        }
            break;
        case CMD_GET_DISTANCE_UNIT://获得距离单位
        {
            if (buf[1] == 0) {
                KmorMile = @"公里（km)";
            }else if (buf[1] == 1){
                KmorMile = @"米 (m)";
            }else{
                KmorMile = @"信息错误";
            }
            [_tableView reloadData];
        }
            break;
        case CMD_GET_ANCS_DETAIL: //获取ANSC分开关状态
        {   // 1. 来电通知  2. 信息通知
            if (buf[1] == 1 || buf[3] == 1) {
                MSM_status = @"开";
                if (buf[1]==1) {
                    phone_notification = YES;
                }

                if (buf[3] == 1) {
                    sms_notification = YES;
                }
            }else{
                MSM_status = @"关";
            }

            [_tableView reloadData];
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
- (void)dismissCHEditCenter:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
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
