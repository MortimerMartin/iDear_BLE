//
//  LeftViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "LeftViewController.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "Masonry.h"
#import "PersonCenterVC.h"
//#import "PersonHistoryVC.h"
//#import "ListViewController.h"
#import "UserCenter.h"
#import "UIImageView+WebCache.h"

#import "GTMBase64.h"
#import "SVProgressHUD.h"
#import "DataManager.h"

//#import "WristVC.h"
#import "LeftTableViewCell.h"
#import "CHEditVC.h"
#import "YSXViewController.h"
//#define kLeftTableViewCell @"kLeftTableViewCell"
@interface LeftViewController ()<UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString * source;
    NSString * name;
}
@property(nonatomic , strong) UIImageView * headImg;


@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) UIButton * person_info;
@property (nonatomic , strong) UIButton * person_history;
@property (nonatomic , strong) UIButton * person_list;
@property (nonatomic , strong) UIButton * setBtn;

@property (nonatomic , strong) NSArray * left_funArray;

@end

@implementation LeftViewController
static NSString * kLeftTableViewCell = @"kLeftTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupLeftView];
    [self layoutLeftViews];

    // Do any additional setup after loading the view.
}

- (void)loadNewSelfInfo{
    NSDictionary * dict = @{@"userId":@([[UserCenter shareUserCenter].userId integerValue])};
   __weak typeof(self) weakSelf = self;
    [[DataManager manager ]postDataWithUrl:@"doQueryUser" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

            UserCenter * user = [UserCenter shareUserCenter];

            user.height = [dict1[@"data"][@"height"] stringValue];

            user.age = [dict1[@"data"][@"age"] stringValue];

            if (dict1[@"data"][@"imgSource"] == NULL || [dict1[@"data"][@"imgSource"] isKindOfClass:[NSNull class]]) {
//                user.source = nil;
                if ([UserCenter shareUserCenter].source) {
                    [weakSelf.headImg sd_setImageWithURL:[NSURL URLWithString:[UserCenter shareUserCenter].source]];
                }else{
                    weakSelf.headImg.image = [UIImage imageNamed:@"icon"];
                }

            }else{
                user.source = dict1[@"data"][@"imgSource"] ;
                source = user.source;
                name = user.name;
                [weakSelf.headImg sd_setImageWithURL:[NSURL URLWithString:user.source]];

                [[NSUserDefaults standardUserDefaults] setValue:user.source forKey:@"UserSource"];
            }
            user.bithday = dict1[@"data"][@"birthday"] ;

            user.sex = dict1[@"data"][@"sex"];
 
            user.name = dict1[@"data"][@"nickName"] ;



            [user saveUserDefaults];
        }

    } failure:^(NSError *error) {

    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"Left will appear");
    BOOL yes = YES;
    if (_isShow) {
        _isShow(yes ,source , name);
    }
    [self loadNewSelfInfo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Left did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BOOL yes = NO;
    if (_isShow) {
        _isShow(yes, source, name);
    }
    NSLog(@"Left will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"Left did disappear");
}


- (void)setupLeftView{
    _headImg = [[UIImageView alloc] init];
//    _headImg.backgroundColor = [UIColor brownColor];
    _headImg.layer.cornerRadius = 42;
    _headImg.layer.masksToBounds = YES;
    _headImg.userInteractionEnabled = YES;



    if (![UserCenter shareUserCenter].source) {
        _headImg.image = [UIImage imageNamed:@"icon"];
    }else{
        [_headImg sd_setImageWithURL:[NSURL URLWithString:[UserCenter shareUserCenter].source]];
    }

//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentImgheadViewController:)];
//    [_headImg addGestureRecognizer:tap];
    [self.view addSubview:_headImg];

    _left_funArray = @[@[@"family_btn_compole_def",@"family_btn_report_def",@"nav_icon_bracelet",@"nav_icon_report"],@[@"我的资料",@"我的记录",@"手环设置",@"数据参照表"]];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kLeftTableViewCell];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];

    


    _setBtn = [[UIButton alloc] init];
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:@"退出登陆"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9aa9a9"] range:titleRange];

    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    NSMutableAttributedString * title1 = [[NSMutableAttributedString alloc] initWithString:@"退出登陆"];
    NSRange titleRange1 = {0,[title length]};
    [title1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#d23030"] range:titleRange1];

    [title1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange1];


//    [_setBtn setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];
//    [_setBtn setTitleColor:[UIColor colorWithHexString:@"#d23030"] forState:UIControlStateHighlighted];

    [_setBtn setAttributedTitle:title forState:UIControlStateNormal];
    [_setBtn setAttributedTitle:title1 forState:UIControlStateHighlighted];
    _setBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_setBtn addTarget:self action:@selector(losePerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setBtn];


}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_left_funArray[0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell forIndexPath:indexPath];
    }

    cell.normal_img = _left_funArray[0][indexPath.row];
    cell.cell_title = _left_funArray[1][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PersonCenterVC * center = [[PersonCenterVC alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:center];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (indexPath.row == 1){
        YSXViewController * ysx = [[YSXViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ysx];
        [self presentViewController:nav animated:YES completion:nil];

    }else if (indexPath.row == 2){
        CHEditVC * edit = [[CHEditVC alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:edit];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (indexPath.row == 3){


    } else{

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


- (void)losePerson:(UIButton *)sender{
    [[UserCenter shareUserCenter] logout];
}

- (void)layoutLeftViews{
    [_headImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(82);
        make.top.equalTo(self.view).offset(64);
    }];

    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImg.mas_bottom).offset(40);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40*[_left_funArray[0] count]);
    }];


    [_setBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headImg);
        make.bottom.equalTo(self.view).offset(-30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];

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
