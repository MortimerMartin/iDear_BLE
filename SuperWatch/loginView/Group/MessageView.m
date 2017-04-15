//
//  MessageView.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "MessageView.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
#import "WLCaptcheButton.h"
#import "UIColor+HexString.h"
#import "JVFloatLabeledTextField.h"
#import "UserCenter.h"
#import "SVProgressHUD.h"
#import "DataManager.h"
@interface MessageView ()<UITextFieldDelegate>
{
    UIView * phoneL;
    UIView * passP;
}
@property (nonatomic , strong) UIImageView * imgView;

@property (nonatomic , strong) JVFloatLabeledTextField * PhoneNum;

@property (nonatomic , strong) JVFloatLabeledTextField * passWord;

@property (nonatomic , strong) WLCaptcheButton * isExist;

@property (nonatomic , strong) UIButton * loginBtn;


@end
@implementation MessageView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

//        self.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
        self.backgroundColor = [UIColor whiteColor];
        [self setupLoginView];
//        [self.PhoneNum becomeFirstResponder];
    }

    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_PhoneNum resignFirstResponder];
    [_passWord resignFirstResponder];
}

- (void)setupLoginView{

    self.imgView = [[UIImageView alloc] init];
    self.imgView.layer.cornerRadius = 40.0;
    self.imgView.layer.masksToBounds = YES;
//    self.imgView.backgroundColor = [UIColor orangeColor];
    self.imgView.image = [UIImage imageNamed:@"icon"];
    [self addSubview:_imgView];

    self.PhoneNum = [[JVFloatLabeledTextField alloc] init];
    self.PhoneNum.font = [UIFont systemFontOfSize:15];


//    _PhoneNum.clearButtonMode = UITextFieldViewModeAlways;
    _PhoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _PhoneNum.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _PhoneNum.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];
//
//
//
    _PhoneNum.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _PhoneNum.floatingLabel.text = @"手机号";
    _PhoneNum.textColor = [UIColor colorWithHexString:@"#303434"];
// 1111   self.PhoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _PhoneNum.text = [self lastLoginUsername];
    _PhoneNum.delegate = self;
    [self addSubview:_PhoneNum];



    self.passWord = [[JVFloatLabeledTextField alloc] init];
    self.passWord.font = [UIFont systemFontOfSize:15];
