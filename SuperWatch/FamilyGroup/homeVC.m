//
//  homeVC.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "homeVC.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "JoinHomeVC.h"
#import "MJRefresh.h"
#import "UIView+CLExtension.h"
#import "joinViewCell.h"
#import "creatHomeVC.h"
#import "UserCenter.h"
#import "DataManager.h"
#import "MJExtension.h"
#import "ApplyHomeModel.h"
#import "homZVC.h"
#import "ViewController.h"
#import "FFDropDownMenuView.h"
#import "ZYScalesDropCell.h"
#define kJoinViewCell @"JoinViewCell"
@interface homeVC ()<UITableViewDelegate , UITableViewDataSource,FFDropDownMenuViewDelegate>
{
    BOOL dropViewisShow;
}
@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) UIView * joinHomeView;

@property (nonatomic , strong) NSMutableArray * joinArr;
@property (nonatomic , strong) NSMutableArray * agreeArr;

@property (nonatomic , strong) FFDropDownMenuView * dropMenuView;
@property (nonatomic , strong) UIButton * rightBarBtn;

@end

@implementation homeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    NSDictionary * dict = @{@"VCShow":@NO};

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRed" object:nil userInfo:dict];

    [self setNavigationView];
    _agreeArr = [NSMutableArray arrayWithCapacity:1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinFamily:) name:@"joinFamily" object:nil];


    if ([[kUserDefaults valueForKey:@"kCancel"] boolValue] == NO) {
          [self joinFamilyView];
    }else{
        if (_joinHomeView) {
            [_joinHomeView removeFromSuperview];
        }
        _joinArr = [NSMutableArray array];
        [self setupTableView];

        [self loadNewMessage];
    }


    // Do any additional setup after loading the view.
}
- (void)joinFamily:(NSNotification *)center{

    NSDictionary * dict = center.userInfo;
    NSString * applyStatus = dict[@"messageType"];
    if ([applyStatus isEqualToString:@"103"]) {
        [self loadDoQueryHomeNo];
    }

}

- (void)loadDoQueryHomeNo{
    NSDictionary * dict = @{@"userId":@([[UserCenter shareUserCenter].userId intValue])};
    [[DataManager manager] postDataWithUrl:@"doQueryHomeNo" parameters:dict success:^(id json) {
        NSDictionary * dict1 =json;
        if ([dict1[@"status"] intValue] == 1) {
            if (dict1[@"message"] == NULL || [dict1[@"message"] isKindOfClass:[NSNull class]] || [dict1[@"message"] isEqualToString:@""]) {
                [UserCenter shareUserCenter].homenumer = nil;
            }else{

                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"家庭组已通过您的申请" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                }];

                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 新建将要push的控制器
                    homZVC * home = [[homZVC alloc] init];
                    // 获取当前路由的控制器数组
                    NSMutableArray * vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    // 获取档期控制器在路由的位置
                    int indexVC = (int)[vcArr indexOfObject:self];
                    // 移除当前路由器

                    if ([self isKindOfClass:[ViewController class]]) {
                        return ;
                    }
                    [vcArr removeObjectAtIndex:indexVC];
//                    [vcArr removeObjectAtIndex:1];
                    // 添加新控制器
                    [vcArr insertObject:home atIndex:indexVC];
                    // 重新设置当前导航控制器的路由数组
                    [self.navigationController setViewControllers:vcArr animated:YES];


                }];

                [alert addAction:cancel];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];

                [UserCenter shareUserCenter].homenumer = dict1[@"message"];
                [[NSUserDefaults standardUserDefaults] setValue: [UserCenter shareUserCenter].homenumer forKey:@"UserHomeNumber"];
                
            }

        }else{

        }

    } failure:^(NSError *error) {

    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.cl_width, self.view.cl_height -64)];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
        //    self.tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[joinViewCell class] forCellReuseIdentifier:kJoinViewCell];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
        // 5.设置分割线样式
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewMessage)];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

  [self loadDoQueryHomeNo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView{

    [self.view addSubview:self.tableView];
    _joinArr = [NSMutableArray arrayWithCapacity:3];

}




- (void)loadNewMessage{

    NSDictionary * dict = @{@"userId":@([[UserCenter shareUserCenter].userId intValue])};
    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryApproveList" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

            weakSelf.joinArr = [ApplyHomeModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];

//            [weakSelf.tableView.mj_header endRefreshing];
        }else{

        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {

        [weakSelf.tableView.mj_header endRefreshing];
    }];


}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [_joinArr count] + 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == [_joinArr count] ) {
        return 0;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section == [_joinArr count] ) {

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"kErrorCell"];
        return cell;
    }
    joinViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kJoinViewCell];

    ApplyHomeModel * model = _joinArr[indexPath.section];
    cell.number = model.homeNo;
    cell.text_color = model.status;
    cell.apply = model.createDate;

