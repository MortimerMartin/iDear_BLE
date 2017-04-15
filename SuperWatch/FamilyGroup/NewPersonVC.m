//
//  NewPersonVC.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "NewPersonVC.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "JVFloatLabeledTextField.h"
#import "UIImage+ZYImage.h"
#import "UIView+CLExtension.h"
#import "MobileVC.h"
#import "UserCenter.h"
#import "DataManager.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "GTMBase64.h"
#import "EditPersonModel.h"
#import "MJExtension.h"
@interface NewPersonVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{

    UIView  * heightL;

    UIView * bithDayL;
    UIView * accountL;
    UIView  * shadeVeiw;
    UILabel * headTitle;
    BOOL isChoose;
    BOOL isPhoto;
//    UIView * shadeView;
    UIView * centerView;

}

@property (nonatomic , copy) UIView * shadeView;

@property (nonatomic , strong) UIButton * okBtn;

@property (nonatomic , strong) UIButton * cancelBtn;

@property (nonatomic , copy) NSString * imgData;


@property (nonatomic , strong)  UIDatePicker * pickView;
//头像
@property (nonatomic , strong) UIImageView * headView;

@property (nonatomic , strong) UIButton * mobileBtn;

@property (nonatomic , strong) JVFloatLabeledTextField * Account;

@property (nonatomic , strong) JVFloatLabeledTextField * birthDayField;

@property (nonatomic , copy) JVFloatLabeledTextField * heightField;

@property (nonatomic , strong) UIButton * ManBtn;

@property (nonatomic , strong) UIButton * WomenBtn;

@property (nonatomic , strong) UIView * PersonView;
@property (nonatomic , strong) EditPersonModel * editPerson;
@property (nonatomic , strong) NSMutableArray * editArray;
@property (nonatomic , strong) UILabel * mobileLabel;
@property (nonatomic , strong) UIImageView * mobileImg;

@end

