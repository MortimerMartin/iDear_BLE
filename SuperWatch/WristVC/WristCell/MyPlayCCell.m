//
//  MyPlayCCell.m
//  SuperWatch
//
//  Created by pro on 17/3/5.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "MyPlayCCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
@interface MyPlayCCell ()

@property (nonatomic , strong) UIView * backPlayCell;
@property (nonatomic , strong) UILabel * name_label;
@property (nonatomic , strong) UILabel * content_label;

@end
@implementation MyPlayCCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupMyPlayCCell];
    }

    return self;
}

- (void)setupMyPlayCCell{
    _backPlayCell = [[UIView alloc] init];
    _backPlayCell.backgroundColor = [UIColor whiteColor];
    _backPlayCell.layer.cornerRadius = 5;
    _backPlayCell.layer.masksToBounds = YES;
    _backPlayCell.layer.borderWidth = 0.5;
    _backPlayCell.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
    [self.contentView addSubview:_backPlayCell];


    _name_label = [[UILabel alloc] init];
    _name_label.font = [UIFont systemFontOfSize:16];
    _name_label.textColor = [UIColor colorWithHexString:@"#9aa9a9"];
    [_backPlayCell addSubview:_name_label];

    _content_label = [[UILabel alloc] init];
    _content_label.font = [UIFont systemFontOfSize:25];
    _content_label.textColor = [UIColor colorWithHexString:@"#f88027"];
    [_backPlayCell addSubview:_content_label];
    

}


- (void)setName:(NSString *)name{
    _name = name;
    _name_label.text = name;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _content_label.text = content;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_backPlayCell mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    [_name_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_backPlayCell).offset(8);
    }];
    [_content_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(_backPlayCell).offset(-8);
    }];
}

@end
