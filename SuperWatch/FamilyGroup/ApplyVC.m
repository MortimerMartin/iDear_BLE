//
//  ApplyVC.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ApplyVC.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "ApplyPersonCell.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "DataManager.h"
#import "MJRefresh.h"
#import "UserCenter.h"
#import "ApplyPersonModel.h"
#import "UINavigationController+ShowNotification.h"
#define kApplyPersonCell @"kApplyPersonCell"
@interface ApplyVC ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong)UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * applyArray;
@property (nonatomic , strong) NSString *  agreeJoin;

@end

@implementation ApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    _applyArray = [NSMutableArray array];
    [self setNavigationView];


    NSDictionary * dict3 = @{@"VCShow":@NO};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNewPersonApply" object:nil userInfo:dict3];


    [self setupTableView];
      [self setupRefresh];
        [self loadNewPersonInfo];
    // Do any additional setup after loading the view.
}


- (void)loadNewPersonInfo{
    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId intValue])
                        };
    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryAuditList" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
//        if (dict1[@"message"] == NULL || [dict1[@"message"] isKindOfClass:[NSNull class]] || [dict1[@"message"] isEqualToString:@""]) {
//            [SVProgressHUD showInfoWithStatus:@"没有新的家庭组成员申请"];
//            [weakSelf.tableView.mj_header endRefreshing];
//            return ;
//        }
        if ([dict1[@"status"] intValue] == 1) {

            weakSelf.applyArray = [ApplyPersonModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];
            if (weakSelf.applyArray.count == 0) {
                [weakSelf.navigationController showNotificationWithString:@"没有新成员申请"];
            }
            [weakSelf.tableView reloadData];

            [weakSelf.tableView.mj_header endRefreshing];
        }else{
//            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            [weakSelf.navigationController showNotificationWithString:@"获取信息失败"];
             [weakSelf.tableView.mj_header endRefreshing];
        }

    } failure:^(NSError *error) {
        [weakSelf.navigationController showNotificationWithString:@"网络状况不佳"];
//         [SVProgressHUD showErrorWithStatus:@"请求失败"];
         [weakSelf.tableView.mj_header endRefreshing];
    }];

}

- (void)setupRefresh{

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewPersonInfo)];

}
- (void)setupTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ApplyPersonCell class] forCellReuseIdentifier:kApplyPersonCell];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;



//    NSString * time = @"login_btn_man_pre";
//    NSMutableArray * arr1 = [NSMutableArray array];
//    for (int i = 0; i < 5; i++) {
//
//        [arr1 addObject:time];
//    }
//    NSString  *  weight = @"Mortimer";
//    NSMutableArray * arr2 = [NSMutableArray array];
//    for (int i = 0; i < 5; i++) {
//
//        [arr2 addObject:[weight stringByAppendingFormat:@"%d",i]];
//    }
//    [_applyArray addObject:arr1];
//    [_applyArray addObject:arr2];
//
//
//    NSString  *  wei = @"申请加入家庭组";
//    NSMutableArray * arr3 = [NSMutableArray array];
//    for (int i = 0; i < 5; i++) {
//
//        [arr3 addObject:wei];
//    }
//
//    [_applyArray addObject:arr3];
//
//    NSString  *  wei1 = @"";
//    NSMutableArray * arr4 = [NSMutableArray array];
//    for (int i = 0; i < 5; i++) {
//
//        [arr4 addObject:wei1];
//    }
//
//  [_applyArray addObject:arr4];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
      return [_applyArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:kApplyPersonCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kApplyPersonCell forIndexPath:indexPath];
    }

    [cell.agreeBtn addTarget:self action:@selector(reloadTableView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.disagreenBtn addTarget:self action:@selector(reloadTableView1:) forControlEvents:UIControlEventTouchUpInside];

    ApplyPersonModel * person = _applyArray[indexPath.section];
//    if (_applyArray[indexPath.row] != nil ) {
//        NSString * mid = _applyArray[indexPath.section];
//        if (![mid isEqualToString:@""]) {
//            cell.isAgree =_applyArray[indexPath.section];
//        }
//
//    }
    if ([person.status isEqualToString:@"-1"]) {
        cell.isAgree = @"不同意";
    } else if ([person.status isEqualToString:@"1"]){
        cell.isAgree = @"同意";
    } else{
        cell.isAgree = @"不隐藏";
    }


    cell.headURL = person.imgSource;
    cell.applyname = person.nickName;
    cell.applydescript = person.remark;


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
- (void)reloadTableView:(UIButton *)sender{
//    _agreeJoin = @"同意";

    UIView  * view = sender.superview.superview;

    if ([view isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view];
        ApplyPersonModel * model = _applyArray[indexPath.section];

        NSDictionary * dict3 = @{@"VCShow":@NO};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNewPersonApply" object:nil userInfo:dict3];
        NSDictionary * dict4 = @{@"VCShow":@NO};

        [[NSNotificationCenter defaultCenter] postNotificationName:@"showRed" object:nil userInfo:dict4];

        NSDictionary * dict = @{
                                @"approveId":@([model.approveId intValue]),
                                @"status":@(1)
                                };
        __weak typeof(self) weakSelf = self;
        [[DataManager manager] postDataWithUrl:@"doAuditApprove" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;

            if ([dict1[@"status"] intValue] == 1) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
//                weakSelf.applyArray = [ApplyPersonModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];
                [strongSelf loadNewPersonInfo];

//                [weakSelf.tableView.mj_header endRefreshing];
            }else{
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
//                [weakSelf.tableView.mj_header endRefreshing];
            }

        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
//            [weakSelf.tableView.mj_header endRefreshing];
        }];

    }
    



//    [_tableView reloadData];

}

- (void)reloadTableView1:(UIButton *)sender{
//    _agreeJoin = @"不同意";
    UIView  * view = sender.superview.superview;

    if ([view isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view];
        ApplyPersonModel * model = _applyArray[indexPath.section];

        NSDictionary * dict3 = @{@"VCShow":@NO};

        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNewPersonApply" object:nil userInfo:dict3];

        NSDictionary * dict4 = @{@"VCShow":@NO};

        [[NSNotificationCenter defaultCenter] postNotificationName:@"showRed" object:nil userInfo:dict4];


        NSDictionary * dict = @{
                                @"approveId":model.approveId ,
                                @"status":@(-1)
                                };
        __weak typeof(self) weakSelf = self;
        [[DataManager manager] postDataWithUrl:@"doAuditApprove" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;

            if ([dict1[@"status"] intValue] == 1) {

//                weakSelf.applyArray = [ApplyPersonModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];
                __strong typeof (weakSelf) strongSelf = weakSelf;
                //                weakSelf.applyArray = [ApplyPersonModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];
                [strongSelf loadNewPersonInfo];

//                [weakSelf.tableView.mj_header endRefreshing];
            }else{
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
//                [weakSelf.tableView.mj_header endRefreshing];
            }

        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
//            [weakSelf.tableView.mj_header endRefreshing];
        }];

        
    }
//    [_tableView reloadData];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.5;
}
- (void)setNavigationView{
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


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPersonCenter:)];
    [view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    self.title = @"审批列表";
    
}

- (void)popPersonCenter:(UITapGestureRecognizer *)tap{
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
