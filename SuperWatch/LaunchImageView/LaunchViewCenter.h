//
//  LaunchViewCenter.h
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchViewCenter : NSObject

+ (instancetype)shareInstance;

+(void)showLunchView:(NSArray *)imgArray;

@end
