//
//  LeftViewController.h
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isShowView)(BOOL show ,NSString * source ,NSString * userName);
@interface LeftViewController : UIViewController

@property (nonatomic , copy) isShowView  isShow;

@end
