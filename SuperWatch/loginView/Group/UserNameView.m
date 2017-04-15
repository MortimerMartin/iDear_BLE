//
//  UserNameView.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "UserNameView.h"
#import "Masonry.h"
#import "JVFloatLabeledTextField.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "UserCenter.h"
//#import "AFNetworking.h"
#import "DataManager.h"
#import "GTMBase64.h"
#import "UIImageView+WebCache.h"
#import "UserCenter.h"
#import "SVProgressHUD.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface UserNameView ()<UINavigationControllerDelegate , UIImagePickerControllerDelegate>
{
//    UILabel * name;
    UIView * accountL;
    UIView  * shadeVeiw;
}




@end
@implementation UserNameView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

           self.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];

        [self setupUserNameView];
    }

    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    [self.Account resignFirstResponder];
}


- (void)setupUserNameView{

    self.headView = [[UIImageView alloc] init];
//    self.headView.backgroundColor = [UIColor redColor];
    self.headView.layer.cornerRadius = 40.0;
    self.headView.layer.masksToBounds = YES;
    _headView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentImgViewController:)];
    [_headView addGestureRecognizer:tap];
    [self addSubview:_headView];

    shadeVeiw = [[UIView alloc] init];
    shadeVeiw.backgroundColor = RGBA(48, 52, 52, 0.6);
    [self.headView addSubview:shadeVeiw];


    self.headTitle = [[UILabel alloc] init];
    self.headTitle.text = @"上传头像";
    _headTitle.font = [UIFont systemFontOfSize:14];
    self.headTitle.textColor = [UIColor whiteColor];
    self.headTitle.textAlignment = NSTextAlignmentCenter;
    [shadeVeiw addSubview:_headTitle];

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


    [self addSubview:_Account];


    _Account.translatesAutoresizingMaskIntoConstraints = NO;
        _Account.keepBaseline = YES;


    accountL = [[UIView alloc] init];
    accountL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [self addSubview:accountL];

    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    [self.nextBtn setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];

    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateHighlighted];
    [self.nextBtn setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    [self addSubview:_nextBtn];

    [_nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];

    [_nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _nextBtn.titleLabel.intrinsicContentSize.width -12, 0, -_nextBtn.titleLabel.intrinsicContentSize.width)];
    [_nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_nextBtn.currentImage.size.width, 0, _nextBtn.titleLabel.intrinsicContentSize.width - 12)];

////    //增加监听，当键盘出现或改变时收到消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
//    //增加监听，当键盘退出时收到消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}


/**
 * 功能：当键盘出现或改变时调用
 */
//- (void)keyboardWillShow:(NSNotification *)aNotification {
//
//    // ------获取键盘的高度
//    NSDictionary *userInfo    = [aNotification userInfo];
//
//    // 键盘弹出后的frame的结构体对象
//    NSValue *valueEndFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    // 得到键盘弹出后的键盘视图所在y坐标
//    CGFloat keyBoardEndY = valueEndFrame.CGRectValue.origin.y;
//    CGRect keyboardRect       = [valueEndFrame CGRectValue];
//    CGFloat KBHeight              = keyboardRect.size.height;
////    self.keyBoardHeight=KBHeight;
//    // ------键盘出现或改变时的操作代码
//    NSLog(@"当前的键盘高度为：%f",KBHeight);
//    // 键盘弹出的动画时间
////    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    // 键盘弹出的动画曲线
////    self.curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//
//
//    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
//    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        [UIView setAnimationBeginsFromCurrentState:YES];
//
//            if (_isMove) {
//                _isMove();
//            }
////        [UIView setAnimationCurve:[_curve intValue]];
////        self.myTopView.frame=CGRectMake(0, keyBoardEndY+topViewHeigt+TopBarHeight, Main_Screen_Width, topViewHeigt);
//    }];
//}

/**
 * 功能：当键盘退出时调用
 */
//- (void)keyboardWillHide:(NSNotification *)aNotification {

//    // ------键盘退出时的操作代码
//    NSDictionary *userInfo    = [aNotification userInfo];
//    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//
//    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
//    [UIView animateWithDuration:[_duration doubleValue] animations:^{
//        [UIView setAnimationBeginsFromCurrentState:YES];
//
//        [UIView setAnimationCurve:[_curve intValue]];
//        self.myTopView.frame=CGRectMake(0, Main_Screen_Height, Main_Screen_Width, topViewHeigt);
//    }];
//}

- (void)nextStep:(UIButton  *)sender{
    //判断
    if (_Account.text.length <=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的昵称"];
        return;
    }


    [UserCenter shareUserCenter].name = _Account.text;
    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].name forKey:@"UserSource"];

    //跳转
    if (_isName) {
        _isName();
    }
}


- (void)presentImgViewController:(UITapGestureRecognizer * )tap{

    UIAlertController * controller =[UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[self viewController] presentViewController:imagePicker animated:YES completion:nil];

    }];

    UIAlertAction * library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [[self viewController] presentViewController:imagePicker animated:YES completion:nil];

    }];

    [controller addAction:cancel];
    [controller addAction:camera];
    [controller addAction:library];
    [cancel setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
    [camera setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
    [library setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
    [[self viewController] presentViewController:controller animated:YES completion:nil];

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];


    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];

    NSData *imageData = UIImageJPEGRepresentation(image,0.5);

    NSData *data = [GTMBase64 encodeData:imageData];

    NSString *imgStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];




    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                            @"fileStr":imgStr
                            };


    [[DataManager manager] postDataWithUrl:@"/doUploadImage" parameters:dict success:^(id json) {

        NSDictionary * dict = json;
        if ([dict[@"status"] integerValue] == 1) {
            NSString * str = dict[@"message"];

            [_headView sd_setImageWithURL:[NSURL URLWithString:str]];

            shadeVeiw.hidden = YES;
            _headTitle.hidden = YES;

            [UserCenter shareUserCenter].source = str;
            [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].source forKey:@"UserSource"];
        }else{

            [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
        }

    } failure:^(NSError *error) {

    }];


    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    if (_isMove) {
//        _isMove();
//    }
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

- (void)layoutSubviews{
    [super layoutSubviews];


    [self layoutUserNameView];
    

}

- (void)layoutUserNameView{

    [_headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self).offset(self.cl_height/6);
    }];

    [_headTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_headView);
    }];

    [shadeVeiw mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_headView);
    }];
    [_Account mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(-30);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(36);
        make.right.equalTo(self).offset(-36);
        make.height.mas_equalTo(49);
    }];

    [accountL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Account.mas_bottom);
        make.left.right.equalTo(_Account);
        make.height.mas_equalTo(0.5);
    }];


    [_nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self).offset(100);
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
