//
//  PersonLastVC.m
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonLastVC.h"
#import "UIColor+HexString.h"
#import "JVFloatLabeledTextField.h"
#import "PersonCenterVC.h"
#import "UIView+CLExtension.h"
#import "UIImage+ZYImage.h"
#import "Masonry.h"
#import "UserCenter.h"
#import "SVProgressHUD.h"
#import "DataManager.h"
@interface PersonLastVC ()<UITextFieldDelegate>
{
    UIView * topL;
    UIView * underLine;
    BOOL isChoose;
    UIView * shadeView;
    UIView * centerView;

}


@property (nonatomic , strong) UIButton * okBtn;

@property (nonatomic , strong) UIButton * cancelBtn;

@property (nonatomic , strong) UIButton * ManBtn;

@property (nonatomic , strong) UIButton * WomenBtn;

@property (nonatomic , strong)  UIDatePicker * pickView;

@property (nonatomic , strong) UILabel * label;

@property (nonatomic , strong) UITextField * Account;

@property (nonatomic , strong) UIView * anmationView;

@end

@implementation PersonLastVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationView];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    if ([_VCtitle isEqualToString:@"我的性别"]) {
        [self setupSexView];
    }else{
        [self setupLastViews];
    }


}
- (void)savePersonInfo:(UIButton *)sender{
    if ([_VCtitle isEqualToString:@"我的性别"]) {
        if (_ManBtn.selected == YES ) {


            NSDictionary * dict = @{
                                    @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                                    @"sex":@"男"
                                    };
            [[DataManager manager] postDataWithUrl:@"doUpdateUser" parameters:dict success:^(id json) {
                NSDictionary * dict1 = json;
                if ([dict1[@"status"] intValue] == 1) {

                    [UserCenter shareUserCenter].sex = @"男";
                    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].sex forKey:@"UserSex"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                        [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请求失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }];
        } else if (_WomenBtn.selected == YES){

            NSDictionary * dict = @{
                                    @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                                    @"sex":@"女"
                                    };
            [[DataManager manager] postDataWithUrl:@"doUpdateUser" parameters:dict success:^(id json) {
                NSDictionary * dict1 = json;
                if ([dict1[@"status"] intValue] == 1) {

                    [UserCenter shareUserCenter].sex = @"女";
                    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].sex forKey:@"UserSex"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请求失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }];

        } else{
            [SVProgressHUD showErrorWithStatus:@"请选择您的性别"];
            return;
        }

    } else if ([_VCtitle isEqualToString:@"我的身高"]){
        if ( [self deptNumInputShouldNumber:_Account.text] == NO) {
            [SVProgressHUD showErrorWithStatus:@"请输入纯数字"];
            return;
        }

        if (_Account.text.length <= 1 || _Account.text.length >3) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
            return;
        }

        NSString * str = _Account.text;
        int height = [str intValue];
        if (height > 250) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
            return;
        }


        NSDictionary * dict = @{
                                @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                                @"height":_Account.text
                                };

        [[DataManager manager] postDataWithUrl:@"doUpdateUser" parameters:dict success:^(id json) {

            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {

                [UserCenter shareUserCenter].height = _Account.text;
                [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].height forKey:@"UserHeight"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }

        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];




    } else if ([_VCtitle isEqualToString:@"我的年龄"]){

        if (isChoose == NO) {

            return;
        }

        NSString * dateBlock = [self timeFormat];

        NSDictionary * dict = @{
                                @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                                @"birthday":dateBlock
                                };

        [[DataManager manager] postDataWithUrl:@"doUpdateUser" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {

                [UserCenter shareUserCenter].bithday = dateBlock;
                [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].bithday forKey:@"UserBirthDay"];


                [UserCenter shareUserCenter].age = [NSString stringWithFormat:@"%d",[self getAge]];
                [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].age forKey:@"UserAge"];

                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];


    }else{


        if (_Account.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入名字"];
            return ;
        }
        if (_Account.text.length >5) {
            [SVProgressHUD showErrorWithStatus:@"请输入小于等去五个字符"];
            return;
        }

        NSDictionary * dict = @{
                                @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                                @"nickName":_Account.text
                                };

        [[DataManager manager] postDataWithUrl:@"doUpdateUser" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {

                [UserCenter shareUserCenter].name = _Account.text;
                [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].name forKey:@"UserName"];

                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];




    }


}

- (int)getAge{
    NSString * birth = [self timeFormat];
    if (birth.length<=0) {
        return [[UserCenter shareUserCenter].age intValue];
    }
    NSDateFormatter * dataFormatter  = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * birthday = [dataFormatter dateFromString:birth];

    NSString * currenDateStr = [dataFormatter stringFromDate:[NSDate date]];
    NSDate * currentDate = [dataFormatter dateFromString:currenDateStr];
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthday];

    int age = ((int)time)/(3600*24*365);
    if (age == 0) {
        age =1;
    }

    NSLog(@"age____%d",age);
    return age;
}

