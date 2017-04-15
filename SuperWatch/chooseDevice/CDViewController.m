//
//  CDViewController.m
//  SuperWatch
//
//  Created by pro on 17/3/2.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "CDViewController.h"
#import "CDTableViewCell.h"


#define kCDTableViewCell @"kCDTableViewCell"
@interface CDViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView * tableView;

@end

@implementation CDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    _deviceList = [NSMutableArray array];
    // Do any additional setup after loading the view.
}


- (void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

    [_tableView registerClass:[CDTableViewCell class] forCellReuseIdentifier:kCDTableViewCell];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _deviceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    CDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCDTableViewCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCDTableViewCell forIndexPath:indexPath];
    }

    return cell;

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
