//
//  HeightViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "HeightViewController.h"
#import "HeightView.h"
#import "AppDelegate.h"
#import "UserCenter.h"
@interface HeightViewController ()

@end

@implementation HeightViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HeightView * heightView = [[HeightView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:heightView];

    heightView.isBack = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    heightView.isEnd = ^{
        // 获取当前路由的控制器数组
//        NSMutableArray * vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
////        NSLog(@"%lu",(unsigned long)[vcArr count]);
//        [vcArr removeAllObjects];
//        [self.navigationController setViewControllers:vcArr animated:NO];
        [UserCenter shareUserCenter].isLogin = YES;
        [[NSUserDefaults standardUserDefaults] setBool:[UserCenter shareUserCenter].isLogin forKey:@"UserIsLogin"];

        [((AppDelegate*) [[UIApplication sharedApplication] delegate]) setupHomeViewController];
    };
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"5555555");

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