- (void)setupLastViews{


    _anmationView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _anmationView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    [self.view addSubview:_anmationView];


    _label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.view.frame.size.width - 8, 37)];
    if ([_VCtitle isEqualToString:@"我的身高"]) {
        _label.text = [NSString stringWithFormat:@"%@(cm)",_VCtitle];
    }else if([_VCtitle isEqualToString:@"我的昵称"]){

        _label.text = [NSString stringWithFormat:@"%@ (昵称长度小于等于5)",_VCtitle];
    }else{
        _label.text = _VCtitle;
    }

    _label.font = [UIFont systemFontOfSize:14.0];
    _label.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_anmationView addSubview:_label];


    topL = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.frame.size.width, 0.5)];
    topL.backgroundColor =[UIColor colorWithHexString:@"#c9cdcd"];
    [_anmationView addSubview:topL];


    UIView * topweightView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.cl_width, 53)];
    topweightView.backgroundColor = [UIColor whiteColor];
    [_anmationView addSubview:topweightView];

        self.Account = [[UITextField alloc] initWithFrame:CGRectMake(8, 40, self.view.cl_width - 18, 53)];
        self.Account.font = [UIFont systemFontOfSize:15];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_delete_def"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn_delete_pre"] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(0, 0, 16, 16);
    self.Account.rightView = rightBtn;
    self.Account.rightViewMode = UITextFieldViewModeWhileEditing;

    [rightBtn addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
      self.Account.backgroundColor = [UIColor whiteColor];
//        _Account.clearButtonMode = UITextFieldViewModeAlways;
//        _Account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_VCinfo
//                                                                         attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];

    _Account.text = _VCinfo;
    _Account.textColor = [UIColor colorWithHexString:@"#303434"];
    _Account.delegate =self;

        [_anmationView addSubview:_Account];
    if ([_VCtitle isEqualToString:@"我的身高"]) {
        NSArray * arr = [_VCinfo componentsSeparatedByString:@"c"];
        NSString * info1 = arr[0];
        _Account.text = info1;
          [_Account addTarget:self action:@selector(touchupSearch) forControlEvents:UIControlEventEditingChanged];
        
    }



    underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 93.5, self.view.frame.size.width, 0.5)];
    underLine.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];


    [_anmationView addSubview:underLine];


}
-(void)clearTextField:(UIButton *)sender{
    self.Account.text = nil;
}
- (void)touchupSearch{

    if (_Account.text.length>3) {
        _Account.text = nil;
        return;
    }

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


    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [detailButton setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    [detailButton setTitle:@"保存" forState:UIControlStateNormal];
    [detailButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [detailButton addTarget:self action:@selector(savePersonInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];

    self.title = @"修改信息";
    
}
- (void)popPersonCenter:(UITapGestureRecognizer *)tap{


[self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_Account resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_Account resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([_VCtitle isEqualToString:@"我的年龄"]) {
        [self addPickDateView];

        return NO;
    }

    return YES;
}

- (void)setupSexView{

//    self.view.backgroundColor = [UIColor Color];
    _ManBtn = [[UIButton alloc] init];
    //    _ManBtn.backgroundColor = [UIColor blueColor];
    [_ManBtn setTitle:@"男性" forState:UIControlStateNormal];
    _ManBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_ManBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];
    [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_nosel"] forState:UIControlStateNormal];
    [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_def"] forState:UIControlStateHighlighted];

    [self.view addSubview:_ManBtn];

    [_ManBtn setImageEdgeInsets:UIEdgeInsetsMake(-_ManBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_ManBtn.titleLabel.intrinsicContentSize.width)];
    [_ManBtn setTitleEdgeInsets:UIEdgeInsetsMake(_ManBtn.currentImage.size.height + 24, -_ManBtn.currentImage.size.width, 0, 0)];

    _WomenBtn = [[UIButton alloc] init];
    //    _WomenBtn.backgroundColor = [UIColor redColor];
    [_WomenBtn setTitle:@"女性" forState:UIControlStateNormal];
    _WomenBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_WomenBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];

    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_nosel"] forState:UIControlStateNormal];
    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_def"] forState:UIControlStateHighlighted];
//    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateSelected];
    [self.view addSubview:_WomenBtn];

    [_WomenBtn setImageEdgeInsets:UIEdgeInsetsMake(-_WomenBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_WomenBtn.titleLabel.intrinsicContentSize.width)];
    [_WomenBtn setTitleEdgeInsets:UIEdgeInsetsMake(_WomenBtn.currentImage.size.height + 24, -_WomenBtn.currentImage.size.width, 0, 0)];

    [_ManBtn addTarget:self action:@selector(chooseM:) forControlEvents:UIControlEventTouchUpInside];
    [_WomenBtn addTarget:self action:@selector(chooseW:) forControlEvents:UIControlEventTouchUpInside];



    if ([_VCinfo isEqualToString:@"男"]) {

        [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_pre"] forState:UIControlStateNormal];
        _ManBtn.selected = YES;
    }else if ([_VCinfo isEqualToString:@"女"]){
        [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateNormal];
        _WomenBtn.selected = YES;
    }else{

    }

    [_ManBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-self.view.cl_width/4);
        make.height.width.mas_equalTo(150);
        make.centerY.equalTo(self.view);
    }];

    [_WomenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(_ManBtn);
        make.centerX.equalTo(self.view).offset(self.view.cl_width/4);
    }];
}

- (void)chooseW:(UIButton *)sender{

    sender.selected = !sender.selected;

    if (sender.selected) {
        if (_ManBtn.selected) {
            _ManBtn.selected = NO;
            _ManBtn.enabled = YES;
            [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_nosel"] forState:UIControlStateNormal];
        }
        [sender setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateNormal];

    }
    else{
        sender.selected = YES;

    }


}

- (void)chooseM:(UIButton *)sender{
    sender.selected = !sender.selected;


    if (sender.selected) {
        if (_WomenBtn.selected) {
            _WomenBtn.selected = NO;
            _WomenBtn.enabled = YES;
            [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_nosel"] forState:UIControlStateNormal];
        }
        [sender setImage:[UIImage imageNamed:@"login_btn_man_pre"] forState:UIControlStateNormal];

    }
    else{
        sender.selected = YES;

    }


}



- (void)addPickDateView{
//    [_Account resignFirstResponder];
//    [];
//    [self.view endEditing:YES];

    shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
    shadeView.backgroundColor = RGBA(0, 0, 0, 0.6);

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadeView)];
    [shadeView addGestureRecognizer:tap];
    [self.view addSubview:shadeView];
    //    [self bringSubviewToFront:shadeView];

    centerView = [[UIView alloc] init];
//    centerView.layer.cornerRadius = 5;
//    centerView.layer.masksToBounds = YES;
    centerView.backgroundColor = [UIColor whiteColor];
    [shadeView addSubview:centerView];


    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [centerView addSubview:topView];


    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择生日";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor  blackColor];
    [topView addSubview:titleLabel];

    _pickView =  [[UIDatePicker alloc] init];
    _pickView.datePickerMode = UIDatePickerModeDate;
    [_pickView setMaximumDate:[NSDate date]];
    NSDateFormatter * dataFormatter  = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
  
    _pickView.date = [dataFormatter dateFromString:[UserCenter shareUserCenter].bithday];
    [centerView addSubview:_pickView];

    _okBtn = [[UIButton alloc] init];
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"157efb"] forState:UIControlStateNormal];
//    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [_cancelBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [_cancelBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
//    _cancelBtn.layer.cornerRadius = 3;
//    _cancelBtn.layer.masksToBounds = YES;
//    _cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
//    _cancelBtn.layer.borderWidth = 1;


    [topView addSubview:_cancelBtn];



    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    //    _okBtn.backgroundColor = [UIColor redColor];
    [_okBtn setTitleColor:[UIColor colorWithHexString:@"157efb"] forState:UIControlStateNormal];
//    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [_okBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [_okBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
//    _okBtn.layer.cornerRadius = 3;
//    _okBtn.layer.masksToBounds = YES;
//    _okBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
//    _okBtn.layer.borderWidth = 1;
    [topView addSubview:_okBtn];



    [_okBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(removeShadeViewC:) forControlEvents:UIControlEventTouchUpInside];





    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(shadeView);
        make.height.mas_equalTo(310);
    }];


    [_pickView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(centerView);
        make.height.mas_equalTo(260);
    }];


    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(centerView);
        make.bottom.equalTo(_pickView.mas_top);
    }];

    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(topView);
    }];


    [_okBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.centerY.equalTo(topView);
    }];

    [_cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.centerY.equalTo(topView);
    }];
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.pickView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

- (void)chooseDate:(UIButton *)sender{

    // 开始动画
    [self animationbegin:sender];



    _Account.text = [NSString stringWithFormat:@"%d岁",[self getAge]];
    isChoose = YES;


    [self removeShadeView];


}

- (void)removeShadeViewC:(UIButton *)sender{

    // 开始动画
    [self animationbegin:sender];

    _Account.text = _VCinfo;

    [self removeShadeView];

}

- (void)removeShadeView{
    //    [self animationbegin:centerView];
    [UIView animateWithDuration:0.3 animations:^{
        [shadeView removeFromSuperview];
    }];
}

- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */

    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画

    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
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
