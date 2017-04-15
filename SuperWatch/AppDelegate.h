//
//  AppDelegate.h
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *channel = @"App Store";
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//登录页面
-(void)setupLoginViewController;
//跳转到首页
-(void)setupHomeViewController;
@end

