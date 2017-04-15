//
//  SearchAnimationView.h
//  SuperWatch
//
//  Created by pro on 17/2/13.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchBLEDelegate <NSObject>

- (void)nofind_MyBle;// 学习协议 代理

- (void)SearchBleTime:(int)time WithTransform:(CGAffineTransform)transform;
@end
@interface SearchAnimationView : UIView

@property (nonatomic , assign) int timeP;
@property(nonatomic) CGAffineTransform Seachtransform;
- (void)startTimer;
- (void)pauserTimer;

@property (nonatomic , assign) id<SearchBLEDelegate> delegate; // 代理属性
@end
