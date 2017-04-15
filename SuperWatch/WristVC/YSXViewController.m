//
//  YSXViewController.m
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "YSXViewController.h"
#import "YSXCell.h"
#import "UIColor+HexString.h"
#import "UINavigationController+ShowNotification.h"

#import "ListViewController.h"
#import "MyPlayVC.h"
#import "SMSleepVController.h"
#import "XLHeadVController.h"

#import "UserCenter.h"
#define kYSXCell @"kYSXCell"

@interface YSXViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic , strong) NSArray * imgArray;

@end

@implementation YSXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self setupYSXTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupYSXTableView{
      _imgArray = @[@[@"report_btn_scales_def",@"report_btn_sport_def",@"report_btn_sleep_def",@"report_btn_heart_def"],@[@"report_btn_scales_pre",@"report_btn_sport_pre",@"report_btn_sleep_pre",@"report_btn_heart_pre"]];

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[YSXCell class] forCellReuseIdentifier:kYSXCell];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_imgArray[0] count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSXCell * cell = [tableView dequeueReusableCellWithIdentifier:kYSXCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kYSXCell forIndexPath:indexPath];
    }

    cell.img_name = _imgArray[0][indexPath.row];
    cell.hight_name = _imgArray[1][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imgView addTarget:self action:@selector(YSXsendCommond:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ListViewController * tzl = [[ListViewController alloc] init];
        tzl.userID = [UserCenter shareUserCenter].userId;

        [self.navigationController pushViewController:tzl animated:YES];
    }else if (indexPath.row == 1){
        MyPlayVC * sport = [[MyPlayVC alloc] init];
        [self.navigationController pushViewController:sport animated:YES];

    }else if (indexPath.row == 2){
        SMSleepVController * sleep = [[SMSleepVController alloc] init];
        [self.navigationController pushViewController:sleep animated:YES];

    }else if (indexPath.row == 3){
        XLHeadVController * head = [[XLHeadVController alloc] init];
        [self.navigationController pushViewController:head animated:YES];
    }else{
        [self.navigationController showNotificationWithString:@"Error"];
    }

}

- (void)YSXsendCommond:(UIButton *)sender{
    UIView  * view = sender.superview;

    UIView * view1 = view.superview;

    if ([view1.superview isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view1.superview];
        if (indexPath.row == 0) {
            ListViewController * tzl = [[ListViewController alloc] init];
            tzl.userID = [UserCenter shareUserCenter].userId;
      
            [self.navigationController pushViewController:tzl animated:YES];
        }else if (indexPath.row == 1){
            MyPlayVC * sport = [[MyPlayVC alloc] init];
            [self.navigationController pushViewController:sport animated:YES];

        }else if (indexPath.row == 2){
            SMSleepVController * sleep = [[SMSleepVController alloc] init];
            [self.navigationController pushViewController:sleep animated:YES];

        }else if (indexPath.row == 3){
            XLHeadVController * head = [[XLHeadVController alloc] init];
            [self.navigationController pushViewController:head animated:YES];
        }else{
            [self.navigationController showNotificationWithString:@"Error"];
        }

    }
}


- (void)setupNavView{

    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popBackocView) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets= UIEdgeInsetsMake(0, -25, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};
    self.title = @"我的记录";

//    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
//    [btn1 setTitle:@"明细" forState:UIControlStateNormal];
//    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btn1 setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(pushMingxiVC) forControlEvents:UIControlEventTouchUpInside];
//    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -25);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
}


- (void)pushMingxiVC{

}

- (void)popBackocView{

    [self dismissViewControllerAnimated:YES completion:nil];
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
