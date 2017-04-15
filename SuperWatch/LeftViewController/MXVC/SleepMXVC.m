//
//  SleepMXVC.m
//  SuperWatch
//
//  Created by Mortimer on 17/3/22.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "SleepMXVC.h"
//#import "PersonHistoryCell.h"
#import "DeleteHistoryCell.h"
#import "UIColor+HexString.h"
#import "DataManager.h"
#import "UserCenter.h"
#import "PersonHistoryModel.h"
@interface SleepMXVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * historyArr;

@property (nonatomic , strong) UIButton * rightEdit;

@end

@implementation SleepMXVC

static NSString * kSDeleteHistoryCell = @"DeleteHistoryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    [self setNavigationView];

    [self setupTableView];
    [self loadBodyFatList];
    // Do any additional setup after loading the view.
}

- (void)loadBodyFatList{
    //    NSDictionary * dict = @{
    //                            @"userId":_userId,
    //                            @"beginDate":_beginString,
    //                            @"endDate":_endString
    //                            };
    //    __weak typeof(self) weakSelf = self;
    //    [[DataManager manager] postDataWithUrl:@"doQueryBodyFatList" parameters:dict success:^(id json) {
    //        NSDictionary * dict1 = json;
    //        if ([dict1[@"status"] intValue] == 1) {
    //
    //            weakSelf.historyArr = [PersonHistoryModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];
    //            [weakSelf.tableView reloadData];
    //
    //        }else{
    //            [SVProgressHUD showErrorWithStatus:@"信息获取失败"];
    //        }
    //
    //    } failure:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    //    }];


}

- (void)setupTableView{

    _historyArr = [NSMutableArray array];


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[DeleteHistoryCell  class] forCellReuseIdentifier:kSDeleteHistoryCell];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];

    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    //    _tableView.editing = YES;




}

- (NSString *)timeFormat
{
    NSDate *selected = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_historyArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DeleteHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:kSDeleteHistoryCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSDeleteHistoryCell forIndexPath:indexPath];
    }
    cell.isEdit=_rightEdit.selected;
    cell.left_time = @"";
    cell.right_content = @"";
    [cell.deleteBtn addTarget:self action:@selector(deleteSleepinfo:) forControlEvents:UIControlEventTouchUpInside];
//    PersonHistoryModel * person = _historyArr[indexPath.row];
//    cell.time = person.createDate;
//    cell.weight = person.weight;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.tintColor = [UIColor redColor];

    return cell;




}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    MINGXIViewController * mingxi = [[MINGXIViewController alloc] init];
    //    PersonHistoryModel * person = _historyArr[indexPath.row];
    //    mingxi.bodyFatId = person.bodyFatId;
    //    [self.navigationController pushViewController:mingxi animated:YES];


}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 50.0f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void)deleteSleepinfo:(UIButton *)sender{
    UIView * contentView = sender.superview;
    UIView * cell = contentView.superview;
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)cell];

    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        PersonHistoryModel * person = _historyArr[indexPath.row];
//        NSDictionary * dict = @{@"bodyFatId":person.bodyFatId};
        //        __weak typeof(self) weakSelf = self;
        //        [[DataManager manager] postDataWithUrl:@"doDeleteBodyFat" parameters:dict success:^(id json) {
        //            NSDictionary * dict1 = json;
        //            if ([dict1[@"status"] intValue] == 1) {
        //                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        //                [weakSelf.historyArr removeObjectAtIndex:indexPath.row];
        //                [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //
        //            }else{
        //                [SVProgressHUD showErrorWithStatus:@"删除失败"];
        //            }
        //        } failure:^(NSError *error) {
        //            [SVProgressHUD showErrorWithStatus:@"信息提交失败"];
        //        }];

        [_historyArr removeObjectAtIndex:indexPath.row];

        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }


}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (void)setNavigationView{

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(9 , 8, 40, 22)];
    label.text = @"返回";
    label.font= [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithHexString:@"565c5c"];

    UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 13, 6, 12)];
    back.image =  [UIImage imageNamed:@"icon_back"];
    back.userInteractionEnabled = YES;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [view addSubview:label];
    [view addSubview:back];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPersonCenter:)];
    [view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};


    _rightEdit = [[UIButton alloc] init];
    [_rightEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightEdit setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    [_rightEdit addTarget:self action:@selector(EditSleepVC:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"睡眠明细";
//    self.navigationController.title  = @"睡眠明细";

}
//数据删除
-(void)EditSleepVC:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_rightEdit setTitle:@"完成" forState:UIControlStateNormal];
        [_rightEdit setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    }else{
        [_rightEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightEdit setTitleColor:[UIColor colorWithHexString:@"565c5c"] forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)popPersonCenter:(UITapGestureRecognizer *)tap{
    
    [self.navigationController popViewControllerAnimated:YES];
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
