//
//  MINGXIViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/27.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "MINGXIViewController.h"
#import "PersonCell.h"
#import "SVProgressHUD.h"
#import "DataManager.h"
#import "UIColor+HexString.h"
#import "PersonHeadView.h"
#define kMMINGXIcell @"kMINGXIcell"
@interface MINGXIViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * infoArr;
@property (nonatomic , strong) NSArray * rows;
@property (nonatomic , copy) NSMutableArray * personBMI;
@end

@implementation MINGXIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBar];
    [self addPersonTableView];

    [self loadMessageInfo];
    // Do any additional setup after loading the view.
}

- (void)setNavigationBar{
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


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPersonHistory:)];
    [view addGestureRecognizer:tap];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

       self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    self.title = @"明细";
}

- (void)popPersonHistory:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)loadMessageInfo{

    NSDictionary * dict = @{@"bodyFatId":_bodyFatId};
    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryBodyFat" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

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


        }else{
            [SVProgressHUD showErrorWithStatus:@"信息获取失败"];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"信息请求失败"];
    }];
}


- (void)addPersonTableView{

    _tableView = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[PersonCell class] forCellReuseIdentifier:kMMINGXIcell];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];

    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.showsVerticalScrollIndicator = NO;

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
    PersonCell * cell = [tableView dequeueReusableCellWithIdentifier:kMMINGXIcell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMMINGXIcell forIndexPath:indexPath];
    }
    cell.img = _rows[0][indexPath.row];
    cell.name = _rows[1][indexPath.row];
    if (_personBMI.count>0) {
        cell.info = _personBMI[indexPath.row];
    }



    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   PersonHeadView * sectionView = [[PersonHeadView alloc] init];
    sectionView.isBlooth = YES;
    if (_personBMI.count>0) {
        sectionView.BMI_status = _personBMI[9];
    }


    return sectionView;
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