@implementation NewPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];

    [self setNavigationView];
    [self setupNewPersonView];
    [self layoutPersonView];


    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeShadeView];
    if (_isnewPerson == NO) {
        [self loadEditPersonInfo];
    }

}
- (void)loadEditPersonInfo{

    if (isPhoto == NO) {
        self.editArray = [NSMutableArray arrayWithCapacity:1];

        NSDictionary * dict = @{
                                @"userId":@([_userId integerValue])

                                };
        __weak typeof(self) weakSelf = self;
        [[DataManager manager] postDataWithUrl:@"doQueryUser" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {

                NSString * headUrl = dict1[@"data"][@"imgSource"];
                if ( [headUrl isKindOfClass:[NSNull class]] || headUrl == nil || [headUrl isEqualToString:@""] ) {
                    if (isPhoto == NO) {
                        shadeVeiw.hidden = NO;
                        headTitle.hidden = NO;
                    }else{
                        shadeVeiw.hidden = YES;
                        shadeVeiw.hidden = YES;
                    }

                }else{
                     [weakSelf.headView sd_setImageWithURL:[NSURL URLWithString:headUrl]];
                }

                weakSelf.Account.text = dict1[@"data"][@"nickName"];;
                weakSelf.birthDayField.text = dict1[@"data"][@"birthday"];
                weakSelf.heightField.text = [dict1[@"data"][@"height"] stringValue];
                NSString * sex = dict1[@"data"][@"sex"];
                if ([sex isEqualToString:@"男"]) {
                    [weakSelf.ManBtn setImage:[UIImage imageNamed:@"login_btn_man_pre"] forState:UIControlStateNormal];
                    [weakSelf.ManBtn setImage:[UIImage imageNamed:@"login_btn_man_def"] forState:UIControlStateHighlighted];
                    weakSelf.ManBtn.selected = YES;
                }else if([sex isEqualToString:@"女"]){

                    [weakSelf.WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateNormal];
                    [weakSelf.WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_def"] forState:UIControlStateHighlighted];
                    weakSelf.WomenBtn.selected = YES;
                }else{

                }
                NSInteger status = [dict1[@"data"][@"status"] integerValue];

                if (status == 1) {
                    weakSelf.mobileBtn.hidden = YES;
                    weakSelf.mobileImg.hidden = NO;
                    weakSelf.mobileLabel.hidden = NO;
                    weakSelf.mobileLabel.text = dict1[@"data"][@"mobile"];
                }else{
                    weakSelf.mobileBtn.hidden = NO;
                    weakSelf.mobileLabel.hidden = YES;
                    weakSelf.mobileLabel.hidden = YES;
                }
                
                
                
            }else{
                //            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
        } failure:^(NSError *error) {
            //        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];

    }else{

        self.editArray = [NSMutableArray arrayWithCapacity:1];

        NSDictionary * dict = @{
                                @"userId":@([_userId integerValue])

                                };
        __weak typeof(self) weakSelf = self;
        [[DataManager manager] postDataWithUrl:@"doQueryUser" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {

//                NSString * headUrl = dict1[@"data"][@"imgSource"];
//                if ( [headUrl isKindOfClass:[NSNull class]] || headUrl == nil || [headUrl isEqualToString:@""] ) {
//                    if (isPhoto == NO) {
//                        shadeVeiw.hidden = NO;
//                        headTitle.hidden = NO;
//                    }else{
//                        shadeVeiw.hidden = YES;
//                        shadeVeiw.hidden = YES;
//                    }
//
//                }else{
//                    [weakSelf.headView sd_setImageWithURL:[NSURL URLWithString:headUrl]];
//                }

                weakSelf.Account.text = dict1[@"data"][@"nickName"];;
                weakSelf.birthDayField.text = dict1[@"data"][@"birthday"];
                weakSelf.heightField.text = [dict1[@"data"][@"height"] stringValue];
                NSString * sex = dict1[@"data"][@"sex"];
                if ([sex isEqualToString:@"男"]) {
                    [weakSelf.ManBtn setImage:[UIImage imageNamed:@"login_btn_man_pre"] forState:UIControlStateNormal];
                    [weakSelf.ManBtn setImage:[UIImage imageNamed:@"login_btn_man_def"] forState:UIControlStateHighlighted];
                    weakSelf.ManBtn.selected = YES;
                }else if([sex isEqualToString:@"女"]){

                    [weakSelf.WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateNormal];
                    [weakSelf.WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_def"] forState:UIControlStateHighlighted];
                    weakSelf.WomenBtn.selected = YES;
                }else{

                }
                NSInteger status = [dict1[@"data"][@"status"] integerValue];

                if (status == 1) {
                    weakSelf.mobileBtn.hidden = YES;
                    weakSelf.mobileImg.hidden = NO;
                    weakSelf.mobileLabel.hidden = NO;
                    weakSelf.mobileLabel.text = dict1[@"data"][@"mobile"];
                }else{
                    weakSelf.mobileBtn.hidden = NO;
                    weakSelf.mobileLabel.hidden = YES;
                    weakSelf.mobileLabel.hidden = YES;
                }



            }else{
                //            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
        } failure:^(NSError *error) {
            //        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];

    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{


    if (textField == _birthDayField) {

        return NO;
    }

    return YES;

}
- (void)pushMobile{
    __weak typeof(self) weakSelf = self;
    MobileVC * mobile = [[MobileVC alloc] init];
    mobile.B_userId = self.userId;
    mobile.showMobile = ^(BOOL show){
        if (show == YES) {
            [weakSelf loadEditPersonInfo];
        }
    };
    [self.navigationController pushViewController:mobile animated:YES];

}

- (void)editendFamilyGroup:(UIButton *)sender{

    NSString * str = nil;
    if (_ManBtn.selected == YES) {
        str = @"男";
    }else if (_WomenBtn.selected == YES){
        str = @"女";
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }

    if (_birthDayField.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的生日"];
        return;
    }

    if ( [self deptNumInputShouldNumber:_heightField.text] == NO) {
        [SVProgressHUD showErrorWithStatus:@"请输入纯数字"];
        return;
    }

    if (_heightField.text.length <= 1 || _heightField.text.length >3) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
        return;
    }

    NSString * str1 = _heightField.text;
    int height = [str1 intValue];
    if (height > 250) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
        return;
    }

    if (!_imgData) {
        _imgData = @"";
    }


    if (_isnewPerson == YES) {


        NSDictionary * dict = @{
                                @"userId":@([[UserCenter shareUserCenter].userId intValue]),
                                @"nickName":_Account.text,
                                @"sex":str,
                                @"birthday":_birthDayField.text,
                                @"height":_heightField.text,
                                @"fileStr":_imgData
                                };


        __weak typeof(self) weakSelf = self;
        [[DataManager manager] postDataWithUrl:@"doAddHomeUser" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {
                UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否绑定手机号" preferredStyle: UIAlertControllerStyleAlert];

                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {


                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MobileVC * mobile = [[MobileVC alloc] init];
                    mobile.showMobile = ^(BOOL show){
                        if (show == YES) {
                            [weakSelf loadEditPersonInfo];
                        }
                    };
                    mobile.B_userId = dict1[@"message"];
                    mobile.WAYF = weakSelf.WAYF;
                    [weakSelf.navigationController pushViewController:mobile animated:YES];
                    
                }];
                [alert addAction:cancel];
                [alert addAction:action];
                [weakSelf presentViewController:alert animated:YES completion:nil];

            }else{
                [SVProgressHUD showErrorWithStatus:@"新增成员失败"];
            }

        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"新增成员失败"];
        }];



    }else{



        NSDictionary * dict = @{
                                @"userId":@([self.userId intValue]),
                                @"opUserId":[UserCenter shareUserCenter].userId,
                                @"nickName":_Account.text,
                                @"sex":str,
                                @"birthday":_birthDayField.text,
                                @"height":_heightField.text,
                                @"fileStr":_imgData
                                };

        [[DataManager manager] postDataWithUrl:@"doUpdateUser" parameters:dict success:^(id json) {
            NSDictionary * dict1 = json;
            if ([dict1[@"status"] intValue] == 1) {



                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];


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

- (void)editnewFamilyGroup:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
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
        [sender setImage:[UIImage imageNamed:@"login_btn_woman_def"] forState:UIControlStateHighlighted];

    }else{
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
        [sender setImage:[UIImage imageNamed:@"login_btn_man_def"] forState:UIControlStateHighlighted];


    }else{
        sender.selected = YES;
    }
    
    
}

- (void)touchupSearch{

    if (_heightField.text.length>3) {
        _heightField.text = nil;
        return;
    }

}

- (void)presentEditImgViewController:(UITapGestureRecognizer * )tap{

    UIAlertController * controller =[UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];

    }];

    UIAlertAction * library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:imagePicker animated:YES completion:nil];

    }];

    [controller addAction:cancel];
    [controller addAction:camera];
    [controller addAction:library];
    [cancel setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
    [camera setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
    [library setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
    [self presentViewController:controller animated:YES completion:nil];

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{


    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];

    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    self.headView.image = image;
    shadeVeiw.hidden = YES;
    headTitle.hidden = YES;
    NSData *data = [GTMBase64 encodeData:imageData];

    _imgData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    isPhoto = YES;
    [self removeShadeView];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self removeShadeView];
}


- (void)setupNewPersonView{
    self.PersonView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.cl_width, self.view.cl_height - 64)];
    _PersonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_PersonView];

    self.headView = [[UIImageView alloc] init];
