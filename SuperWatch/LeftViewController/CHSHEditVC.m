//
//  CHSHEditVC.m
//  SuperWatch
//
//  Created by pro on 17/3/14.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CHSHEditVC.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "MyBle.h"
#import "UINavigationController+ShowNotification.h"
@interface CHSHEditVC ()<MyBleDelegate>
@property (nonatomic ,strong)UIImageView * bottom_img;
@property (nonatomic , strong) UIImageView * top_img;
@property (nonatomic , strong) UILabel * SH_version;
@property (nonatomic , strong) UILabel * SH_ser;
@property (nonatomic , strong) UIButton * reload_SH;
@property (nonatomic , strong) UIButton * reset_SH;

@end

@implementation CHSHEditVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyBle sharedManager].delegate = self;
    if ([MyBle sharedManager].activePeripheral.state == 2) {
      [[MyBle sharedManager] getVersion];
    [[MyBle sharedManager]  GetMacAddress];
    }
  //  self.navigationController.navigationBarHidden = YES;
}

//-(void)viewWillDisappear:(BOOL)animated{
  //  self.navigationController.navigationBarHidden = NO;
//};
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCHSHEditNavigationView];
    [self setupCHSHInfo];
    [self layoutCHSHView];
    // Do any additional setup after loading the view.
}

- (void)layoutCHSHView{
    [_bottom_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(101);
    }];

    [_SH_ser mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];

    [_SH_version mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_SH_ser.mas_top).offset(-20);
        make.centerX.equalTo(_SH_ser);
    }];

    [_top_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_SH_ser);
        make.bottom.equalTo(_SH_version.mas_top).offset(-42);
    }];

    [_reload_SH mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SH_ser.mas_bottom).offset(48);
        make.centerX.equalTo(_SH_ser);
        make.width.mas_equalTo(202);
        make.height.mas_equalTo(33);
    }];

    [_reset_SH mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reload_SH.mas_bottom).offset(24);
        make.centerX.equalTo(_SH_ser);
        make.width.height.equalTo(_reload_SH);
    }];
}

- (void)setupCHSHInfo{
    _bottom_img = [[UIImageView alloc] init];
    _bottom_img.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:_bottom_img];

    _top_img = [[UIImageView alloc] init];
    _top_img.image = [UIImage imageNamed:@"hardware_icon_bracelet"];
    [self.view addSubview:_top_img];

    _SH_version = [[UILabel alloc] init];
    _SH_version.text = @"手环版本号：  V0.0.0";
    _SH_version.textAlignment = NSTextAlignmentCenter;
    _SH_version.font = [UIFont systemFontOfSize:15];
    _SH_version.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.view addSubview:_SH_version];

    _SH_ser = [[UILabel alloc] init];
    _SH_ser.text = @"手环序列号： ********";
    _SH_ser.textAlignment = NSTextAlignmentCenter;
    _SH_ser.font = [UIFont systemFontOfSize:15];
    _SH_ser.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.view addSubview:_SH_ser];

    _reload_SH = [[UIButton alloc] init];
    _reload_SH.layer.cornerRadius = 3;
    _reload_SH.layer.masksToBounds = YES;
    _reload_SH.layer.borderColor = [UIColor colorWithHexString:@"#737f7f"].CGColor;
    _reload_SH.layer.borderWidth= 0.5;
    [_reload_SH setTitle:@"重启手环" forState:UIControlStateNormal];
    [_reload_SH setTitleColor:[UIColor colorWithHexString:@"#7f7f7f"] forState:UIControlStateNormal];
    [self.view addSubview:_reload_SH];
    [_reload_SH addTarget:self action:@selector(reloadSHSET:) forControlEvents:UIControlEventTouchUpInside];

    _reset_SH = [[UIButton alloc] init];
    _reset_SH.layer.cornerRadius = 3;
    _reset_SH.layer.masksToBounds = YES;
    _reset_SH.layer.borderColor = [UIColor colorWithHexString:@"#737f7f"].CGColor;
    _reset_SH.layer.borderWidth = 0.5;
    [_reset_SH setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];
    [_reset_SH setTitle:@"恢复出厂设置" forState:UIControlStateNormal];
    [self.view addSubview:_reset_SH];
    [_reset_SH addTarget:self action:@selector(resetSHSET:) forControlEvents:UIControlEventTouchUpInside];

}
//重启手环
-(void)reloadSHSET:(UIButton *)sender{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] MCUReset];
    }else{
        [self.navigationController showNotificationWithString:@"请连接蓝牙和设备"];
    }
}
// 恢复出厂设置
- (void)resetSHSET:(UIButton *)sender{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  reset];
    }else{
        [self.navigationController showNotificationWithString:@"请连接蓝牙和设备"];
    }
}
// 获取版本号
-(void)readSHVersion{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager] getVersion];
    }
}
// 获取mac地址
-(void)readSHMacAddress{
    if ([MyBle sharedManager].activePeripheral.state == 2) {
        [[MyBle sharedManager]  GetMacAddress];
    }
}
#pragma mark BLeDelegate
-(void)FindDeviceWithDevice:(CBPeripheral*)device  RSSI:(NSNumber*)RSSI
{

}
//开始通信
-(void)DisplayRece:(Byte*)buf length:(int)len
{
    switch (buf[0]) {
        case 0x12:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"恢复出厂设置成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
            break;
            case 0x22:
        {
            _SH_ser.text = [NSString stringWithFormat:@"手环序列号：%02x%02x%02x%02x%02x%02x",buf[1],buf[2],buf[3],buf[4],buf[5],buf[6]];
        }
            break;
            case 0x27:
        {
            _SH_version.text = [NSString stringWithFormat:@"手环版本号：V%x%x%x%x-20%02x%x%02x",buf[1],buf[2],buf[3],buf[4],buf[5],buf[6],buf[7]];
        }
            break;
        case 0x2e:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"手环重启成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
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
// 设置标题
- (void)setCHSHEditNavigationView{



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


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popCHEditCenter:)];
    [view addGestureRecognizer:tap];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    self.title = @"手环信息";
    
}
- (void)popCHEditCenter:(UITapGestureRecognizer *)tap{

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
