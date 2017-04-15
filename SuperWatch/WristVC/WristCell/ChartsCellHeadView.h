//
//  ChartsCellHeadView.h
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartsCellHeadView : UIView
@property (nonatomic , copy) NSString * img_name;
@property (nonatomic , copy) NSString * fun_name;
@property (nonatomic , copy) NSString * fun_content;
@property (nonatomic , strong) NSArray * heartValue;

@property (nonatomic , strong) UIColor * color;
@end
