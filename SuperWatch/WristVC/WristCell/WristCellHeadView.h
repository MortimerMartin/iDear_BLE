//
//  WristCellHeadView.h
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WristCellHeadView : UIView

@property (nonatomic , copy) NSString * img_name;
@property (nonatomic , copy) NSString * fun_name;
@property (nonatomic , copy) NSString * fun_content;
@property (nonatomic , copy) NSString * fun_top;
@property (nonatomic , copy) NSString * fun_bottom;

@property (nonatomic , strong) UIColor * color;

@end
