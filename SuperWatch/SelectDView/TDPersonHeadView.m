//
//  TDPersonHeadView.m
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "TDPersonHeadView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"

#define KDevice_Is_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface TDPersonHeadView ()
{
    UIImageView * imgView;
    UIView * topL;
    UIView * centerL;
    UIView * bottomeL;
    UILabel * left_BMI;
    UILabel * left_height;
    UILabel * left_weight;
    UILabel * left_tzl;

};
@property (nonatomic , strong) UIView * backTDView;
@property (nonatomic , strong) UIImageView * backTDimgView;

@property (nonatomic , strong) UIImageView * personImg;
@property (nonatomic , strong) UILabel * timeLabel;

@property (nonatomic , strong) UILabel * right_BMIC;
@property (nonatomic , strong) UILabel * right_BMIS;

@property (nonatomic , strong) UILabel * right_heightC;
@property (nonatomic , strong) UILabel * right_heightS;

@property (nonatomic , strong) UILabel * right_weightC;
@property (nonatomic , strong) UILabel * right_weightS;

@property (nonatomic , strong) UILabel * right_tzlC;
@property (nonatomic , strong) UILabel * right_tzlS;


//@property (nonatomic , copy) NSString * BMI_C;
@property (nonatomic , copy) NSString * BMI_S;

//@property (nonatomic , copy) NSString * height_C;
@property (nonatomic , copy) NSString * height_S;

//@property (nonatomic , copy) NSString * weight_C;
@property (nonatomic , copy) NSString * weight_S;

//@property (nonatomic , copy) NSString * tzl_C;
@property (nonatomic , copy) NSString * tzl_S;
@end
@implementation TDPersonHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTDPHeadView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTDPHeadView];
    }
    return self;
};

- (void)setupTDPHeadView{
    _backTDimgView = [[UIImageView alloc] init];
    _backTDimgView.image = [UIImage imageNamed:@"background"];
    [self addSubview:_backTDimgView];

    _backTDView = [[UIView alloc] init];
    _backTDView.layer.cornerRadius = 4;
    _backTDView.layer.masksToBounds = YES;
    _backTDView.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
    _backTDView.layer.borderWidth = 0.5;
    _backTDView.backgroundColor = [UIColor whiteColor];
    _backTDView.alpha = 0.9;
    [self addSubview:_backTDView];



    imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"home_icon_scales_s"];
    [_backTDView addSubview:imgView];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backTDView addSubview:_timeLabel];

    _personImg = [[UIImageView alloc] init];
    _personImg.image = [UIImage imageNamed:@"home_icon_normal_s"];
    [_backTDView addSubview:_personImg];

    left_BMI = [self getCommondLeftLabelColor:@"#737f7f" Title:@"BMI"];
        [_backTDView addSubview:left_BMI];
    left_height = [self getCommondLeftLabelColor:@"#737f7f" Title:@"身高"];
    [_backTDView addSubview:left_height];
    left_weight = [self getCommondLeftLabelColor:@"#737f7f" Title:@"体重"];
    [_backTDView addSubview:left_weight];
    left_tzl = [self getCommondLeftLabelColor:@"#737f7f" Title:@"体脂率"];
    [_backTDView addSubview:left_tzl];
    _right_BMIC = [self getCommondLeftLabelColor:@"#565c5c" Title:@""];
    _right_BMIC.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_BMIC];
    _right_BMIS = [self getCommondLeftLabelColor:@"#38c750" Title:@""];
    _right_BMIS.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_BMIS];
    _right_heightC = [self getCommondLeftLabelColor:@"#565c5c" Title:@""];
    _right_heightC.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_heightC];
    _right_heightS = [self getCommondLeftLabelColor:@"38c750" Title:@""];
    _right_heightS.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_heightS];
    _right_weightC = [self getCommondLeftLabelColor:@"#565c5c" Title:@""];
    _right_weightC.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_weightC];
    _right_weightS = [self getCommondLeftLabelColor:@"#38c750" Title:@""];
    _right_weightS.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_weightS];
    _right_tzlC = [self getCommondLeftLabelColor:@"#565c5c" Title:@""];
    _right_tzlC.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_tzlC];
    _right_tzlS = [self getCommondLeftLabelColor:@"#53d3d3" Title:@""];
    _right_tzlS.textAlignment = NSTextAlignmentRight;
    [_backTDView addSubview:_right_tzlS];
    topL = [[UIView alloc] init];
    topL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [_backTDView addSubview:topL];

    centerL = [[UIView alloc] init];
    centerL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [_backTDView addSubview:centerL];

    bottomeL = [[UIView alloc] init];
    bottomeL.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [_backTDView addSubview:bottomeL];

}
- (UILabel *)getCommondLeftLabelColor:(NSString *)color Title:(NSString *)title{
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:color];
    label.text = title;

    return label;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutTDPersonHeadView];
};


