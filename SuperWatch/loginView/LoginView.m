//
//  LoginView.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "LoginView.h"
#import "MessageView.h"
#import "UIView+CLExtension.h"
//#import "UserNameView.h"
//#import "sexView.h"
//#import "BirthdayView.h"
//#import "HeightView.h"
#import "SVProgressHUD.h"
#import "UserNameViewController.h"
#import "AppDelegate.h"
#define kUserDefaults [NSUserDefaults standardUserDefaults]
@interface LoginView ()

//@property (nonatomic , strong) UIScrollView * scrollView;
@end

@implementation LoginView

#pragma mark - Getters

/**
 *  懒加载
 *
 */

//- (UIScrollView * )scrollView{
//
//    if (!_scrollView){
//
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
//        _scrollView.contentSize =CGSizeMake(0,0);
//        //取消弹簧效果
//        _scrollView.bounces = NO;
//        _scrollView.pagingEnabled = YES;
//        [self.view addSubview:_scrollView];
//    }
//
//    return _scrollView;
//    
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    MessageView * view = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, self.view.cl_width, self.view.cl_height)];
    
    [self.view addSubview:view];


//    UserNameView * userView = [[UserNameView alloc] initWithFrame:CGRectMake(self.view.cl_width, 0, self.view.cl_width, self.view.cl_height)];
//
//    sexView * sexViewC = [[sexView alloc] initWithFrame:CGRectMake(self.view.cl_width*2,0, self.view.cl_width, self.view.cl_height)];
//
//    BirthdayView * birthView = [[BirthdayView alloc] initWithFrame:CGRectMake(self.view.cl_width * 3, 0, self.view.cl_width, self.view.cl_height)];
//
//    HeightView * heightView = [[HeightView alloc] initWithFrame:CGRectMake(self.view.cl_width * 4, 0, self.view.cl_width, self.view.cl_height)];
//
//    [self.scrollView addSubview:view];
//    [self.scrollView addSubview:userView];
//    [self.scrollView addSubview:sexViewC];
//    [self.scrollView addSubview:birthView];
//    [self.scrollView addSubview:heightView];
//
//    __weak typeof(self) weakSelf = self;

  
    view.isLogin = ^(NSInteger indexNum){

        if (indexNum == 1) {
            [((AppDelegate*) [[UIApplication sharedApplication] delegate]) setupHomeViewController];
        }else if (indexNum == 0){
            UserNameViewController * user = [[UserNameViewController alloc] init];
            [self.navigationController pushViewController:user animated:YES];
        }else{

            [SVProgressHUD showErrorWithStatus:@"服务器异常"];
        }



//        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width, 0) animated:YES];
    };
//
//    userView.isName = ^{
//        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width*2, 0) animated:YES];
//    };
//
//    userView.isMove = ^{
//        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width, 0) animated:NO];
//    };
//
//    sexViewC.isBack = ^{
//         [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width, 0) animated:YES];
//    };
//
//    sexViewC.isMan = ^{
//        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width * 3, 0) animated:YES];
//    };
//
//    birthView.isBackBlock = ^ {
//        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width * 2, 0) animated:YES];
//    };
//
//    birthView.isNextBlock = ^ {
//         [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.view.cl_width * 4, 0) animated:YES];
//    };
//
//    
//    heightView.isEnd = ^{
//
////        [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//
//        [kUserDefaults setBool:@YES forKey:@"isAccountEnd"];
//        
////        __strong typeof(weakSelf) strongSelf = weakSelf;
//

//
////        [weakSelf dismissViewControllerAnimated:YES completion:^{
////            [strongSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
////        }];
//    };

    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
