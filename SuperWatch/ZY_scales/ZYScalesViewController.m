//
//  ZYScalesViewController.m
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ZYScalesViewController.h"
#import "GIFAnimationView.h"
#import "UserCenter.h"
#import "BLECtl.h"
#import "DataManager.h"
#import "PersonHeadView.h"
#import "SVProgressHUD.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "PersonCell.h"
#import "UIImageView+WebCache.h"

#import "FFDropDownMenuView.h"
#import "NewPersonVC.h"
#import "FamilyPerson.h"
#import "MJExtension.h"
#import "getSeven.h"
#import "UINavigationController+ShowNotification.h"
#define kPersonCell @"person_cell"
@interface ZYScalesViewController ()<UITableViewDelegate,UITableViewDataSource,BLECtlDelegate>
{
    BOOL dropViewisShow;
}
@property (nonatomic , strong) GIFAnimationView * gif;
@property (nonatomic , strong) PersonHeadView * sectionView;
@property (nonatomic , copy) NSMutableArray * personBMI;
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSArray * rows;

@property (nonatomic , strong) UILabel * titleName;
@property (nonatomic , strong) UIImageView * titleImg;


//DropFamilyArray
@property (nonatomic , strong) NSMutableArray * dropArray;
@property (nonatomic , strong) NSMutableArray * dropModelArray;
@property (nonatomic , strong) FFDropDownMenuView *  dropMenuView;
@property (nonatomic , strong) UIButton * rightBarBtn;

@end

@implementation ZYScalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dropArray = [NSMutableArray array];
    _dropModelArray = [NSMutableArray arrayWithCapacity:1];
    //设置导航栏
    [self setupScalesNavigation];
    //初始化 列表
    [self addPersonTableView];
    //获取家庭组成员
    [self loadDataInfo];
    [self setupDropDawnMenu];
    //加载gif动画
    [self addGIFAnimationView];


    // Do any additional setup after loading the view.
}
- (void)addGIFAnimationView{
    self.gif = [[GIFAnimationView alloc] initWithFrame:_tableView.frame];
    [self.view addSubview:_gif];
    [self.view bringSubviewToFront:_gif];
    //添加 gif view 的 约束
    [_gif mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(_tableView);
    }];

//    _gif.hidden = YES;






//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    BLECtl *ble = [BLECtl instance];//初始化（initialization）
    ble.delegate = self;//设置代理（Set Proxy）FE030100AA1801B1
    ble.SendDataToBlueString = [getSeven getSeven];//设置人体参数（Setting the body parameter）FE030100AA1901B0
    [ble setCentralManager];//设置中心管理者（Set the center manager）
