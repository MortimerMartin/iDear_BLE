//
//  PersonHistoryHeadView.h
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonHistoryHeadView : UICollectionReusableView

@property (nonatomic , copy) NSString * name;
@property (nonatomic , copy) NSString * content;
@property (nonatomic , strong) NSArray * values;
@property (nonatomic , strong) NSArray * dates;
@property (nonatomic , strong) UIView * backGroundView;
@property (nonatomic , strong) UIColor * color;

@property (nonatomic , assign) int setOffX;

- (void)refreshView;
@end
