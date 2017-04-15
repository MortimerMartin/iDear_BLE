//
//  sexView.h
//  SuperWatch
//
//  Created by pro on 17/2/11.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isManBlock)(void);

@interface sexView : UIView

@property (nonatomic , copy) isManBlock isMan;

@property (nonatomic , copy) isManBlock isBack;

@end