//    });

}
// 连接成功时（Connected）
- (void)bleCtlDidConnectPeripheral:(CBPeripheral *)aPeripheral MacData:(NSData *)mac
{


    self.gif.status = @"已连接";
    self.sectionView.status = @"已连接";
    [UIView animateWithDuration:1 animations:^{
        _gif.alpha = 1;
        [BLECtl instance].SendDataToBlueString = [getSeven getSeven];
        [[BLECtl instance] scan];//开始扫描（Start scanning）
    }completion:^(BOOL finished) {
        _gif.hidden = NO;
        [_gif startTimer];
    } ];


    NSLog(@"- (void)bleCtlDidConnectPeripheral:(CBPeripheral *)aPeripheral MacData:(NSData *)mac");
}
//接收到的数据 （receive dictionary）
- (void)bleCtlDidReceivedData:(NSDictionary *)receiveDic
{
    self.sectionView.status = @"已连接";

    double BMR = [receiveDic[@"BMR"] doubleValue];
    double age =[receiveDic[@"HealthAge"] doubleValue];
    double bodyWater = [receiveDic[@"bodyWater"] doubleValue];
    double bone = [receiveDic[@"bone"] doubleValue];
    double fat =[receiveDic[@"fat"] doubleValue];
    double height = [receiveDic[@"height"] doubleValue];
    double muscleMass = [receiveDic[@"muscleMass"] doubleValue];
    int sex = [receiveDic[@"sex"] intValue];
    double viscreralFat = [receiveDic[@"visceralFat"] doubleValue];
    double weight =[receiveDic[@"weight"] doubleValue];

    bone = bone/10;
    BMR = BMR/100;
    bodyWater = bodyWater / 10;
    fat = fat/10;
    muscleMass = muscleMass / 10;
    weight = weight/10;
    NSString * sexSTR;
    if (sex == 1) {
        sexSTR = @"男";
    }else{
        sexSTR = @"女";
    }



    NSString *savedTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"time"];
    NSString *time = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]];

    double timeD = ([time doubleValue] - [savedTime doubleValue]) * 1000;
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastTlC_history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (timeD > 250.0) {


        __weak typeof(self) weakSelf = self;

        [weakSelf.personBMI addObject:@(height)];
        [weakSelf.personBMI addObject:@(weight)];
        [weakSelf.personBMI addObject:@(fat)];
        [weakSelf.personBMI addObject:@(muscleMass)];
        [weakSelf.personBMI addObject:@(bodyWater)];
        [weakSelf.personBMI addObject:@(bone)];
        [weakSelf.personBMI addObject:@(viscreralFat)];
        [weakSelf.personBMI addObject:@(BMR)];
        [weakSelf.personBMI addObject:@(age)];
        [weakSelf.personBMI addObject:@(0.0)];

        NSDictionary * dict = @{
                                @"userId":@([[UserCenter shareUserCenter].userId integerValue]),
                                @"bodyWater":@(bodyWater),
                                @"bodyFat":@(fat),
                                @"bone":@(bone),
                                @"visceralFat":@(viscreralFat),
                                @"bmr":@(BMR),
                                @"muscleMass":@(muscleMass),
                                @"weight":@(weight),
                                @"height":@(height),
                                @"age":@(age),
                                @"sex":sexSTR
                                };

        [[DataManager manager ]postDataWithUrl:@"doAddBodyFat" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {

                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.gif.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.gif pauserTimer];
                    weakSelf.gif.hidden = YES;
                }];

                [weakSelf.personBMI removeAllObjects];
                [weakSelf.personBMI addObject:dict1[@"data"][@"height"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"weight"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"bodyFat"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"muscleMass"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"bodyWater"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"bone"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"visceralFat"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"bmr"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"age"]];
                [weakSelf.personBMI addObject:dict1[@"data"][@"bmi"]];
                [weakSelf.tableView reloadData];

            }

        } failure:^(NSError *error) {

            [weakSelf.tableView reloadData];
        }];

    }







    NSLog(@"receive dic %@",receiveDic);
}
// 断开连接时 （Disconnecting）
- (void)bleCtlDidDisconnectPeripheral:(CBPeripheral *)aPeripheral{
    self.gif.status = @"断开连接";
    self.sectionView.status = @"断开连接";

    [UIView animateWithDuration:0.6 animations:^{
        self.gif.alpha = 0;
        [[BLECtl instance] stop];
    } completion:^(BOOL finished) {
        [SVProgressHUD showErrorWithStatus:@"断开连接"];
        [self.gif pauserTimer];
        self.gif.hidden = YES;
    }];
}
// 连接失败时（fail to connect）
- (void)bleCtlDidFailToConnectPeripheral:(CBPeripheral *)aPeripheral{
    [self.navigationController showNotificationWithString:@"连接失败"];
//    [SVProgressHUD showErrorWithStatus:@"连接失败"];
}


- (void)addPersonTableView{

    _tableView = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[PersonCell class] forCellReuseIdentifier:kPersonCell];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];

    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.showsVerticalScrollIndicator = NO;
    //添加约束
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    _rows = @[@[@"measure_icon_height",@"measure_icon_weight",@"measure_icon_bodyfat",@"measure_icon_muscle",@"measure_icon_water",@"measure_icon_bone",@"measure_icon_visceral",@"measure_icon_BMR",@"measure_icon_age"],@[@"身高",@"体重",@"体脂率",@"肌肉量",@"水分含量",@"骨量",@"内脏脂肪",@"BMR (基础代谢)",@"身体年龄"]];

    _personBMI = [NSMutableArray arrayWithCapacity:10];
}