//    _passWord.keyboardType = UIKeyboardTypePhonePad;
//    _passWord.clearButtonMode = UITextFieldViewModeAlways;
    _passWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                      attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _passWord.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _passWord.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];

    _passWord.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _passWord.floatingLabel.text = @"验证码";
    _passWord.textColor = [UIColor colorWithHexString:@"#303434"];

    [self addSubview:_passWord];

    phoneL = [[UIView alloc] init];
    phoneL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self addSubview:phoneL];


    passP = [[UIView alloc] init];
    passP.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self addSubview:passP];




    self.isExist = [[WLCaptcheButton alloc] init];
    _isExist.identifyKey = @"Exist";
    [_isExist setTitle:@"获取验证码" forState:UIControlStateNormal];
    _isExist.titleLabel.font = [UIFont systemFontOfSize:13];
    _isExist.backgroundColor = [UIColor colorWithHexString:@"#0fc2af"];
    _isExist.disabledBackgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    
    _isExist.disabledTitleColor = [UIColor whiteColor];
    _isExist.layer.cornerRadius = 5.0;
    _isExist.layer.masksToBounds = YES;
    [self addSubview:_isExist];
    [_isExist addTarget:self action:@selector(getMessage:) forControlEvents:UIControlEventTouchUpInside];


    self.loginBtn = [[UIButton alloc] init];
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#0fc2af"];
    [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 6.0;
    _loginBtn.layer.masksToBounds = YES;
    [self addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];

}
//切换登录页面
- (void)changeViewController:(UIButton *)sender{

    [_PhoneNum resignFirstResponder];
    [_passWord resignFirstResponder];

    if (_PhoneNum.text.length <= 0 ) {
         [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }

    if (_passWord.text.length != 4 ) {
         [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    if ([self valiMobile:_PhoneNum.text] == NO) {
        [SVProgressHUD showErrorWithStatus:@"手机格式错误"];
        return;
    }
    //请求服务器
    NSDictionary * dict1 = @{
                            @"mobile":_PhoneNum.text,
                            @"code":_passWord.text
                            };



    [[DataManager manager] postDataWithUrl:@"doLogin" parameters:dict1 success:^(id json) {
        NSDictionary * dict = json;
        NSInteger status = [dict[@"status"] integerValue];
        if (status == 1) {
            NSInteger statusSTR = [dict[@"data"][@"status"] integerValue];
            NSString * userId = [dict[@"data"][@"userId"] stringValue];
            
            [UserCenter shareUserCenter].phone = _PhoneNum.text;
            [UserCenter shareUserCenter].userId = userId;
            [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].phone forKey:@"UserPhone"];
            [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].userId forKey:@"UserUserId"];

            if (statusSTR == 1) {
                UserCenter * user = [UserCenter shareUserCenter];
                if (dict[@"data"][@"homeNo"] == NULL || [dict[@"data"][@"homeNo"] isKindOfClass:[NSNull class]]) {
                    user.homenumer = nil;
                }else{
                    user.homenumer = dict[@"data"][@"homeNo"];
                }

                user.height = [dict[@"data"][@"height"] stringValue];
                user.userId = [dict[@"data"][@"userId"] stringValue];
                user.age = [dict[@"data"][@"age"] stringValue];

                if (dict[@"data"][@"imgSource"] == NULL || [dict[@"data"][@"imgSource"] isKindOfClass:[NSNull class]]) {
                    user.source = nil;
                }else{
                    user.source = dict[@"data"][@"imgSource"] ;
                }

                user.phone = dict[@"data"][@"mobile"] ;
                user.sex = dict[@"data"][@"sex"];
                NSLog(@"%@",user.sex);
                user.name = dict[@"data"][@"nickName"] ;
                user.bithday = dict[@"data"][@"birthday"] ;
                user.isLogin = YES;

                [user saveUserDefaults];
            }


            if (_isLogin) {
                _isLogin(statusSTR);
            }
        }else{
              [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }




    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"验证吗获取失败"];
    }];




    //切换页面


}

//获取验证码
- (void)getMessage:(WLCaptcheButton *)sender{



    if (_PhoneNum.text.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }

    if ([self valiMobile:_PhoneNum.text] == NO) {
        [SVProgressHUD showErrorWithStatus:@"手机格式错误"];
        return;
    }

    [sender fire];

    //请求服务器
    NSDictionary * dict = @{
                            @"mobile":_PhoneNum.text
                            };


    [[DataManager manager] postDataWithUrl:@"doGetCode" parameters:dict success:^(id json) {
        NSDictionary * dict = json;
        NSString * str = [dict[@"status"] stringValue];
        if (![str isEqualToString:@"1"]) {
             [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
        }

    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
    }];

   

}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self layoutLoginView];



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

    if (_PhoneNum.text.length == 0) {
        return;
    }
    if (![self valiMobile:_PhoneNum.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机格式错误"];
        return;
    }
}

//获得控制器
-  (UIViewController *)viewController{
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]]) {

            return (UIViewController*)nextResponder;

        }
    }
    
    return nil;
}

#pragma  mark - private

- (NSString*)lastLoginUsername
{

    NSString *username  =  [UserCenter shareUserCenter].phone;
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}


- (void)layoutLoginView{
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
//        make.top.equalTo(self).offset(self.cl_height/6);
        make.width.height.mas_equalTo(80);
        make.bottom.equalTo(_PhoneNum.mas_top).offset(-80);
    }];

    [_PhoneNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_centerY).offset(-60);

        make.left.equalTo(self).offset(36);
        make.right.equalTo(self).offset(-36);
        make.height.mas_equalTo(49);
    }];

    [_passWord mas_updateConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(phoneL.mas_bottom).offset(30);
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

    [_loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWord.mas_bottom).offset(80);
        make.centerX.equalTo(self);
        make.left.right.equalTo(_PhoneNum);
        make.height.mas_equalTo(36);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
