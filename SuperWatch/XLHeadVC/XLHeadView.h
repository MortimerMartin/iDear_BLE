//
//  XLHeadView.h
//  SuperWatch
//
//  Created by pro on 17/3/5.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLHeadView : UIView

@property (nonatomic , copy) NSString * name;
@property (nonatomic , copy) NSString * content;
@property (nonatomic , strong) NSMutableArray * values;
@property (nonatomic , strong) NSMutableArray * dates;
@property (nonatomic , strong) UIView * backGroundView;
@property (nonatomic , strong) UIColor * color;

//@property (nonatomic , assign) int setOffX;

- (void)refreshView;

@end