-(void)setTime_connect:(NSString *)time_connect{
    _time_connect = time_connect;
    _timeLabel.text = [NSString stringWithFormat:@"上次测量时间：%@",time_connect];
}

-(void)setPerson_status:(NSString *)person_status{
    _person_status = person_status;
    if ([person_status containsString:@"标准"]) {
        _personImg.image = [UIImage imageNamed:@"measure_icon_normal"];

    }else if ([person_status containsString:@"偏低"] || [person_status containsString:@"偏瘦"]){
        _personImg.image = [UIImage imageNamed:@"measure_icon_thin"];

    }else if ([person_status containsString:@"偏高"] || [person_status containsString:@"较高"] ){
        _personImg.image = [UIImage imageNamed:@"measure_icon_fat"];

    }else if ( [person_status containsString:@"较胖"] || [person_status containsString:@"偏胖"] || [person_status containsString:@"超重"]){
        _personImg.image = [UIImage imageNamed:@"measure_icon_weight"];


    }else{
        _personImg.image = [UIImage imageNamed:@"measure_icon_normal"];
    }
}

-(void)setPersonInfo:(NSMutableArray *)personInfo{
    _personInfo = personInfo;

    if (personInfo.count>0) {
        for (int i = 0; i<personInfo.count; i++) {
            NSString * info = personInfo[i];
            if ([info containsString:@"("]) {
                NSArray * arr = [info componentsSeparatedByString:@"("];
                NSString * info1 = arr[0];
                NSString * status = arr[1];

                if (i == 0) {
                    _right_BMIC.text = info1;
                    _right_BMIS.text = [NSString stringWithFormat:@"(%@",status];
                    _BMI_S = _right_BMIS.text;
                    _right_BMIS.textColor = [self returnColorWithStatus:status];

                }
                else if (i == 1){
                    _right_heightC.text = info1;
                    _right_heightS.text = [NSString stringWithFormat:@"(%@",status];
                    _height_S = _right_heightS.text;
                    _right_heightS.textColor = [self returnColorWithStatus:status];
                }
                else if (i == 2){
                    _right_weightC.text = info1;
                    _right_weightS.text = [NSString stringWithFormat:@"(%@",status];
                    _weight_S = _right_weightS.text;
                    _right_weightS.textColor = [self returnColorWithStatus:status];
                }else if (i == 3){
                    _right_tzlC.text = info1;
                    _right_tzlS.text = [NSString stringWithFormat:@"(%@",status];
                    _tzl_S = _right_tzlS.text;
                    _right_tzlS.textColor = [self returnColorWithStatus:status];
                }else{
                    
                }
                
            }else{
                _right_heightC.text = personInfo[i];
            }
        }
    }


}
//-(void)setBMI_C:(NSString *)BMI_C{
//    _BMI_C = BMI_C;
//    _right_BMIC.text = BMI_C;
//}
//
//-(void)setBMI_S:(NSString *)BMI_S{
//    _BMI_S = BMI_S;
//    _right_BMIS.text = [NSString stringWithFormat:@"(%@)",BMI_S];
//    _right_BMIS.textColor = [self returnColorWithStatus:BMI_S];
//}
//
//-(void)setHeight_C:(NSString *)height_C{
//    _height_C = height_C;
//    _right_heightC.text = height_C;
//}
//
//-(void)setHeight_S:(NSString *)height_S{
//    _height_S = height_S;
//    if (![height_S isEqualToString:@""]  && height_S != nil) {
//        _right_heightS.text = [NSString stringWithFormat:@"(%@)",height_S];
//        _right_heightS.textColor = [self returnColorWithStatus:height_S];
//    }
//
//}
//
//-(void)setWeight_C:(NSString *)weight_C{
//    _weight_C = weight_C;
//    _right_weightC.text = weight_C;
//}
//
//-(void)setWeight_S:(NSString *)weight_S{
//    _weight_S = weight_S;
//    _right_weightS.text = [NSString stringWithFormat:@"(%@)",weight_S];
//    _right_weightS.textColor = [self returnColorWithStatus:weight_S];
//}
//
//-(void)setTzl_C:(NSString *)tzl_C{
//    _tzl_C = tzl_C;
//    _right_tzlC.text = tzl_C;
//}
//-(void)setTzl_S:(NSString *)tzl_S{
//    _tzl_S = tzl_S;
//    _right_tzlS.text = [NSString stringWithFormat:@"(%@)",tzl_S];
//    _right_tzlS.textColor = [self returnColorWithStatus:tzl_S];
//}