//    cell.number = _joinArr[0][indexPath.section ];
//    cell.apply = _joinArr[1][indexPath.section ];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section  == [_joinArr count] ) {
        return 125;
    }
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor =[UIColor colorWithHexString:@"#eff4f4"];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == [_joinArr count] ) {
        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, 125)];
        footView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];


        UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        joinBtn.frame = CGRectMake((self.view.cl_width - 192)/2, 26, 192, 40);
        [joinBtn setTitle:@"申请加入家庭组" forState:UIControlStateNormal];
        [joinBtn setTitleColor:[UIColor colorWithHexString:@"0fc2af"] forState:UIControlStateNormal];
        [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [joinBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [joinBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
        joinBtn.layer.cornerRadius = 5;
        joinBtn.layer.masksToBounds = YES;
        joinBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
        joinBtn.layer.borderWidth = 1;
        [joinBtn addTarget:self action:@selector(pushtoJoinView:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:joinBtn];

        UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake((self.view.cl_width - 192)/2 -20, 80, 260, 40)];
        message.text = @"加入家庭组，与家庭成员共享数据，关注彼此健康与成长。";
        message.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
        message.numberOfLines = 0;
        message.font = [UIFont systemFontOfSize:15];
        [footView addSubview:message];

        return footView;
    }

    return [UIView new];
};



- (void)setNavigationView{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 60, 40)];
    if ( [[kUserDefaults valueForKey:@"kCancel"] boolValue] != YES) {
        [rightBtn setTitle:@"创建" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [rightBtn addTarget:self action:@selector(creatFamilyGroup:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"home_icon_add_def"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"home_icon_add_pre"] forState:UIControlStateHighlighted];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
        [rightBtn addTarget:self action:@selector(showDropMenuView:) forControlEvents:UIControlEventTouchUpInside];
        [self setupDropDawnMenu];
    }



    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.rightBarBtn = rightBtn;

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

    //    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -rightBtn.currentImage.size.width, 0, 0)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};
    
    self.title = @"申请列表";
    
}


/*    * *       *  *
 *   *    *   *     *      ________
 *    *     *      *   ____\_\_\_\_\
 *      *        *    |   __________===== o o o o  [下拉 列表]
 *        *   *       |__/   /c_/
 *          *
 */
- (void)setupDropDawnMenu{
    NSMutableArray * dropModelArray = [self getMenuModelArray];
    _dropMenuView = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:dropModelArray menuWidth:-10 eachItemHeight:-10 menuRightMargin:-10 triangleRightMargin:-10];
    self.dropMenuView.delegate = self;
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
-(void)ffDropDownMenuView:(FFDropDownMenuView *)menuView WillAppearMenuCell:(FFDropDownMenuBasedCell *)menuCell index:(NSInteger)index{
        ZYScalesDropCell * cell = (ZYScalesDropCell *)menuCell;
        cell.applyF = YES;
    //    if (menuView.menuModelsArray.count - 1 == index) {
    //        cell.titleColor = [UIColor colorWithRed:32/255.0 green:150/255.0 blue:198/255.0 alpha:1];
    //        cell.customImageView.image = [UIImage imageNamed:@"family_btn_add"];
    //    }
}

-(NSMutableArray *)getMenuModelArray{
    NSMutableArray * modelArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;

    //菜单default
    FFDropDownMenuModel * defaultMenuModel = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"加入家庭组" menuItemIconName:nil GmeunItemID:nil menuBlock:^{
        JoinHomeVC * join = [[JoinHomeVC alloc] init];
        [weakSelf.navigationController pushViewController:join animated:YES];
    }];
    FFDropDownMenuModel * creatMenuModel = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"创建家庭组" menuItemIconName:nil GmeunItemID:nil menuBlock:^{
        creatHomeVC * creathome = [[creatHomeVC alloc] init];
        [weakSelf.navigationController pushViewController:creathome animated:YES];
    }];
    [modelArray addObject:defaultMenuModel];
    [modelArray addObject:creatMenuModel];

    return modelArray;
}

- (void)showDropMenuView:(UIButton *)sender{

    sender.selected = ! sender.selected;
    if (sender.selected == YES) {
        dropViewisShow = YES;
        [self.dropMenuView showMenu];
    }else{
        dropViewisShow = NO;
        [self.dropMenuView dismissMenuWithAnimation:YES];
    }

}


- (void)joinFamilyView{
    _joinHomeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _joinHomeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_joinHomeView];
    UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinBtn setTitle:@"申 请 加 入 家 庭 组" forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [joinBtn setTitleColor:[UIColor colorWithHexString:@"0fc2af"] forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [joinBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [joinBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
    joinBtn.layer.cornerRadius = 5;
    joinBtn.layer.masksToBounds = YES;
    joinBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
    joinBtn.layer.borderWidth = 1;
    [joinBtn addTarget:self action:@selector(pushJoinView:) forControlEvents:UIControlEventTouchUpInside];
    [_joinHomeView addSubview:joinBtn];

    UILabel * message = [[UILabel alloc] init];
    message.text = @"加入家庭组，与家庭成员共享数据，关注彼此健康与成长。";
    message.textAlignment = NSTextAlignmentCenter;
    message.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    message.numberOfLines = 2;
    message.font = [UIFont systemFontOfSize:15];
    [_joinHomeView addSubview:message];


    [message mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(40);
    }];
    [joinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(message.mas_top).offset(-20);
        make.width.mas_equalTo(192);
        make.height.mas_equalTo(40);
    }];


}



- (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);

    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
- (void)creatFamilyGroup:(UIButton *)sender{
    creatHomeVC * creathome = [[creatHomeVC alloc] init];
    [self.navigationController pushViewController:creathome animated:YES];

}
- (void)pushtoJoinView:(UIButton *)sender{
    JoinHomeVC * join = [[JoinHomeVC alloc] init];

    [self.navigationController pushViewController:join animated:YES];
}
- (void)pushJoinView:(UIButton *)sender{
    JoinHomeVC * join = [[JoinHomeVC alloc] init];

    [self.navigationController pushViewController:join animated:YES];
//    sender.backgroundColor = [UIColor blueColor];

}
-(void)popPersonCenter:(UITapGestureRecognizer *)tap{

    if (dropViewisShow == YES || _rightBarBtn.selected == YES) {
        [_dropMenuView dismissMenuWithAnimation:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"joinFamily" object:nil];
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