//    self.headView.backgroundColor = [UIColor redColor];
//    if (_isnewPerson == NO) {
//         [self.headView sd_setImageWithURL:[NSURL URLWithString:self.editPerson.imgSource]];
//    }

    self.headView.layer.cornerRadius = 40.0;
    self.headView.layer.masksToBounds = YES;
    _headView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentEditImgViewController:)];
    [_headView addGestureRecognizer:tap];
    [_PersonView addSubview:_headView];
//    [_PersonView addSubview:_headView];
    shadeVeiw = [[UIView alloc] init];
    shadeVeiw.backgroundColor = RGBA(48, 52, 52, 0.6);
    [self.headView addSubview:shadeVeiw];


    headTitle = [[UILabel alloc] init];
    headTitle.text = @"上传头像";

    headTitle.font = [UIFont systemFontOfSize:14];
    headTitle.textColor = [UIColor whiteColor];
    headTitle.textAlignment = NSTextAlignmentCenter;
    [shadeVeiw addSubview:headTitle];
    shadeVeiw.hidden = NO;
    headTitle.hidden = NO;

    if (_isnewPerson == NO) {
        shadeVeiw.hidden = YES;
        headTitle.hidden = YES;
    }


    _mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mobileBtn setTitle:@"绑定手机号" forState:UIControlStateNormal];
    [_mobileBtn setTitleColor:[UIColor colorWithHexString:@"0fc2af"] forState:UIControlStateNormal];
    [_mobileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _mobileBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_mobileBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_mobileBtn setBackgroundImage:[UIImage imageWithZYIColor:[UIColor colorWithHexString:@"0fc2af"]] forState:UIControlStateHighlighted];
    _mobileBtn.layer.cornerRadius = 3;
    _mobileBtn.layer.masksToBounds = YES;
    _mobileBtn.layer.borderColor = [UIColor colorWithHexString:@"#0fc2af"].CGColor;
    _mobileBtn.layer.borderWidth = 1;
    [_mobileBtn addTarget:self action:@selector(pushMobile) forControlEvents:UIControlEventTouchUpInside];
    [_PersonView addSubview:_mobileBtn];
