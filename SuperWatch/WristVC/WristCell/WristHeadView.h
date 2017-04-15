//
//  WristHeadView.h
//  SuperWatch
//
//  Created by pro on 17/3/2.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WristHeadView : UIView

@property (nonatomic , assign) BOOL SHFill;


@property (nonatomic , copy) NSString * connect_status;
@property (nonatomic , assign) int element_D;
@property (nonatomic , assign) int current_b;
@property (nonatomic , assign) int finish_b;
@property (nonatomic , assign) CGFloat progress;

//-(void)reloadViewWithPercent:(float)percent;

@end
