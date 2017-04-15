//
//  UserCenter.h
//  SuperWatch
//
//  Created by pro on 17/2/20.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenter : NSObject
+(UserCenter *)shareUserCenter;

@property (nonatomic , copy) NSString * name;
@property (nonatomic , copy) NSString * source;
@property (nonatomic , copy) NSString * sex;
@property (nonatomic , copy) NSString * phone;
@property (nonatomic , copy) NSString * height;
@property (nonatomic , copy) NSString * userId;
@property (nonatomic , copy) NSString * bithday;
@property (nonatomic , copy) NSString * age;
@property (nonatomic , copy) NSString * homenumer;


@property (nonatomic , assign) BOOL  isLogin;

- (void)saveUserDefaults;
/**
 *  退出登录
 */
- (void)logout;

@end
