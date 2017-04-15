//
//  JoinHomeVVC.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "JoinHomeVVC.h"
#import "JoinHomeVC.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "MobileVC.h"
#import "UIView+CLExtension.h"
#import "homeVC.h"
#import "DataManager.h"
#import "SVProgressHUD.h"
#import "UserCenter.h"
@interface JoinHomeVVC ()
{
    UIView * topL;
    UIView * underLine;
}
@property (nonatomic , strong) UIView * home_numView;
@property (nonatomic , strong) UITextField * Account;
@property (nonatomic , strong) UILabel * personN;


@end

@implementation JoinHomeVVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationView];
    [self setupLastViews];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLastViews{


    _home_numView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _home_numView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    [self.view addSubview:_home_numView];


    _personN = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, self.view.frame.size.width - 9, 30)];
    _personN.text = [NSString stringWithFormat:@"该家庭组创建人为:%@",_homeName];
    _personN.font = [UIFont systemFontOfSize:14.0];
    _personN.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_home_numView addSubview:_personN];


    topL = [[UIView alloc] initWithFrame:CGRectMake(0, 30.5, self.view.frame.size.width, 0.5)];
    topL.backgroundColor =[UIColor colorWithHexString:@"#c9cdcd"];
    [_home_numView addSubview:topL];

    UIView * topweightView = [[UIView alloc] initWithFrame:CGRectMake(0, 31, self.view.cl_width, 51)];
    topweightView.backgroundColor = [UIColor whiteColor];
    [_home_numView addSubview:topweightView];
    
    self.Account = [[UITextField alloc] initWithFrame:CGRectMake(9, 31, self.view.cl_width - 19, 51)];
    self.Account.font = [UIFont systemFontOfSize:15];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_delete_def"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn_delete_pre"] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(0, 0, 16, 16);
    self.Account.rightView = rightBtn;
    self.Account.rightViewMode = UITextFieldViewModeAlways;
    self.Account.backgroundColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    _Account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入申请加入家庭组备注..."
                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
//    _Account.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
//    _Account.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];
//    _Account.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
//    _Account.floatingLabel.text = @"备注";
    _Account.textColor = [UIColor colorWithHexString:@"#303434"];
    _Account.keyboardType = UIKeyboardTypeDefault;
    [_home_numView addSubview:_Account];



    underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 82.5, self.view.frame.size.width, 0.5)];
    underLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [_home_numView addSubview:underLine];


}

-(void)clearTextField:(UIButton *)sender{
    self.Account.text = nil;
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


    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [detailButton setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    [detailButton setTitle:@"提交" forState:UIControlStateNormal];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [detailButton addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];

    self.title = @"加入家庭组";

}

- (void)popPersonCenter:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveInfo:(UIButton *)sender{

    [_Account resignFirstResponder];

    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId intValue]),
                            @"homeNo":_homeNumer,
                            @"remark":_Account.text
                            };


    [[DataManager manager] postDataWithUrl:@"doAddApprove" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

//            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"信息提交成功" message:@"是否绑定手机号" preferredStyle: UIAlertControllerStyleAlert];
//
//            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                        [kUserDefaults setBool:YES forKey:@"kCancel"];
                        [kUserDefaults synchronize];

                UIViewController *viewCtl = self.navigationController.viewControllers[1];

                [self.navigationController popToViewController:viewCtl animated:YES];

                //        [self.navigationController popToRootViewControllerAnimated:YES];
                //        [self pushHomeVC];
//            }];
//            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                MobileVC * mobile = [[MobileVC alloc] init];
//                [self.navigationController pushViewController:mobile animated:YES];
//                
//            }];
//            [alert addAction:cancel];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];

        }else{
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }

    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];





    
}

- (void)pushHomeVC{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[homeVC class]]) {
            homeVC *A =(homeVC *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }
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
