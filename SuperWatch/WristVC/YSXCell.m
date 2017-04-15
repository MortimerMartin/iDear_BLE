//
//  YSXCell.m
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "YSXCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
@interface YSXCell ()

@property (nonatomic , strong) UIView * backgView;


@end
@implementation YSXCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];;
        [self setupYSXCell];
    }

    return self;
}

- (void)setupYSXCell{
    _backgView = [[UIView alloc] init];

    [self.contentView addSubview:_backgView];

    _imgView = [[UIButton alloc] init];

//    _imgView.userInteractionEnabled = YES;
    [_backgView addSubview:_imgView];

}


- (void)setImg_name:(NSString *)img_name{
    _img_name = img_name;
    [_imgView setImage:[UIImage imageNamed:img_name] forState:UIControlStateNormal];

}

-(void)setHight_name:(NSString *)hight_name{
    _hight_name = hight_name;
    [_imgView setImage:[UIImage imageNamed:hight_name] forState:UIControlStateHighlighted];
}
-(void)layoutSubviews{
    [super layoutSubviews];

    [_backgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView);
    }];

    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_backgView);
    }];
}


//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