-(UIColor *)returnColorWithStatus:(NSString *)status{

    if ([status containsString:@"标准"]) {
        return  [UIColor colorWithHexString:@"#38c750"];
    }else if ([status containsString:@"偏低"] || [status containsString:@"偏瘦"]){
        return  [UIColor colorWithHexString:@"#53d3d3"];
    }else if ([status containsString:@"偏高"] || [status containsString:@"较高"] || [status containsString:@"较胖"] || [status containsString:@"偏胖"] || [status containsString:@"超重"]){
        return  [UIColor colorWithHexString:@"#d23030"];
    }

    return [UIColor  colorWithHexString:@"#737f7f"];
}
-(void)layoutTDPersonHeadView{


    [_backTDimgView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(101);
    }];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Click_SH"]){

        [_backTDView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self).offset(-35);
        }];

    }else{

        [_backTDView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - 232.0f - 64.0 - 35.0);
        }];
    }

    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backTDView).offset(12);
        make.top.equalTo(_backTDView).offset(12);
        make.height.width.mas_equalTo(20);
    }];

    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(10);
        make.centerY.equalTo(imgView);
    }];

    [_personImg mas_updateConstraints:^(MASConstraintMaker *make) {

        if (kDevice_Is_iPhone5 ) {
            make.width.mas_equalTo(52);
            make.height.mas_equalTo(126);
        }else{
            make.width.mas_equalTo(103);
            make.height.mas_equalTo(252);
        }

        make.left.equalTo(_backTDView).offset(23);
        make.bottom.equalTo(_backTDView).offset(-15);
    }];

    [_right_tzlS mas_updateConstraints:^(MASConstraintMaker *make) {
        if (kDevice_Is_iPhone5) {
            make.bottom.equalTo(_personImg);
        }else{
            make.bottom.equalTo(_backTDView).offset(-35);
        }
        make.right.equalTo(_backTDView).offset(-20);
    }];

    [_right_tzlC mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_right_tzlS);
        if (_tzl_S && _tzl_S.length>0) {
            make.right.equalTo(_right_tzlS.mas_left).offset(-12);
        }else{
            make.right.equalTo(_right_tzlS);
        }

    }];

    [left_tzl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backTDView).offset(-35);
        make.left.equalTo(_personImg.mas_right).offset(45);
    }];

    [bottomeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(left_tzl.mas_top).offset(-18);
        make.left.equalTo(left_tzl).offset(-10);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(_backTDView).offset(-8);
    }];

    [left_weight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_tzl);
        make.bottom.equalTo(bottomeL.mas_top).offset(-18);
    }];


    [_right_weightS mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_right_tzlS);
        make.centerY.equalTo(left_weight);
    }];

    [_right_weightC mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_weight_S && _weight_S.length>0) {
            make.right.equalTo(_right_weightS.mas_left).offset(-12);
        }else{
            make.right.equalTo(_right_weightS);
        }

        make.centerY.equalTo(_right_weightS);
    }];

    [centerL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(bottomeL);
        make.bottom.equalTo(left_weight.mas_top).offset(-18);
    }];

    [left_height mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_tzl);
        make.bottom.equalTo(centerL.mas_top).offset(-18);
    }];

    [_right_heightS mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_right_tzlS);
        make.centerY.equalTo(left_height);
    }];

    [_right_heightC mas_updateConstraints:^(MASConstraintMaker *make) {
       if (_height_S && _height_S.length>0) {
            make.right.equalTo(_right_heightS.mas_left).offset(-12);
        }else{
            make.right.equalTo(_right_heightS);
        }

        make.centerY.equalTo(_right_heightS);
    }];

    [topL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(bottomeL);
        make.bottom.equalTo(left_height.mas_top).offset(-18);
    }];

    [left_BMI mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(left_tzl);
        if (kDevice_Is_iPhone5) {
            make.bottom.equalTo(topL.mas_top).offset(-10);
        }else{
            make.bottom.equalTo(topL.mas_top).offset(-18);
        }
    }];

    [_right_BMIS mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_right_tzlS);
        make.centerY.equalTo(left_BMI);
    }];

    [_right_BMIC mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_BMI_S && _BMI_S.length>0) {
            make.right.equalTo(_right_BMIS.mas_left).offset(-12);
        }else{
            make.right.equalTo(_right_heightS);
        }

        make.centerY.equalTo(_right_BMIS);
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
