//
//  HeightView.h
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JVFloatLabeledTextField;

typedef void(^isEndBlock)(void);
@interface HeightView : UIView

@property (nonatomic , copy) JVFloatLabeledTextField * heightField;

@property (nonatomic , copy) isEndBlock isEnd;

@property (nonatomic , copy) isEndBlock isBack;

@end
