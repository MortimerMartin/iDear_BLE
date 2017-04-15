//
//  BirthdayView.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BirthdayView.h"
#import "JVFloatLabeledTextField.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
#import "UIColor+HexString.h"
#import "UIImage+ZYImage.h"
#import "UserCenter.h"
#import "SVProgressHUD.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface BirthdayView ()<UITextFieldDelegate>

{
    UIView * shadeView;
    UIView * centerView;
    UIView * bithDayL;
}


@property (nonatomic , strong) UIButton * okBtn;

@property (nonatomic , strong) UIButton * cancelBtn;

@property (nonatomic , strong) UIButton * backBtn1;

@property (nonatomic , strong) UIButton * nextBtn1;

@property (nonatomic , strong)  UIDatePicker * pickView;

@end


@implementation BirthdayView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

           self.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];

        [self setupBithDayView];


    }

    return self;
}



- (void)setupBithDayView{

    _birthDayField = [[JVFloatLabeledTextField alloc] init];
    _birthDayField.font = [UIFont systemFontOfSize:15];
    _birthDayField.clearButtonMode = UITextFieldViewModeAlways;
    _birthDayField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入生日日期"
                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#737f7f"]}];
    _birthDayField.floatingLabelFont = [UIFont boldSystemFontOfSize:12];
    _birthDayField.floatingLabelTextColor = [UIColor colorWithHexString:@"#737f7f"];

    _birthDayField.floatingLabelActiveTextColor = [UIColor colorWithHexString:@"#737f7f"];
    _birthDayField.floatingLabel.text = @"生日";
    _birthDayField.textColor = [UIColor colorWithHexString:@"#303434"];
    _birthDayField.delegate = self;
    [self addSubview:_birthDayField];

    bithDayL = [[UIView alloc] init];
    bithDayL.backgroundColor = [UIColor colorWithHexString:@"#737f7f"];
    [self addSubview:bithDayL];

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


    _nextBtn1 = [[UIButton alloc] init];
//    _nextBtn1.backgroundColor = [UIColor redColor];
    [_nextBtn1 setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn1 setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];


    _nextBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [_nextBtn1 setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];
    [_nextBtn1 setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateHighlighted];


    [_nextBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, _nextBtn1.titleLabel.intrinsicContentSize.width , 0, -_nextBtn1.titleLabel.intrinsicContentSize.width )];
    [_nextBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -_nextBtn1.currentImage.size.width, 0, _nextBtn1.currentImage.size.width +12)];

      [self addSubview:_nextBtn1];
    //右对齐
    _nextBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    [_backBtn1 addTarget:self action:@selector(backTop:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn1 addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backTop:(UIButton *)sender{

    [UserCenter shareUserCenter].bithday = nil;
    [UserCenter shareUserCenter].age = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserBirthDay"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAge"];
    if (_isBackBlock) {
        _isBackBlock();
    }

}

- (void)nextStep:(UIButton *)sender{

    if (_birthDayField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择您的生日日期"];
        return;
    }
    [UserCenter shareUserCenter].bithday = _birthDayField.text;
    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].bithday forKey:@"UserBirthDay"];


    [self getAge];

    if (_isNextBlock) {
        _isNextBlock();
    }

}

- (void)getAge{
    NSString * birth = _birthDayField.text;
    if (birth.length<=0) {
        return ;
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
    
    [UserCenter shareUserCenter].age = [NSString stringWithFormat:@"%d",age];
    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].age forKey:@"UserAge"];

    NSLog(@"age____%d",age);
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self layoutBithDayViews];




}


- (void)layoutBithDayViews{

    [_birthDayField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-40);
//        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(36);
        make.right.equalTo(self).offset(-36);
    }];

    [bithDayL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_birthDayField);
        make.top.equalTo(_birthDayField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    [_backBtn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(100);
        make.left.equalTo(_birthDayField);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];

    [_nextBtn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backBtn1);
        make.right.equalTo(_birthDayField);
        make.width.height.equalTo(_backBtn1);
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{


     [self addPickDateView];
//      [UIView animateWithDuration:1 animations:^{
//          shadeView.cl_y = 0;
//      }];

    return NO;
}



- (void)addPickDateView{

    [_birthDayField resignFirstResponder];

    shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cl_width, self.cl_height)];
    shadeView.backgroundColor = RGBA(0, 0, 0, 0.6);

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadeView)];
    [shadeView addGestureRecognizer:tap];
    [self addSubview:shadeView];
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
    [centerView addSubview:_pickView];

    _okBtn = [[UIButton alloc] init];
    _cancelBtn = [[UIButton alloc] init];

    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"157efb"] forState:UIControlStateNormal];

    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor colorWithHexString:@"157efb"] forState:UIControlStateNormal];
    [topView addSubview:_okBtn];
    [topView addSubview:_cancelBtn];

    
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
        make.left.right.top.equalTo(centerView);
        make.bottom.equalTo(_pickView.mas_top);
    }];


    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(topView);

    }];


    [_okBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView).offset(-10);
        make.centerY.equalTo(topView);
    
//        make.top.equalTo(centerView).offset(6);
//        make.right.equalTo(centerView).offset(-10);
//        make.bottom.equalTo(_pickView.mas_top).offset(-6);
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

    NSString * dateBlock = [self timeFormat];


    _birthDayField.text = dateBlock;


    [self removeShadeView];


}

- (void)removeShadeViewC:(UIButton *)sender{

    // 开始动画
    [self animationbegin:sender];

    _birthDayField.text = nil;

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


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//
////     [self addPickDateView];
//    [self removeShadeView];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
