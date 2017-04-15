//
//  UserCenter.m
//  SuperWatch
//
//  Created by pro on 17/2/20.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "UserCenter.h"
#import "AppDelegate.h"
@implementation UserCenter

-(instancetype)init{

    if (self = [super init]) {
        [self loadUserDefaults];
    }

    return self;
}
static UserCenter * defaultCenter = nil;
+(UserCenter *)shareUserCenter {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        defaultCenter = [[UserCenter alloc] init];

    });

    return defaultCenter;
};


- (void)saveUserDefaults{
    [[NSUserDefaults standardUserDefaults] setValue:self.name forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.source forKey:@"UserSource"];
    [[NSUserDefaults standardUserDefaults] setValue:self.sex forKey:@"UserSex"];
    [[NSUserDefaults standardUserDefaults] setValue:self.height forKey:@"UserHeight"];
    [[NSUserDefaults standardUserDefaults] setValue:self.phone forKey:@"UserPhone"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userId forKey:@"UserUserId"];
    [[NSUserDefaults standardUserDefaults] setBool:self.isLogin forKey:@"UserIsLogin"];
    [[NSUserDefaults standardUserDefaults] setValue:self.bithday forKey:@"UserBirthDay"];
    [[NSUserDefaults standardUserDefaults] setValue:self.homenumer forKey:@"UserHomeNumber"];
    [[NSUserDefaults standardUserDefaults] setValue:self.age forKey:@"UserAge"];

}

- (void)loadUserDefaults{
    self.name = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    self.source = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserSource"];
    self.sex = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserSex"];
    self.phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPhone"];
    self.height = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserHeight"];
    self.userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserUserId"];
    self.isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserIsLogin"];
    self.bithday = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBirthDay"];
    self.age = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAge"];
    self.homenumer = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserHomeNumber"];



}

- (void)logout{
    self.name = nil;
    self.source = nil;
    self.sex = nil;
    self.phone = nil;
    self.bithday = nil;
    self.height = nil;
    self.age = nil;
    self.userId = nil;
    self.isLogin = nil;
    self.homenumer = nil;

    self.isLogin = NO;
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"LastConnect"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LastTlC_history"];//手环上次连接时间
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"Click_F"]; //选择设备
    [[NSUserDefaults standardUserDefaults] setBool:nil forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"Click_TZC"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"Click_SH"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"startHeartRateMode"];//心率开关
    [kUserDefaults setBool:NO forKey:@"kCancel"];
    [kUserDefaults synchronize];
     [((AppDelegate*) [[UIApplication sharedApplication] delegate]) setupLoginViewController];
}
@end
