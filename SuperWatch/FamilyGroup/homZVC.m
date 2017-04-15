//
//  homZVC.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "homZVC.h"
#import "HomePersonCell.h"
#import "UIView+CLExtension.h"
#import "newPersonCell.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "ApplyVC.h"
#import "NewPersonVC.h"
#import "homeVC.h"
#import "UserCenter.h"
#import "DataManager.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FamilyPerson.h"
#import "SVProgressHUD.h"
#import "UINavigationController+ShowNotification.h"
#import "ListViewController.h"
#define kHomePersonCell @"kHomePersonCell"
#define knewPersonCell @"knewPersonCell"


//#define kNewPersonApply @"kNewPersonApply"    // 登录成功


@interface homZVC ()<UITableViewDelegate , UITableViewDataSource>

{
    BOOL isNewApply;
}
@property(nonatomic , strong)UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * familyArr;

@property (nonatomic , strong) UILabel * familyNum;
@property (nonatomic , strong) UIButton * setBtn;

@property (nonatomic , strong) UIButton * PersonBtn;

@property (nonatomic , strong) newPersonCell * topCell;

@property (nonatomic , assign) BOOL isShow ;

@end

@implementation homZVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    _familyArr = [NSMutableArray array];
    [self setNavigationView];

    [self setupTableView];
    [self setupRefresh];

    NSDictionary * dict = @{@"VCShow":@NO};

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showRed" object:nil userInfo:dict];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter addObserver:self
                      selector:@selector(isShowNewApply:)
                          name:@"kNewPersonApply"
                        object:nil];
    // Do any additional setup after loading the view.
}


- (void)isShowNewApply:(NSNotification *)apply{

    NSDictionary * dict = apply.userInfo;
    NSString * ZVCStatus = dict[@"messageType"];


    if ([dict[@"VCShow"] boolValue] == YES) {
        _topCell.isNewApply = YES;
    }else{
        _topCell.isNewApply = NO;
    }

    if ([ZVCStatus isEqualToString:@"101"]) {
//        [self.navigationController showNotificationWithString:@"您的资料被修改"];
        [self loadDataInfo];
    }else if ([ZVCStatus isEqualToString:@"102"]){
//        [self.navigationController showNotificationWithString:@"您有新的审批"];
         _topCell.isNewApply = YES;

    }else if ([ZVCStatus isEqualToString:@"104"]){

        
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您被踢出家庭组" preferredStyle: UIAlertControllerStyleAlert];

        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            // 新建将要push的控制器
            homeVC * home = [[homeVC alloc] init];
            // 获取当前路由的控制器数组
            NSMutableArray * vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            // 获取档期控制器在路由的位置
            int indexVC = (int)[vcArr indexOfObject:self];
            // 移除当前路由器
            [vcArr removeObjectAtIndex:indexVC];
            // 添加新控制器
            [vcArr addObject:home];
            // 重新设置当前导航控制器的路由数组
            [self.navigationController setViewControllers:vcArr animated:YES];


            [UserCenter shareUserCenter].homenumer = nil;
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"UserHomeNumber"];

        }];
        [alert addAction:cancel];

        [self presentViewController:alert animated:YES completion:nil];

    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
     [self loadDataInfo];
}
- (void)loadDataInfo{
    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId intValue]),
                            @"homeNo":[UserCenter shareUserCenter].homenumer
                            };
    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryHomeUserList" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {
//            weakSelf.familyArr = [FamilyPerson mj_objectArrayWithKeyValuesArray:dict1[@"data"]];

            NSMutableArray * topOne = [FamilyPerson mj_objectArrayWithKeyValuesArray:dict1[@"data"]];

            if (topOne == NULL || [topOne isKindOfClass:[NSNull class]] || topOne == nil || topOne.count <=0) {

                // 让[刷新控件]结束刷新
                [weakSelf.tableView.mj_header endRefreshing];

                
                UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您被踢出家庭组" preferredStyle: UIAlertControllerStyleAlert];
                
                        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                            // 新建将要push的控制器
                            homeVC * home = [[homeVC alloc] init];
                            // 获取当前路由的控制器数组
                            NSMutableArray * vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                            // 获取档期控制器在路由的位置
                            int indexVC = (int)[vcArr indexOfObject:self];
                            // 移除当前路由器
                            [vcArr removeObjectAtIndex:indexVC];
                            // 添加新控制器
                            [vcArr addObject:home];
                            // 重新设置当前导航控制器的路由数组
                            [self.navigationController setViewControllers:vcArr animated:YES];
                

                            [UserCenter shareUserCenter].homenumer = nil;
                            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"UserHomeNumber"];

                        }];
                        [alert addAction:cancel];
                
                        [self presentViewController:alert animated:YES completion:nil];

                return ;
            }
            
            [weakSelf.familyArr removeAllObjects];
            for (int i = 0; i<topOne.count; i++) {
                FamilyPerson * top = topOne[i];
                if ([top.userId isEqualToString:[UserCenter shareUserCenter].userId]) {
                    [weakSelf.familyArr addObject:top];
                }
            }

            for (int i = 0; i<topOne.count; i++) {
                FamilyPerson * person = topOne[i];
                if (![person.userId isEqualToString:[UserCenter shareUserCenter].userId]) {
                    [weakSelf.familyArr addObject:person];
                }
            }



            [weakSelf.tableView reloadData];
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_header endRefreshing];

        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

