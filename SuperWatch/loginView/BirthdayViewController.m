//
//  BirthdayViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BirthdayViewController.h"
#import "BirthdayView.h"
#import "HeightViewController.h"
@interface BirthdayViewController ()

@end

@implementation BirthdayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     BirthdayView * birthView = [[BirthdayView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:birthView];
    
        birthView.isBackBlock = ^ {
             [self.navigationController popViewControllerAnimated:YES];

        };
    //
        birthView.isNextBlock = ^ {
            HeightViewController * height = [[HeightViewController alloc] init];
            [self.navigationController pushViewController:height animated:YES];
        };

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"444444");
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
