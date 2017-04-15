//
//  HeightView.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "HeightView.h"
#import "JVFloatLabeledTextField.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UserCenter.h"
#import "SVProgressHUD.h"
#import "getSeven.h"
#import "DataManager.h"
@interface HeightView ()
{
    UIView  * heightL;
}
@property (nonatomic , strong) UIButton * endBtn;
@property (nonatomic , strong) UIButton * backBtn1;

@end
@implementation HeightView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
        [self setupHeightView];
    }

    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.heightField resignFirstResponder];
}

- (void)setupHeightView{

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
    [_heightField addTarget:self action:@selector(touchupSearch) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_heightField];

    heightL = [[UIView alloc] init];
    heightL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [self addSubview:heightL];


    _backBtn1 = [[UIButton alloc] init];

    [_backBtn1 setTitle:@"上一步" forState:UIControlStateNormal];
    [_backBtn1 setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];


    _backBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [_backBtn1 setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];

    [_backBtn1 setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateHighlighted];

    CGAffineTransform transform = CGAffineTransformIdentity;
    _backBtn1.imageView.transform = CGAffineTransformRotate(transform, -M_PI);

    [_backBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    //左对齐
    _backBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [self addSubview:_backBtn1];
    [_backBtn1 addTarget:self action:@selector(backBithdaty) forControlEvents:UIControlEventTouchUpInside];

    _endBtn = [[UIButton alloc] init];
//    _endBtn.backgroundColor = [UIColor redColor];
    [_endBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endBtn setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    _endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_endBtn setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];
    [_endBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateHighlighted];
    [self addSubview:_endBtn];

    [_endBtn addTarget:self action:@selector(loginEnd:) forControlEvents:UIControlEventTouchUpInside];

    [_endBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _endBtn.titleLabel.intrinsicContentSize.width , 0, -_endBtn.titleLabel.intrinsicContentSize.width )];
    [_endBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_endBtn.currentImage.size.width, 0, _endBtn.currentImage.size.width + 16 )];


}

- (void)backBithdaty{
    if (_isBack) {
        _isBack();
    }
}

- (void)touchupSearch{

    if (_heightField.text.length>3) {
        _heightField.text = nil;
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


- (void)loginEnd:(UIButton *)sender{



    if ( [self deptNumInputShouldNumber:_heightField.text] == NO) {
        [SVProgressHUD showErrorWithStatus:@"请输入纯数字"];
        return;
    }

    if (_heightField.text.length <= 1 || _heightField.text.length >3) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
        return;
    }

    NSString * str = _heightField.text;
    int height = [str intValue];
    if (height > 250) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
        return;
    }

    [UserCenter shareUserCenter].height  = _heightField.text;
    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].height forKey:@"UserHeight"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId intValue]),
                            @"nickName":[UserCenter shareUserCenter].name,
                            @"sex":[UserCenter shareUserCenter].sex,
                            @"birthday":[UserCenter shareUserCenter].bithday,
                            @"height":[UserCenter shareUserCenter].height
                            };

    [[DataManager manager] postDataWithUrl:@"doAddUser" parameters:dict success:^(id json) {

        NSDictionary * dict = json;
        NSInteger status = [dict[@"status"] integerValue];
        if (status == 1) {

            UserCenter * user = [UserCenter shareUserCenter];

            user.homenumer = nil;
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
            user.name = dict[@"data"][@"nickName"] ;
            user.bithday = dict[@"data"][@"birthday"] ;
            user.isLogin = YES;

            [user saveUserDefaults];

            
            if (_isEnd) {
                _isEnd();
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"信息提交失败"];
        }


    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"服务器错误"];
    }];



}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self layoutHeightView];
}

- (void)layoutHeightView{

    [_heightField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);;
    }];

    [heightL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_heightField.mas_bottom);
        make.left.right.equalTo(_heightField);
        make.height.mas_equalTo(0.5);
    }];


    [_endBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(100);
        make.right.equalTo(heightL);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];

    [_backBtn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_endBtn);
        make.width.mas_equalTo(100);
        make.left.equalTo(heightL);
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