- (void)setupRefresh{

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataInfo)];
    
}


- (void)setupTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.editing = YES;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[HomePersonCell class] forCellReuseIdentifier:kHomePersonCell];
    [_tableView registerClass:[newPersonCell class] forCellReuseIdentifier:knewPersonCell];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;




}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [_familyArr count] + 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        _topCell = [tableView dequeueReusableCellWithIdentifier:knewPersonCell];
        if (!_topCell) {
            _topCell = [tableView dequeueReusableCellWithIdentifier:knewPersonCell forIndexPath:indexPath];
        }
//        _topCell.isNewApply = isNewApply;
        _topCell.isNewAdd = _isShow;
        _topCell.selectionStyle =UITableViewCellSelectionStyleNone;
        return _topCell;
    }

    HomePersonCell * cell = [tableView dequeueReusableCellWithIdentifier:kHomePersonCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kHomePersonCell forIndexPath:indexPath];
    }
    FamilyPerson * person = _familyArr[indexPath.section - 1];
    cell.family_name = person.nickName;
    cell.family_age = person.age;
    cell.family_sex = person.sex;
    cell.headURL = person.imgSource;
    cell.isHidentView = _isShow;
    NSLog(@"%@",person.userId);
    if ([person.userId isEqualToString:[UserCenter shareUserCenter].userId]) {
        cell.isMe = YES;
    }
    [cell.reportBtn addTarget:self action:@selector(reportList:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(editFamilyPerson:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deletBtn addTarget:self action:@selector(deleteInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)editFamilyPerson:(UIButton *)sender{

    UIView  * view = sender.superview;

    UIView * view1 = view.superview;

    if ([view1 isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view1];

        NSLog(@"indexPath%ld",(long)indexPath.section);
        FamilyPerson * person = _familyArr[indexPath.section - 1];
        NewPersonVC * editPerson = [[NewPersonVC alloc] init];
        editPerson.isnewPerson = NO;
        editPerson.userId = person.userId;
        [self.navigationController pushViewController:editPerson animated:YES];
    }

    
}

- (void)reportList:(UIButton *)sender{
    UIView  * view = sender.superview;

    UIView * view1 = view.superview;

    if ([view1 isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view1];

        ListViewController * list = [[ListViewController alloc] init];
         FamilyPerson * person = _familyArr[indexPath.section - 1];
        list.userID = person.userId;
//        list.isFamily = YES;
        [self.navigationController pushViewController:list animated:YES];


    }
}


- (void)deleteInfo:(UIButton *)sender{
    UIView  * view = sender.superview;

    UIView * view1 = view.superview;

        if ([view1 isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)view1];

            NSLog(@"indexPath%ld",(long)indexPath.section);
            FamilyPerson * person = _familyArr[indexPath.section - 1];
            NSString * append =@"您确定要删除";
            NSString * name = [append stringByAppendingString:person.nickName];


            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:name preferredStyle: UIAlertControllerStyleAlert];

            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {



            }];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


                NSDictionary * dict = @{@"userId":@([person.userId intValue]),@"opUserId":[UserCenter shareUserCenter].userId};
                    __weak typeof(self) weakSelf = self;
                [[DataManager manager] postDataWithUrl:@"doQuitHome" parameters:dict success:^(id json) {
                    NSDictionary * dict = json;
                    if ([dict[@"status"] intValue] == 1) {

                        [weakSelf.familyArr removeObjectAtIndex:indexPath.section - 1];

                        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];

                        [weakSelf.tableView reloadData];
                        
                    }else{
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
                
            }];
            [alert addAction:cancel];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];


//            [_tableView beginUpdates];


        }




}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (_isShow == YES) {
            [self creatNewFamilyPerson];
        }else{
            ApplyVC * apply = [[ApplyVC alloc] init];
            [self.navigationController pushViewController:apply animated:YES];
        }

    }else{

        if (indexPath.section == 1) {

        return;


        }
        if (_isShow == NO) {

            FamilyPerson * person = _familyArr[indexPath.section - 1];
            [self changeAccount:person.userId];
        }
    }

}


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

            if (_reloadNH) {
                _reloadNH(user.name,user.source);
            }
