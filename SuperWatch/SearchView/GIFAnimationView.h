//
//  GIFAnimationView.h
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIFAnimationView : UIView

- (void)startTimer;

- (void)pauserTimer;

@property (nonatomic , copy) NSString * status;

@end
