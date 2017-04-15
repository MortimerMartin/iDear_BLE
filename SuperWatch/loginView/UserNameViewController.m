//
//  UserNameViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "UserNameViewController.h"
#import "UIView+CLExtension.h"
#import "UserNameView.h"
#import "sexViewController.h"
@interface UserNameViewController ()

@end

@implementation UserNameViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     UserNameView * userView = [[UserNameView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:userView];

    userView.isName = ^{
        sexViewController * sex = [[sexViewController alloc] init];
        [self.navigationController pushViewController:sex animated:YES];
    };
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"22222");
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
