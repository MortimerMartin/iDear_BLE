 //
//  MobileVC.m
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "MobileVC.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
#import "WLCaptcheButton.h"
#import "UIColor+HexString.h"
#import "JVFloatLabeledTextField.h"
#import "DataManager.h"
#import "SVProgressHUD.h"
#import "homZVC.h"
#import "ZYScalesViewController.h"
@interface MobileVC ()<UITextFieldDelegate>
{
    UIView * phoneL;
    UIView * passP;
}
@property (nonatomic , strong) JVFloatLabeledTextField * PhoneNum;

@property (nonatomic , strong) JVFloatLabeledTextField * passWord;

@property (nonatomic , strong) WLCaptcheButton * isExist;
@end

@implementation MobileVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationView];
    [self setupLoginView];
    [self layoutLoginView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLoginView{
    self.PhoneNum = [[JVFloatLabeledTextField alloc] init];
    self.PhoneNum.font = [UIFont systemFontOfSize:15];

//    _PhoneNum.keyboardType = UIKeyboardTypePhonePad;
    _PhoneNum.clearButtonMode = UITextFieldViewModeAlways;
    _PhoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                      attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _PhoneNum.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _PhoneNum.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _PhoneNum.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _PhoneNum.floatingLabel.text = @"手机号";
    _PhoneNum.textColor = [UIColor colorWithHexString:@"#303434"];
    _PhoneNum.delegate = self;
    [self.view addSubview:_PhoneNum];



    self.passWord = [[JVFloatLabeledTextField alloc] init];
    self.passWord.font = [UIFont systemFontOfSize:15];
//    _passWord.keyboardType = UIKeyboardTypePhonePad;
    _passWord.clearButtonMode = UITextFieldViewModeAlways;
    _passWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                      attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _passWord.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _passWord.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];

    _passWord.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _passWord.floatingLabel.text = @"验证码";
    _passWord.textColor = [UIColor colorWithHexString:@"#303434"];

    [self.view addSubview:_passWord];

    phoneL = [[UIView alloc] init];
    phoneL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.view addSubview:phoneL];


    passP = [[UIView alloc] init];
    passP.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.view addSubview:passP];




    self.isExist = [[WLCaptcheButton alloc] init];
    _isExist.identifyKey = @"Exist";
    [_isExist setTitle:@"获取验证码" forState:UIControlStateNormal];
    _isExist.titleLabel.font = [UIFont systemFontOfSize:13];
    _isExist.backgroundColor = [UIColor colorWithHexString:@"#0fc2af"];
    _isExist.disabledBackgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];

    _isExist.disabledTitleColor = [UIColor whiteColor];
    _isExist.layer.cornerRadius = 5.0;
    _isExist.layer.masksToBounds = YES;
    [self.view addSubview:_isExist];
    [_isExist addTarget:self action:@selector(getMessage:) forControlEvents:UIControlEventTouchUpInside];




}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_PhoneNum resignFirstResponder];
    [_passWord resignFirstResponder];
}
//切换登录页面
//- (void)changeViewController:(UIButton *)sender{
//
//    [_PhoneNum resignFirstResponder];
//    [_passWord resignFirstResponder];
//
//
//
//
//
//
//
//}

//获取验证码
- (void)getMessage:(WLCaptcheButton *)sender{

    if ([self valiMobile:_PhoneNum.text] == NO) {

        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机格式"];
        return;
    }



    NSDictionary * dict = @{
                            @"userId":_B_userId,
                            @"mobile":_PhoneNum.text
                            };
    [[DataManager manager] postDataWithUrl:@"doGetHomeCode" parameters:dict success:^(id json) {

        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {
            [sender fire];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您的手机号已绑定"];
        }


    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
    }];



}


//判断手机号码格式是否正确
-(BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */  NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];

        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (![self valiMobile:_PhoneNum.text]) {

        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机格式"];
        return;
    }
}




- (void)layoutLoginView{


    [_PhoneNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150);

        make.left.equalTo(self.view).offset(36);
        make.right.equalTo(self.view).offset(-36);
        make.height.mas_equalTo(40);
    }];

    [_passWord mas_updateConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_PhoneNum.mas_bottom).offset(20);
        make.left.equalTo(_PhoneNum);
        make.right.equalTo(_isExist.mas_left).offset(-20);
        make.height.equalTo(_PhoneNum);


    }];


    [phoneL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_PhoneNum);
        make.top.equalTo(_PhoneNum.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    [passP mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_passWord);
        make.top.equalTo(_passWord.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];


    [_isExist mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passWord);
        make.right.equalTo(_PhoneNum);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(80);
    }];
    

}

- (void)setNavigationView{

    UIButton * leftdetailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [leftdetailButton setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    [leftdetailButton setTitle:@"上一步" forState:UIControlStateNormal];
    leftdetailButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftdetailButton addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftdetailButton];


    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};


    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [detailButton setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    [detailButton setTitle:@"提交" forState:UIControlStateNormal];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [detailButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [detailButton addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];

    self.title = @"绑定手机号";
    
}
- (void)saveInfo:(UIButton *)sender{
    if (![self valiMobile:_PhoneNum.text]) {

        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机格式"];
        return;
    }
    
    if (_passWord.text.length != 4) {
        [SVProgressHUD showErrorWithStatus:@"请使用正确的验证码"];
        return;
    }

    if ([self deptNumInputShouldNumber:_passWord.text] == NO) {
        [SVProgressHUD showErrorWithStatus:@"请使用正确的验证码"];
        return;
    }

    NSDictionary * dict = @{
                            @"userId":_B_userId,
                            @"mobile":_PhoneNum.text,
                            @"code":_passWord.text
                            };

    [[DataManager manager] postDataWithUrl:@"doBindHomeMobile" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"]  intValue] == 1) {
            if (_showMobile) {
                _showMobile(YES);
            }

            for (UIViewController * controller in self.navigationController.viewControllers) {
                if (_WAYF && [_WAYF isEqualToString:@"fromZYSVC"]) {
                    if ([controller isKindOfClass:[ZYScalesViewController class]]) {
                        ZYScalesViewController * zys = (ZYScalesViewController *)controller;
                        [self.navigationController popToViewController:zys animated:YES];
                    }

                }else{
                    if ([controller isKindOfClass:[homZVC class]]) {
                        homZVC * zvc = (homZVC *)controller;
                        [self.navigationController popToViewController:zvc animated:YES];
                    }
                }

            }

//            [self.navigationController popToViewController:[[homZVC alloc] init] animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

- (void)backHome:(UIButton *)sender{
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
