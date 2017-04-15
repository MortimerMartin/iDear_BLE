//
//  SetocVC.m
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SetocVC.h"
#import "UIColor+HexString.h"
#import "SetocCell.h"
#import "MyBle.h"
#import "UINavigationController+ShowNotification.h"
#define kSetocCell @"kSetocCell"
@interface SetocVC ()<UITableViewDelegate , UITableViewDataSource,MyBleDelegate>
{
    int status;
    BOOL connect_status;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSArray * setArray;

@end

@implementation SetocVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyBle sharedManager].delegate = self;
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        connect_status = YES;
    }else{
        connect_status = NO;
    }
}

- (void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[SetocCell class] forCellReuseIdentifier:kSetocCell];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    [self.view addSubview:_tableView];
    _setArray = @[@"手环检测",@"心率检测",@"睡眠检测"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _setArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetocCell * cell = [tableView dequeueReusableCellWithIdentifier:kSetocCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSetocCell forIndexPath:indexPath];
    }
    cell.set_name = _setArray[indexPath.row];
    cell.lineHidden =(int)indexPath.row;
    if (indexPath.row == 0) {
        cell.setOpenBtn.on = connect_status;
    }else if (indexPath.row == 1){
               
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"startHeartRateMode"]) {
            cell.setOpenBtn.on = YES;
        }else{
            cell.setOpenBtn.on = NO;
        }

    }
    [cell.setOpenBtn addTarget:self action:@selector(sendHCommond:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    return view;
}
- (void)setupNavView{

    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popSetocView) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets= UIEdgeInsetsMake(0, -25, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};
    
    self.title = @"开关设置";
}

- (void)sendHCommond:(UISwitch *)sender{
//    sender.selected= ! sender.selected;
    UIView  * view = sender.superview;

    UIView * view1 = view.superview;

    if ([view1 isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view1];
        if (indexPath.row == 0) {
            status = 0;
            if ([sender isOn] == NO) {
                if ([MyBle sharedManager].activePeripheral.state == 2) {
                    [[MyBle sharedManager] disconnect:[MyBle sharedManager].activePeripheral];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MybleConnect"];
                }
            }else{
                if ([MyBle sharedManager].activePeripheral.state != 2) {
                    CBUUID * uuid = [CBUUID UUIDWithString:@"fff0"];
                    NSArray * peripheralArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[uuid]];
                    if (peripheralArray.count>0) {
                        [[MyBle sharedManager] connectPeripheral:peripheralArray[0]];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MybleConnect"];
                    }else{

                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请打开蓝牙并扫描设备" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            sender.on = NO;
                        }];

                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];

                    }
                }
            }


        }else if(indexPath.row == 1){
            status = 1;
            if ([sender isOn] == NO) {
                //关闭时时心率
                if ([MyBle sharedManager].activePeripheral.state == 2) {
                    [[MyBle sharedManager] StopHeartRateMode];
                            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"startHeartRateMode"];
                }
            }else{
                if ([MyBle sharedManager].activePeripheral.state == 2) {
//                    [[MyBle sharedManager] StopHeartRateMode];
//                    [self StartHeartRate];
                    [[MyBle sharedManager] StartHeartRateMode];
                    [[NSUserDefaults standardUserDefaults] setValue:@"startHeartRateMode" forKey:@"startHeartRateMode"];
                }else{
                    CBUUID * uuid = [CBUUID UUIDWithString:@"fff0"];
                    NSArray * peripheralArray = [[MyBle sharedManager].CM retrieveConnectedPeripheralsWithServices:@[uuid]];
                    if (peripheralArray.count <1) {
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请打开蓝牙并扫描设备" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            sender.on = NO;
                        }];

                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                    }

                }



            }

        }else if (indexPath.row == 2){

        }else{

        }
//        if (sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"btn_open_def"] forState:UIControlStateNormal];
//            [sender setImage:[UIImage imageNamed:@"btn_open_pre"] forState:UIControlStateHighlighted];
//        }else{
//            [sender setImage:[UIImage imageNamed:@"btn_close_def"] forState:UIControlStateNormal];
//            [sender setImage:[UIImage imageNamed:@"btn_close_pre"] forState:UIControlStateHighlighted];
//        }

    }


}
- (void)popSetocView{

    if (_resetTimerBlock) {
        _resetTimerBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *
 *
 *
 **
 *
 *
 *
 */

-(void)StartHeartRate{
    uint8_t b[] = {0x19,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0x19+1};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:b length:16];
    [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];


}
#pragma mark bleDelegate

-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI
{


}
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len
{
    switch (buf[0]) {
        case CMD_HEARTRATE_MODE:
        {

            if (buf[1] == 1) {

                uint8_t b[] = {0x2c,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
                NSLog(@"22223332");
                int sam = 0;
                for (int i = 0; i<15; i++) {
                    sam +=b[i];
                }
                NSMutableData * data = [[NSMutableData alloc] initWithBytes:b length:16];
                [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];
            }else{

                uint8_t b[] = {0x2c,buf[1],0,0,0,0,0,0,0,0,0,0,0,0,0,0};
                NSLog(@"22222");
                int sam = 0;
                for (int i = 0; i<15; i++) {
                    sam +=b[i];
                }
                NSMutableData * data = [[NSMutableData alloc] initWithBytes:b length:16];
                [[MyBle sharedManager] writeValue:0xfff0 characteristicUUID:0xfff6 p:[MyBle sharedManager].activePeripheral data:data];
            }

        }
            break;




        default:
            break;
    }

}
-(void)Disconnected
{
    [self.navigationController showNotificationWithString:@"手环连接关闭"];
}
-(void)start
{
    if (status == 0) {
        [self.navigationController showNotificationWithString:@"手环连接成功"];

        [[MyBle sharedManager] enableRead:[MyBle sharedManager].activePeripheral];
    }else{
        
        [[MyBle sharedManager] enable];
    }



}
-(void)SetCenter:(CBCentralManager*)center ble:(CBPeripheral*)myPeripheral
{

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
