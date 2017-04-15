//
//  WritShadeView.h
//  SuperWatch
//
//  Created by Mortimer on 17/3/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WritShadeView : UIView

/**
 *
 *             ________
 *         ____\_\_\_\_\
 *       |   __________===== o o o o  [开启计时器]
 *       |__/   /c_/
 *
 */
-(void)startWritTimer;

/**
 *
 *             ________
 *         ____\_\_\_\_\
 *       |   __________===== o o o o  [关闭计时器]
 *       |__/   /c_/
 *
 */
- (void)pauseWritTimer:(NSString *)status;

/**
 关闭计时器并隐藏
 */
-(void)pauserTimeAndHidden;
@end