//            [weakSelf.tableView reloadData];
        }else{

        }

    } failure:^(NSError *error) {

    }];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, 28)];
        _familyNum = [[UILabel alloc] initWithFrame:CGRectMake(12, 5,self.view.cl_width/2, 20)];
        _familyNum.text = [NSString stringWithFormat:@"家庭组号:%@",[UserCenter shareUserCenter].homenumer];
        _familyNum.font = [UIFont systemFontOfSize:13.0];
        _familyNum.textColor = [UIColor colorWithHexString:@"#737f7f"];
        [view addSubview:_familyNum];
        return view;
    }else if (section == [_familyArr count] || [_familyArr count] ==1){

        UIView * center = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 80)];

        _setBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.cl_width - 95)/2, 40, 95, 23)];
        NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:@"退出家庭组"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9aa9a9"] range:titleRange];

        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [_setBtn setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];
        [_setBtn setAttributedTitle:title forState:UIControlStateNormal];

        NSMutableAttributedString * title1 = [[NSMutableAttributedString alloc] initWithString:@"退出家庭组"];
        NSRange titleRange1 = {0,[title1 length]};
        [title1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#d23030"] range:titleRange1];

        [title1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange1];
        [_setBtn setTitleColor:[UIColor colorWithHexString:@"#d23030"] forState:UIControlStateNormal];
        [_setBtn setAttributedTitle:title1 forState:UIControlStateHighlighted];



        _setBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_setBtn addTarget:self action:@selector(loseFamily:) forControlEvents:UIControlEventTouchUpInside];
        [center addSubview:_setBtn];

//        _PersonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _PersonBtn.frame = CGRectMake((self.view.cl_width - 195) / 2, 40, 195, 40);
//        [_PersonBtn setTitle:@"新增家庭成员" forState:UIControlStateNormal];
//        [_PersonBtn setTitleColor:[UIColor colorWithHexString:@"0fc2af"] forState:UIControlStateNormal];
//        [_PersonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [_PersonBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [_PersonBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
//        _PersonBtn.layer.cornerRadius = 5;
//        _PersonBtn.layer.masksToBounds = YES;
//        _PersonBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
//        _PersonBtn.layer.borderWidth = 1;
//        [_PersonBtn addTarget:self action:@selector(creatNewFamilyPerson) forControlEvents:UIControlEventTouchUpInside];
//        [center addSubview:_PersonBtn];
        if (_isShow) {
//            _PersonBtn.hidden = NO;
            _setBtn.hidden = YES;
        }else{
//        _PersonBtn.hidden = YES;
            _setBtn.hidden = NO;
        }
        return center;

    }

    UIView * view =[[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];


    return view;
}


- (void)loseFamily:(UIButton *)sender{

    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出家庭组" preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

     

    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


        NSDictionary * dict = @{@"userId":@([[UserCenter shareUserCenter].userId intValue])};
        [[DataManager manager] postDataWithUrl:@"doQuitHome" parameters:dict success:^(id json) {
            NSDictionary * dict = json;
            if ([dict[@"status"] intValue] == 1) {

                // 新建将要push的控制器
                homeVC * home = [[homeVC alloc] init];
                // 获取当前路由的控制器数组
                NSMutableArray * vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                // 获取档期控制器在路由的位置
                int indexVC = (int)[vcArr indexOfObject:self];
                // 移除当前路由器
                [vcArr removeObjectAtIndex:indexVC];
                // 添加新控制器
                [vcArr addObject:home];
                // 重新设置当前导航控制器的路由数组
                [self.navigationController setViewControllers:vcArr animated:YES];

                [UserCenter shareUserCenter].homenumer = nil;
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"UserHomeNumber"];

            }else{

            }

        } failure:^(NSError *error) {

        }];



    }];
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)creatNewFamilyPerson{
    NewPersonVC * newpersonVC = [[NewPersonVC alloc] init];
    newpersonVC.isnewPerson = YES;
    [self.navigationController pushViewController:newpersonVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40.0f;
    }

    return 52.5f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 28.0f;
    }else if (section == [_familyArr count] ){
        return 80.0f;
    }

    return 12.5f;
}


- (void)setNavigationView{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 60, 40)];
//    rightBtn.backgroundColor = [UIColor redColor];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -25)];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightBtn addTarget:self action:@selector(editFamilyGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];


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

    self.title = @"家庭组";
    
}

- (void)editFamilyGroup:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _isShow = YES;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [_tableView reloadData];

    }else{
         [sender setTitle:@"编辑" forState:UIControlStateNormal];
        _isShow = NO;
        [_tableView reloadData];
    }
}

- (void)popPersonCenter:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
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



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNewPersonApply" object:nil];
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
