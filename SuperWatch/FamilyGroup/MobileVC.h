//
//  MobileVC.h
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^isShowMobile)(BOOL show);
@interface MobileVC : UIViewController

@property (nonatomic , copy) NSString * B_userId;

@property (nonatomic , copy) isShowMobile  showMobile;

@property (nonatomic , copy) NSString * WAYF;

@end