#pragma mark UITableViewDelegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{



    return [_rows[0] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCell * cell = [tableView dequeueReusableCellWithIdentifier:kPersonCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPersonCell forIndexPath:indexPath];
    }
    cell.img = _rows[0][indexPath.row];
    cell.name = _rows[1][indexPath.row];
    if (_personBMI.count>0) {
        cell.info = [NSString stringWithFormat:@"%@",_personBMI[indexPath.row]];
    }


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _sectionView = [[PersonHeadView alloc] init];
    if (_personBMI.count>0&&_personBMI.count == 10) {
        _sectionView.BMI_status = _personBMI[9];
    }else{
        _sectionView.BMI_status = @"";
    }


    return _sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 440;
}

/*    * *       *  *
 *   *    *   *     *      ________
 *    *     *      *   ____\_\_\_\_\
 *      *        *    |   __________===== o o o o  [下拉 列表]
 *        *   *       |__/   /c_/
 *          *
 */
- (void)setupDropDawnMenu{
    _dropModelArray = [self getMenuModelArray];
    _dropMenuView = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:_dropModelArray menuWidth:-10 eachItemHeight:-10 menuRightMargin:-10 triangleRightMargin:-10];
//    self.dropMenuView.delegate = self;
    self.dropMenuView.ifShouldScroll = NO;
    __weak typeof(self) weakSelf = self;
    self.dropMenuView.reloadStatus = ^(BOOL status){
        weakSelf.rightBarBtn.selected = NO;
    };
    dropViewisShow = NO;

    [self.dropMenuView setup];
}
#pragma mark  -  FFDropDownMenuViewDelegate
/** 可以在这个代理方法中稍微小修改cell的样式，比如是否需要下划线之类的 */
//-(void)ffDropDownMenuView:(FFDropDownMenuView *)menuView WillAppearMenuCell:(FFDropDownMenuBasedCell *)menuCell index:(NSInteger)index{
//    FFDropDownMenuCell * cell = (FFDropDownMenuCell *)menuCell;
//
//    if (menuView.menuModelsArray.count - 1 == index) {
//        cell.titleColor = [UIColor colorWithRed:32/255.0 green:150/255.0 blue:198/255.0 alpha:1];
//        cell.customImageView.image = [UIImage imageNamed:@"family_btn_add"];
//    }
//}

- (NSMutableArray *)getMenuModelArray{
    NSMutableArray * modelArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;

    if (_dropArray && _dropArray.count>0) {
        for (int i = 0; i<_dropArray.count; i++) {
            FamilyPerson * person = _dropArray[i];
            //动态添加家庭组成员
            FFDropDownMenuModel * DT = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:person.nickName menuItemIconName:person.imgSource GmeunItemID:person.userId  menuBlock:^{
                [weakSelf changeAccount:person.userId];
            }];
            [modelArray addObject:DT];
        }

    }
        //菜单default
        FFDropDownMenuModel * defaultMenuModel = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"新增成员" menuItemIconName:@"family_btn_add" GmeunItemID:nil menuBlock:^{
            NewPersonVC * newPerson = [[NewPersonVC alloc] init];
            newPerson.WAYF = @"fromZYSVC";
            newPerson.isnewPerson = YES;
            [weakSelf.navigationController pushViewController:newPerson animated:YES];
        }];

        [modelArray addObject:defaultMenuModel];
    


    return modelArray;
}
//切换 用户
- (void)changeAccount:(NSString *)userId{
    NSDictionary * dict = @{@"userId":userId};
    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryUser" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

            UserCenter * user = [UserCenter shareUserCenter];
            if (dict1[@"data"][@"homeNo"] == NULL || [dict1[@"data"][@"homeNo"] isKindOfClass:[NSNull class]]) {
                user.homenumer = nil;
            }else{
                user.homenumer = dict1[@"data"][@"homeNo"];
            }

            user.height = [dict1[@"data"][@"height"] stringValue];
            user.userId = [dict1[@"data"][@"userId"] stringValue];
            user.age = [dict1[@"data"][@"age"] stringValue];

            if (dict1[@"data"][@"imgSource"] == NULL || [dict1[@"data"][@"imgSource"] isKindOfClass:[NSNull class]]) {
                user.source = nil;
            }else{
                user.source = dict1[@"data"][@"imgSource"] ;
            }

            if (dict1[@"data"][@"mobile"] ==NULL || [dict1[@"data"][@"mobile"] isKindOfClass:[NSNull class]]) {
                user.phone = nil;
            }else{
                user.phone = dict1[@"data"][@"mobile"] ;
            }

            user.sex = dict1[@"data"][@"sex"];
            NSLog(@"%@",user.sex);
            user.name = dict1[@"data"][@"nickName"] ;
            user.bithday = dict1[@"data"][@"birthday"] ;
            user.isLogin = YES;

            [user saveUserDefaults];

            [weakSelf loadDataInfo];

            [_titleImg sd_setImageWithURL:[NSURL URLWithString:user.source]];
            _titleName.text = user.name;
            if (_reloadInfo) {
                _reloadInfo(user.name,user.source);
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"切换失败"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"切换失败"];
    }];
    
}