//    _mobileBtn.hidden = YES;

    _mobileImg = [[UIImageView alloc] init];
    _mobileImg.image = [UIImage imageNamed:@"family_icon_phone"];
    [_PersonView addSubview:_mobileImg];

    _mobileLabel = [[UILabel alloc] init];
    _mobileLabel.font= [UIFont systemFontOfSize:12];
    _mobileLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    [_PersonView addSubview:_mobileLabel];


    if (_isnewPerson == YES) {
        _mobileBtn.hidden = YES;
        _mobileLabel.hidden = YES;
        _mobileImg.hidden = YES;
    }else{
        if ([self.editPerson.status integerValue] == 1) {
             _mobileBtn.hidden = YES;
            _mobileImg.hidden = NO;
            _mobileLabel.hidden = NO;
        }else{
             _mobileBtn.hidden = YES;
            _mobileLabel.hidden = YES;
            _mobileImg.hidden = YES;
        }

    }

    self.Account = [[JVFloatLabeledTextField alloc] init];
    self.Account.font = [UIFont systemFontOfSize:15];
//    _Account.clearButtonMode = UITextFieldViewModeAlways;
    
    _Account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入昵称"
                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _Account.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _Account.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];

    _Account.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _Account.floatingLabel.text = @"昵称";
    _Account.textColor = [UIColor colorWithHexString:@"#303434"];
//    _Account.delegate = self;
//    _Account.tag = 665;
//    if (_isnewPerson == NO) {
//        _Account.text = self.editPerson.nickName;
//    }
    [_PersonView addSubview:_Account];
    accountL = [[UIView alloc] init];
    accountL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [_PersonView addSubview:accountL];



    _birthDayField = [[JVFloatLabeledTextField alloc] init];
    _birthDayField.font = [UIFont systemFontOfSize:15];
//    _birthDayField.clearButtonMode = UITextFieldViewModeAlways;
    _birthDayField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入生日日期"
                                                                           attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _birthDayField.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _birthDayField.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];

    _birthDayField.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _birthDayField.floatingLabel.text = @"生日";
    _birthDayField.textColor = [UIColor colorWithHexString:@"#303434"];
    _birthDayField.delegate = self;
//    _birthDayField.tag = 666;
//    if (_isnewPerson == NO) {
//        _birthDayField.text = self.editPerson.birthday;
//    }
    [_PersonView addSubview:_birthDayField];
    [_birthDayField addTarget:self action:@selector(addPickDateView) forControlEvents:UIControlEventAllTouchEvents];
    bithDayL = [[UIView alloc] init];
    bithDayL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [_PersonView addSubview:bithDayL];


    _heightField = [[JVFloatLabeledTextField alloc] init];
    _heightField.font = [UIFont systemFontOfSize:15];
//    _heightField.clearButtonMode = UITextFieldViewModeAlways;
    _heightField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身高(cm)"
                                                                         attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _heightField.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _heightField.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];

    _heightField.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _heightField.floatingLabel.text = @"身高";
    _heightField.textColor = [UIColor colorWithHexString:@"#303434"];
//    _heightField.keyboardType = UIKeyboardTypePhonePad;
//    _heightField.delegate =self;
//    _heightField.tag =667;
 [_heightField addTarget:self action:@selector(touchupSearch) forControlEvents:UIControlEventEditingChanged];
    [_PersonView addSubview:_heightField];
//    if (_isnewPerson == NO) {
//        _heightField.text = self.editPerson.height;
//    }
    heightL = [[UIView alloc] init];
    heightL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [_PersonView addSubview:heightL];

    _ManBtn = [[UIButton alloc] init];
