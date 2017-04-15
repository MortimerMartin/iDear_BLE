//
//  homZVC.h
//  SuperWatch
//
//  Created by pro on 17/2/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reloadName_head)(NSString * name , NSString * head);
@interface homZVC : UIViewController
@property (nonatomic , copy) reloadName_head reloadNH;

@end
