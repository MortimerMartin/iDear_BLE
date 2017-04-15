//
//  PersonLastVC.h
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isBackInfo)(NSString * info);
@interface PersonLastVC : UIViewController

@property (nonatomic , copy) NSString * VCtitle;
@property (nonatomic , copy) NSString * VCinfo;

@property (nonatomic , copy) NSString * VCfuntion;
@property (nonatomic , copy) isBackInfo isBack;

@end