//        _ManBtn.backgroundColor = [UIColor blueColor];
    [_ManBtn setTitle:@"男性" forState:UIControlStateNormal];
    _ManBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_ManBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];
    [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_nosel"] forState:UIControlStateNormal];
    [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_def"] forState:UIControlStateHighlighted];

    [_PersonView addSubview:_ManBtn];

    [_ManBtn setImageEdgeInsets:UIEdgeInsetsMake(-_ManBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_ManBtn.titleLabel.intrinsicContentSize.width)];
    [_ManBtn setTitleEdgeInsets:UIEdgeInsetsMake(_ManBtn.currentImage.size.height + 24, -_ManBtn.currentImage.size.width, 0, 0)];

    _WomenBtn = [[UIButton alloc] init];
//        _WomenBtn.backgroundColor = [UIColor redColor];
    [_WomenBtn setTitle:@"女性" forState:UIControlStateNormal];
    _WomenBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_WomenBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];

    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_nosel"] forState:UIControlStateNormal];
    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_def"] forState:UIControlStateHighlighted];
    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateSelected];
    [_PersonView addSubview:_WomenBtn];

    [_WomenBtn setImageEdgeInsets:UIEdgeInsetsMake(-_WomenBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_WomenBtn.titleLabel.intrinsicContentSize.width)];
    [_WomenBtn setTitleEdgeInsets:UIEdgeInsetsMake(_WomenBtn.currentImage.size.height + 24, -_WomenBtn.currentImage.size.width, 0, 0)];

    [_ManBtn addTarget:self action:@selector(chooseM:) forControlEvents:UIControlEventTouchUpInside];
    [_WomenBtn addTarget:self action:@selector(chooseW:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutPersonView{
    [_headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.view).offset(32.5);;
    }];

    [shadeVeiw mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_headView);
    }];

    [headTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_headView);
    }];

     [_mobileBtn mas_updateConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
         make.top.equalTo(_headView.mas_bottom).offset(22);
         make.height.mas_equalTo(24);
         make.width.mas_equalTo(100);
     }];
    [_mobileImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mobileLabel);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(13);
        make.right.equalTo(_mobileLabel.mas_left).offset(-10);
    }];

    [_mobileLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(22);
        make.centerX.equalTo(_headView).offset(10);
        
    }];

    [_Account mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileBtn.mas_bottom).offset(18);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(33);
        make.right.equalTo(self.view).offset(-33);
        make.height.mas_equalTo(48);
    }];

    [accountL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Account.mas_bottom);
        make.left.right.equalTo(_Account);
        make.height.mas_equalTo(0.5);
    }];

    [_birthDayField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Account.mas_bottom).offset(18);
        make.left.right.height.centerX.equalTo(_Account);
    }];

    [bithDayL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_birthDayField.mas_bottom);
        make.left.right.height.mas_equalTo(accountL);
    }];

    [_heightField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_birthDayField.mas_bottom).offset(18);
        make.left.width.height.centerX.mas_equalTo(_Account);
    }];

    [heightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_heightField.mas_bottom);
        make.left.right.height.mas_equalTo(accountL);
    }];

    [_ManBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_heightField.mas_bottom).offset(24);
        make.left.equalTo(_Account);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(150);
    }];

    [_WomenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_Account.mas_right);
        make.centerY.height.width.equalTo(_ManBtn);
    }];


}



- (void)setNavigationView{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 60, 40)];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -25)];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightBtn addTarget:self action:@selector(editendFamilyGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 60, 40)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-20, 0, 20)];
    [leftBtn setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftBtn addTarget:self action:@selector(editnewFamilyGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    if (_isnewPerson == YES) {
        self.title = @"新增成员";
    }else{
        self.title = @"编辑成员信息";
    }

}


- (void)addPickDateView{




    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadeView)];
    [self.shadeView addGestureRecognizer:tap];
    [self.view addSubview:_shadeView];

    centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [_shadeView addSubview:centerView];

    _pickView =  [[UIDatePicker alloc] init];
    _pickView.datePickerMode = UIDatePickerModeDate;
    [_pickView setMaximumDate:[NSDate date]];
    [centerView addSubview:_pickView];


    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [centerView addSubview:topView];


    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择生日";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor  blackColor];
    [topView addSubview:titleLabel];

    _okBtn = [[UIButton alloc] init];
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#157efb"] forState:UIControlStateNormal];
    [topView addSubview:_cancelBtn];
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor colorWithHexString:@"#157efb"] forState:UIControlStateNormal];
    [topView addSubview:_okBtn];



    [_okBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(removeShadeViewC:) forControlEvents:UIControlEventTouchUpInside];



    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_shadeView);
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

    [_Account resignFirstResponder];
    [_heightField resignFirstResponder];
    [self.view endEditing:YES];
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




    if (_isnewPerson == NO) {
        isChoose = YES;
        _birthDayField.text = [self timeFormat];
    }else{
        isChoose = YES;
        _birthDayField.text = [self timeFormat];
    }




    [self removeShadeView];


}

- (void)removeShadeViewC:(UIButton *)sender{

    // 开始动画



    if (_isnewPerson) {
        _Account.text = nil;
    }else{

    }

    [self removeShadeView];

}

-(UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
        _shadeView.backgroundColor = RGBA(0, 0, 0, 0.6);
    }
    return _shadeView;
}

- (void)removeShadeView{
    //    [self animationbegin:centerView];
    [UIView animateWithDuration:0.3 animations:^{
        [_shadeView removeFromSuperview];
    }];
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
