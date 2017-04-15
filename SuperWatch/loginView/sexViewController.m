//
//  sexViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "sexViewController.h"
#import "sexView.h"
#import "BirthdayViewController.h"
@interface sexViewController ()

@end

@implementation sexViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    sexView * sexViewC = [[sexView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:sexViewC];
        sexViewC.isBack = ^{
              [self.navigationController popViewControllerAnimated:YES];

        };

        sexViewC.isMan = ^{
            BirthdayViewController * birh = [[BirthdayViewController alloc] init];
            [self.navigationController pushViewController:birh animated:YES];
        };
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"333333");
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
