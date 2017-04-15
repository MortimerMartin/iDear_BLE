//
//  PersonHeadView.m
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonHeadView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
@interface PersonHeadView ()
{
    UIView * line;
}
@property (nonatomic , strong) UILabel * connectStatus;
@property (nonatomic , strong) UIImageView * bluetooth;
@property (nonatomic , strong) UIImageView * person;
@property (nonatomic , strong) UILabel * person_BMI;
@property (nonatomic , strong) UILabel * BMI;

@end
@implementation PersonHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupPersonHeadView];
    }

    return self;
}

- (void)setupPersonHeadView{
    _bluetooth = [[UIImageView alloc] init];
    _bluetooth.image = [UIImage imageNamed:@"measure_icon_bluetooth"];
//    _bluetooth.backgroundColor = [UIColor redColor];
    [self addSubview:_bluetooth];

    _connectStatus = [[UILabel alloc] init];
    _connectStatus.font = [UIFont systemFontOfSize:15];
    _connectStatus.textColor = [UIColor colorWithHexString:@"#737f7f"];
    _connectStatus.text = @"设备连接状态:  未连接";
//    _connectStatus.backgroundColor = [UIColor redColor];
    [self addSubview:_connectStatus];

    _person = [[UIImageView alloc] init];
    _person.image = [UIImage imageNamed:@"measure_icon_normal"];
    [self addSubview:_person];

    _person_BMI = [[UILabel alloc] init];
    _person_BMI.font = [UIFont systemFontOfSize:15];
    _person_BMI.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self addSubview:_person_BMI];

    _BMI = [[UILabel alloc] init];
    _BMI.font = [UIFont systemFontOfSize:15];
    _BMI.text = @"BMI:";
    _BMI.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self addSubview:_BMI];

    line = [[UIView alloc] init];
     line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self addSubview:line];

}

-(void)setIsBlooth:(BOOL)isBlooth{
    _isBlooth = isBlooth;
    if (isBlooth == YES) {
        _bluetooth.hidden = YES;
        _connectStatus.hidden = YES;
    }
}
-(void)setStatus:(NSString *)status{
    _status = status;
    _connectStatus.text = [NSString stringWithFormat:@"设备连接状态:  %@",status];
    
}

-(void)setImg_name:(NSString *)img_name{
    _img_name = img_name;
    _person.image = [UIImage imageNamed:img_name];
}

- (void)setBMI_status:(NSString *)BMI_status{

    _BMI_status = BMI_status;


    if ([BMI_status containsString:@"("]) {

        NSArray * arr = [BMI_status componentsSeparatedByString:@"("];
        NSString * info1 = arr[0];
        NSString * status = arr[1];


        _person_BMI.text = [NSString stringWithFormat:@"%@ (%@",info1,status];

        if ([BMI_status containsString:@"标准"]) {
            _person.image = [UIImage imageNamed:@"measure_icon_normal"];
            _person_BMI.textColor = [UIColor colorWithHexString:@"#38c750"];
        }else if ([BMI_status containsString:@"偏低"] || [BMI_status containsString:@"偏瘦"]){
            _person.image = [UIImage imageNamed:@"measure_icon_thin"];
            _person_BMI.textColor = [UIColor colorWithHexString:@"#53d3d3"];
        }else if ([BMI_status containsString:@"偏高"] || [BMI_status containsString:@"较高"] ){
            _person.image = [UIImage imageNamed:@"measure_icon_fat"];
            _person_BMI.textColor = [UIColor colorWithHexString:@"#ee941f"];
        }else if ( [BMI_status containsString:@"较胖"] || [BMI_status containsString:@"偏胖"] || [BMI_status containsString:@"超重"]){
            _person.image = [UIImage imageNamed:@"measure_icon_weight"];
            _person_BMI.textColor = [UIColor colorWithHexString:@"#d23030"];
        }else{

        }

    }else{
        _person.image = [UIImage imageNamed:@"measure_icon_normal"];
        _person_BMI.text = BMI_status;

    }


}
- (void)layoutSubviews{
    [super layoutSubviews];

    [_bluetooth mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(9);
        make.width.height.mas_equalTo(20);
    }];

    [_connectStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bluetooth);
        make.left.equalTo(_bluetooth.mas_right).offset(8);
//        make.right.equalTo(self);
//        make.left.equalTo(_bluetooth.mas_right);
    }];

    [_person mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.height.mas_equalTo(300);
        make.width.mas_equalTo(122.5);
    }];

    [_BMI mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_person.mas_bottom).offset(20);
        make.right.equalTo(_person_BMI.mas_left);
        make.width.mas_equalTo(40);
        make.centerX.equalTo(_person).offset(-15);
    }];

    [_person_BMI mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_BMI);
        make.right.equalTo(self);
    }];

    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
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