- (void)loadDataInfo{

    if ([UserCenter shareUserCenter].userId == nil|| [UserCenter shareUserCenter].homenumer == nil) {
        return;
    }
    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId intValue]),
                            @"homeNo":[UserCenter shareUserCenter].homenumer
                            };
    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryHomeUserList" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {


            NSMutableArray * topOne = [FamilyPerson mj_objectArrayWithKeyValuesArray:dict1[@"data"]];

            if (topOne == NULL || [topOne isKindOfClass:[NSNull class]] || topOne == nil || topOne.count <=0) {




                UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您被踢出家庭组" preferredStyle: UIAlertControllerStyleAlert];

                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {



                    [UserCenter shareUserCenter].homenumer = nil;
                    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"UserHomeNumber"];

                }];
                [alert addAction:cancel];

                [self presentViewController:alert animated:YES completion:nil];

                return ;
            }

            weakSelf.dropArray = topOne;
            [weakSelf reloadDropView];




        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];

            
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];

    }];
    
}

- (void)reloadDropView{
    if (_dropMenuView) {
        self.dropMenuView.menuModelsArray = [self getMenuModelArray];
    }

}
//**< 修改字体颜色及字体大小 >**//
- (void)setupScalesNavigation{


    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];



    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(9 , 8, 40, 22)];
    label.text = @"返回";
    label.font= [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithHexString:@"565c5c"];

    UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 13, 6, 12)];
    back.image =  [UIImage imageNamed:@"icon_back"];
    back.userInteractionEnabled = YES;
    UIView * bview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [bview addSubview:label];
    [bview addSubview:back];


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popMainViewController:)];
    [bview addGestureRecognizer:tap];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bview];



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

    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [rightBtn setTitle:@"切换" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightBtn addTarget:self action:@selector(CdropView:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBarBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

}

- (void)CdropView:(UIButton *)sender{
    sender.selected = ! sender.selected;
    if (sender.selected == YES) {
        dropViewisShow = YES;
        [self.dropMenuView showMenu];
    }else{
        dropViewisShow = NO;
        [self.dropMenuView dismissMenuWithAnimation:YES];
    }

}

- (void)popMainViewController:(UITapGestureRecognizer *)tap{
    if (dropViewisShow == YES || _rightBarBtn.selected == YES) {
        [self.dropMenuView dismissMenuWithAnimation:NO];
    }

    [_gif pauserTimer];
//    if (_reloadInfo) {
//        _reloadInfo([UserCenter shareUserCenter].name ,[UserCenter shareUserCenter].source);
//    }

    if (_reloadTableview) {
        _reloadTableview();
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
