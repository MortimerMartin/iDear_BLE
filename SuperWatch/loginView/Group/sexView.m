//
//  sexView.m
//  SuperWatch
//
//  Created by pro on 17/2/11.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "sexView.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
#import "UIColor+HexString.h"
#import "UserCenter.h"
#import "SVProgressHUD.h"
@interface sexView ()

@property (nonatomic , strong) UIButton * ManBtn;

@property (nonatomic , strong) UIButton * WomenBtn;

@property (nonatomic , strong) UIButton * nextBtn;

@property (nonatomic , strong) UIButton * backBtn;

@end
@implementation sexView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

           self.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];

        [self setupSexView];
    }
    
    return self;
}

- (void)setupSexView{

    _ManBtn = [[UIButton alloc] init];
//    _ManBtn.backgroundColor = [UIColor blueColor];
    [_ManBtn setTitle:@"男性" forState:UIControlStateNormal];
    _ManBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_ManBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];
    [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_nosel"] forState:UIControlStateNormal];
    [_ManBtn setImage:[UIImage imageNamed:@"login_btn_man_def"] forState:UIControlStateHighlighted];

    [self addSubview:_ManBtn];

    [_ManBtn setImageEdgeInsets:UIEdgeInsetsMake(-_ManBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_ManBtn.titleLabel.intrinsicContentSize.width)];
    [_ManBtn setTitleEdgeInsets:UIEdgeInsetsMake(_ManBtn.currentImage.size.height + 24, -_ManBtn.currentImage.size.width, 0, 0)];

    _WomenBtn = [[UIButton alloc] init];
//    _WomenBtn.backgroundColor = [UIColor redColor];
    [_WomenBtn setTitle:@"女性" forState:UIControlStateNormal];
    _WomenBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_WomenBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateNormal];

    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_nosel"] forState:UIControlStateNormal];
    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_def"] forState:UIControlStateHighlighted];
    [_WomenBtn setImage:[UIImage imageNamed:@"login_btn_woman_pre"] forState:UIControlStateSelected];
    [self addSubview:_WomenBtn];

    [_WomenBtn setImageEdgeInsets:UIEdgeInsetsMake(-_WomenBtn.titleLabel.intrinsicContentSize.height, 0, 0, -_WomenBtn.titleLabel.intrinsicContentSize.width)];
    [_WomenBtn setTitleEdgeInsets:UIEdgeInsetsMake(_WomenBtn.currentImage.size.height + 24, -_WomenBtn.currentImage.size.width, 0, 0)];

    [_ManBtn addTarget:self action:@selector(chooseM:) forControlEvents:UIControlEventTouchUpInside];
    [_WomenBtn addTarget:self action:@selector(chooseW:) forControlEvents:UIControlEventTouchUpInside];


    _nextBtn = [[UIButton alloc] init];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    [self addSubview:_nextBtn];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.nextBtn setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];

    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateHighlighted];


    [_nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _nextBtn.titleLabel.intrinsicContentSize.width -12, 0, -_nextBtn.titleLabel.intrinsicContentSize.width)];
    [_nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_nextBtn.currentImage.size.width, 0, _nextBtn.titleLabel.intrinsicContentSize.width - 12)];


    _backBtn = [[UIButton alloc] init];

    [_backBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"person_btn_go"] forState:UIControlStateNormal];
    [self addSubview:_backBtn];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_backBtn setTitleColor:[UIColor colorWithHexString:@"#9aa9a9"] forState:UIControlStateNormal];

    [_backBtn setTitleColor:[UIColor colorWithHexString:@"#737f7f"] forState:UIControlStateHighlighted];

     CGAffineTransform transform = CGAffineTransformIdentity;
    _backBtn.imageView.transform = CGAffineTransformRotate(transform, -M_PI);

     [_backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];

    [_backBtn addTarget:self action:@selector(backTop:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];

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
//        sender.enabled = NO;
    }
    else{
        sender.selected = YES;
//        _ManBtn.enabled = YES;
//        [sender setImage:[UIImage imageNamed:@"login_btn_woman_nosel"] forState:UIControlStateNormal];
    }

    [UserCenter shareUserCenter].sex = @"女";
    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].sex forKey:@"UserSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
//        sender.enabled = NO;
    }
    else{
        sender.selected = YES;
//        _WomenBtn.enabled = YES;
//        [sender setImage:[UIImage imageNamed:@"login_btn_man_nosel"] forState:UIControlStateNormal];
    }

    [UserCenter shareUserCenter].sex = @"男";
    [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].sex forKey:@"UserSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)backTop:(UIButton *)sender{

    [UserCenter shareUserCenter].sex = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_isBack) {
        _isBack();
    }
}

- (void)nextStep:(UIButton *)sender{

    if (![UserCenter shareUserCenter].sex) {
        [SVProgressHUD showErrorWithStatus:@"请选择您的性别"];
        return;
    }
    if (_isMan) {
        _isMan();
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];

    [self layoutSexView];

}

- (void)layoutSexView{

    [_ManBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-self.cl_width/4);
        make.centerY.equalTo(self).offset(-100);;
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
    }];

    [_WomenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(_ManBtn);
        make.centerX.equalTo(self).offset(self.cl_width/4);
    }];

    [_backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ManBtn);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self).offset(100);
    }];

    [_nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_WomenBtn);
        make.width.height.centerY.equalTo(_backBtn);
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
