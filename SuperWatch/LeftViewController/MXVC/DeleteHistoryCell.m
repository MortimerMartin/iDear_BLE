//
//  DeleteHistoryCell.m
//  SuperWatch
//
//  Created by Mortimer on 17/3/24.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "DeleteHistoryCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
@interface DeleteHistoryCell ()
{
    UIView * bottom_line;

}
@property (nonatomic , strong) UILabel  * left_time_label;

@property (nonatomic , strong) UILabel * right_info;

@property (nonatomic , strong) UIImageView * img;

@end
@implementation DeleteHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupDeleteHistroyCell];
    }
    return self;

}

-(void)setupDeleteHistroyCell{
    _left_time_label = [[UILabel alloc] init];
    _left_time_label.font = [UIFont systemFontOfSize:15];
    _left_time_label.textColor = [UIColor colorWithHexString:@"#737f7f"];
    [self.contentView addSubview:_left_time_label];


    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@"person_btn_go"];
    [self.contentView addSubview:_img];

    _right_info = [[UILabel alloc] init];
    _right_info.textColor = [UIColor colorWithHexString:@"#565c5c"];
    _right_info.textAlignment = NSTextAlignmentRight;
    _right_info.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_right_info];

    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.backgroundColor = [UIColor redColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;

    bottom_line = [[UIView alloc] init];
    bottom_line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [self.contentView addSubview:bottom_line];
}
-(void)setLeft_time:(NSString *)left_time{
    _left_time = left_time;
    _left_time_label.text = left_time;
}

-(void)setRight_content:(NSString *)right_content{
    _right_content = right_content;
    _right_info.text = right_content;
}
-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit == YES) {
        _img.hidden = YES;
        _deleteBtn.hidden = NO;
    }else{
        _img.hidden = NO;
        _deleteBtn.hidden = YES;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutDeleteHistoryCell];

}

-(void)layoutDeleteHistoryCell{

    [_left_time_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(9);

    }];

    [_img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-9);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(15);
    }];

    [_deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(_img);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(25);
    }];

    [_right_info mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_isEdit == YES) {
            make.centerY.equalTo(_img);
            make.right.equalTo(_deleteBtn.mas_left).offset(-7);
        }else{
            make.centerY.equalTo(_img);
            make.right.equalTo(_img.mas_left).offset(-7);
        }

    }];


    [bottom_line mas_updateConstraints:^(MASConstraintMaker *make) {
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
