//
//  PersonCell.m
//  SuperWatch
//
//  Created by pro on 17/2/14.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "UIView+CLExtension.h"
@interface PersonCell ()
{
    UIView * line;
}
@property (nonatomic , strong) UIImageView * leftImg;

@property (nonatomic , strong) UILabel * leftLabel;

@property (nonatomic , strong) UILabel * rightLabel;
@property (nonatomic , strong) UILabel * rightStatus;

@end
@implementation PersonCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupPersonView];
    }

    return self;
}


- (void)setImg:(NSString *)img{
    _img = img;
    _leftImg.image = [UIImage imageNamed:img];
}

- (void)setName:(NSString *)name{
    _name = name;
    _leftLabel.text = name;
}

- (void)setInfo:(NSString *)info{
    _info = info;
    if ([info containsString:@"("]) {
        NSArray * arr = [info componentsSeparatedByString:@"("];
        NSString * info1 = arr[0];
        NSString * status = arr[1];
        _rightLabel.text = info1;

        _rightStatus.text = [NSString stringWithFormat:@"(%@",status];
        if ([status containsString:@"标准"]) {
            _rightStatus.textColor = [UIColor colorWithHexString:@"#38c750"];
        }else if ([status containsString:@"偏低"] || [status containsString:@"偏瘦"]){
            _rightStatus.textColor = [UIColor colorWithHexString:@"#53d3d3"];
        }else if ([status containsString:@"偏高"] || [status containsString:@"较高"] || [status containsString:@"较胖"] || [status containsString:@"偏胖"] || [status containsString:@"超重"]){
            _rightStatus.textColor = [UIColor colorWithHexString:@"#d23030"];
        }


//        NSLog(@"%@/%@",info1,info2);
    }else{
        _rightLabel.text = info;
    }


}
//- (void)setStatus:(NSString *)status{
//    _status = status;
//    if ([self isBlankString:status]) {
//        return;
//    }
//
//}

//判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if ([string isEqualToString:@""] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]) {
        return YES;
    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }

    return NO;
}


- (void)setupPersonView{
    _leftImg = [[UIImageView alloc] init];
    [self.contentView addSubview:_leftImg];

    _leftLabel = [[UILabel alloc] init];
    _leftLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
    _leftLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_leftLabel];
//    _leftLabel.backgroundColor = [UIColor redColor];


    _rightLabel = [[UILabel alloc] init];
    _rightLabel.textColor = [UIColor colorWithHexString:@"#565c5c"];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_rightLabel];


    _rightStatus = [[UILabel alloc] init];
    _rightStatus.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_rightStatus];


    line = [[UIView alloc] init];
        line.backgroundColor = [UIColor  colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:line];



}


- (void)layoutSubviews{
    [super layoutSubviews];

    [_leftImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(9);
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo(24);
    }];

    [_leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImg.mas_right).offset(9);
        make.centerY.equalTo(_leftImg);
        make.width.mas_equalTo(self.contentView.cl_width/2);
//        make.height.mas_equalTo(24);
    }];

    [_rightStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-9);
        if ([self isBlankString:_rightStatus.text]) {
            make.left.equalTo(_rightLabel.mas_right);
        }else{
            make.left.equalTo(_rightLabel.mas_right).offset(9);
        }

        make.centerY.equalTo(self.contentView);
    }];

    [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_rightStatus.mas_left).offset(-9);
        make.centerY.equalTo(_rightStatus);
    }];

    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];

}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
