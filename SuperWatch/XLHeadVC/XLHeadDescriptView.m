//
//  XLHeadDescriptView.m
//  SuperWatch
//
//  Created by pro on 17/3/5.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "XLHeadDescriptView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
@interface XLHeadDescriptView ()
{
    UILabel * leftnameLabel;
    UILabel * midnameLabel;
    UILabel * rightnameLabel;

    UIView * leftFView;
    UIView * rightFView;

    UILabel * leftTimeLabel;
    UILabel * midTimeLabel;
    UILabel * rightTimeLabel;
}
@property (nonatomic , strong) UIView * backGView;

@property (nonatomic , strong) UILabel * leftHeadLabel;
@property (nonatomic , strong) UILabel * midHeadLabel;
@property (nonatomic , strong) UILabel * rightHeadLabel;


@end
@implementation XLHeadDescriptView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupXLHeadView];
    }
    return self;
}

- (void)setLeft_head:(NSString *)left_head{
    _left_head = left_head;
    _leftHeadLabel.text = left_head;
}

- (void)setMid_head:(NSString *)mid_head{
    _mid_head = mid_head;
    _midHeadLabel.text = mid_head;
}

- (void)setRight_head:(NSString *)right_head{
    _right_head = right_head;
    _rightHeadLabel.text = right_head;
}

- (void)setLeft_time:(NSString *)left_time{
    _left_time = left_time;
    leftTimeLabel.text = left_time;
}

- (void)setMid_time:(NSString *)mid_time{
    _mid_time = mid_time;
    midTimeLabel.text = mid_time;
}

- (void)setRight_time:(NSString *)right_time{
    _right_time = right_time;
    rightTimeLabel.text = right_time;
}

- (void)setupXLHeadView{
    _backGView = [[UIView alloc] init];
    _backGView.layer.cornerRadius = 5;
    _backGView.layer.masksToBounds = YES;
    _backGView.layer.borderWidth = 0.5;
    _backGView.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
    [self addSubview:_backGView];
    
    leftnameLabel = [[UILabel alloc] init];
    leftnameLabel.text = @"当天平均心率";
    leftnameLabel.font = [UIFont systemFontOfSize:13];
    leftnameLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    leftnameLabel.textAlignment = NSTextAlignmentRight;
    [_backGView addSubview:leftnameLabel];

    midnameLabel = [[UILabel alloc] init];
    midnameLabel.text = @"当天最高心率";
    midnameLabel.font = [UIFont systemFontOfSize:13];
    midnameLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    midnameLabel.textAlignment = NSTextAlignmentRight;
    [_backGView addSubview:midnameLabel];

    rightnameLabel = [[UILabel alloc] init];
    rightnameLabel.text = @"当天最低心率";
    rightnameLabel.font = [UIFont systemFontOfSize:13];
    rightnameLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    rightnameLabel.textAlignment = NSTextAlignmentRight;
    [_backGView addSubview:rightnameLabel];

    _leftHeadLabel = [[UILabel alloc] init];
    _leftHeadLabel.font = [UIFont systemFontOfSize:30];
    _leftHeadLabel.textColor = [UIColor colorWithHexString:@"#fb5cb9"];
    _leftHeadLabel.textAlignment = NSTextAlignmentRight;
    [_backGView addSubview:_leftHeadLabel];

    _midHeadLabel = [[UILabel alloc] init];
    _midHeadLabel.font = [UIFont systemFontOfSize:30];
    _midHeadLabel.textColor = [UIColor colorWithHexString:@"#fb5cb9"];
    _midHeadLabel.textAlignment = NSTextAlignmentRight;
    [_backGView addSubview:_midHeadLabel];

    _rightHeadLabel = [[UILabel alloc] init];
    _rightHeadLabel.font = [UIFont systemFontOfSize:30];
    _rightHeadLabel.textColor = [UIColor colorWithHexString:@"#fb5cb9"];
    _rightHeadLabel.textAlignment = NSTextAlignmentRight;
    [_backGView addSubview:_rightHeadLabel];

    leftFView = [[UIView alloc] init];
    leftFView.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [_backGView addSubview:leftFView];

    rightFView =[[UIView alloc] init];
    rightFView.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [_backGView addSubview:rightFView];

    leftTimeLabel = [[UILabel alloc] init];
    leftTimeLabel.font= [UIFont systemFontOfSize:12];
    leftTimeLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGView addSubview:leftTimeLabel];

    midTimeLabel = [[UILabel alloc] init];
    midTimeLabel.font= [UIFont systemFontOfSize:12];
    midTimeLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGView addSubview:midTimeLabel];

    rightTimeLabel = [[UILabel alloc] init];
    rightTimeLabel.font= [UIFont systemFontOfSize:12];
    rightTimeLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [_backGView addSubview:rightTimeLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_backGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
    }];

    [leftFView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backGView).offset(12);
        make.bottom.equalTo(self.backGView).offset(-12);
        make.width.mas_equalTo(0.5);
        make.centerX.equalTo(self.backGView).offset(-(self.cl_width - 24)/6);
    }];

    [rightFView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(leftFView);
        make.centerX.equalTo(self.backGView).offset((self.cl_width - 24)/6);
    }];

    [leftnameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftFView.mas_left).offset(-18);
        make.top.equalTo(leftFView);
    }];

    [_leftHeadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftnameLabel);
        make.centerY.equalTo(leftFView);
    }];

    [leftTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftnameLabel);
        make.bottom.equalTo(leftFView);
    }];

    [midnameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightFView.mas_left).offset(-18);
        make.top.equalTo(leftFView);
    }];

    [_midHeadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(midnameLabel);
        make.centerY.equalTo(leftFView);
    }];

    [midTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(midnameLabel);
        make.bottom.equalTo(leftFView);
    }];

    [rightnameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backGView).offset(-18);
        make.top.equalTo(rightFView);
    }];

    [_rightHeadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightnameLabel);
        make.centerY.equalTo(leftFView);
    }];

    [rightTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightnameLabel);
        make.bottom.equalTo(leftFView);
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
