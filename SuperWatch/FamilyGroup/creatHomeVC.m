//
//  creatHomeVC.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "creatHomeVC.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "homZVC.h"
#import "DataManager.h"
#import "SVProgressHUD.h"
#import "UserCenter.h"
@interface creatHomeVC ()
@property (nonatomic , strong) UIView * joinHomeView;
@end

@implementation creatHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationView];
    [self creatFamilyView];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    //    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -rightBtn.currentImage.size.width, 0, 0)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};



    
    self.title = @"创建家庭组";
    
}

- (void)creatFamilyView{
    _joinHomeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _joinHomeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_joinHomeView];
    UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinBtn setTitle:@"创 建 家 庭 组" forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [joinBtn setTitleColor:[UIColor colorWithHexString:@"0fc2af"] forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [joinBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [joinBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
    joinBtn.layer.cornerRadius = 5;
    joinBtn.layer.masksToBounds = YES;
    joinBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
    joinBtn.layer.borderWidth = 1;
    [joinBtn addTarget:self action:@selector(creatHomeView) forControlEvents:UIControlEventTouchUpInside];
    [_joinHomeView addSubview:joinBtn];

    UILabel * message = [[UILabel alloc] init];
//    message.backgroundColor = [UIColor redColor];
    message.text = @"创建家庭组，与家庭成员共享数据，关注彼此健康与成长。";
    message.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    message.textAlignment = NSTextAlignmentCenter;
    message.numberOfLines = 2;
    message.font = [UIFont systemFontOfSize:15];
    [_joinHomeView addSubview:message];



    [joinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(message.mas_top).offset(-20);
        make.width.mas_equalTo(192);
        make.height.mas_equalTo(40);
    }];

    [message mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(40);
//        make.left.equalTo(joinBtn).offset(-8);
//        make.right.equalTo(joinBtn).offset(60);
    }];

    
}

- (void)creatHomeView{


    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId integerValue])
                            };

    [[DataManager manager] postDataWithUrl:@"doCreateHome" parameters:dict success:^(id json) {

        NSDictionary * dict1 = json;

        if ([dict1[@"status"] intValue] == 1) {

            [kUserDefaults setBool:YES forKey:@"kCancel"];
            [kUserDefaults synchronize];
            
            [UserCenter shareUserCenter].homenumer = dict1[@"message"];
            [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].homenumer forKey:@"UserHomeNumber"];
            // 新建将要push的控制器
            homZVC * home = [[homZVC alloc] init];
            // 获取当前路由的控制器数组
            NSMutableArray * vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            // 获取档期控制器在路由的位置
            int indexVC = (int)[vcArr indexOfObject:self];
            // 移除当前路由器
            [vcArr removeObjectAtIndex:indexVC];
            [vcArr removeObjectAtIndex:1];
            // 添加新控制器
            [vcArr insertObject:home atIndex:1];
            // 重新设置当前导航控制器的路由数组
            [self.navigationController setViewControllers:vcArr animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"创建家庭组失败"];
        }


    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"创建家庭组失败"];
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

- (void)popPersonCenter:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
