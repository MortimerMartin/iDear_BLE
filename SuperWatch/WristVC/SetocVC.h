//
//  SetocVC.h
//  SuperWatch
//
//  Created by pro on 17/3/4.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^resetTimer)(void);
@interface SetocVC : UIViewController
@property (nonatomic , copy) resetTimer resetTimerBlock;

@end
