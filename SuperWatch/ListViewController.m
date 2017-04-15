//
//  ListViewController.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "ListViewController.h"
#import "PersonHistoryViewCell.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "PersonHistoryHeadView.h"
#import "XHDatePickerView.h"
#import "NSDate+Extension.h"
#import "SVProgressHUD.h"
#import "DataManager.h"
#import "UserCenter.h"
#import "PersonHistoryVC.h"
#define kCollectionViewCell @"kCollectionViewCell"
#define kCollectionHeadView @"kCollectionHeadView"
@interface ListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

{
    NSString * SBMing;
    NSString * startString;
    NSString * endString;
    NSMutableArray * content_name;
    NSMutableArray * content_content;
}
@property (nonatomic , strong) UICollectionView * collectionView;
//@property (nonatomic , strong) NSMutableArray * itemArray;
@property (nonatomic , strong) UIButton * startBtn;
@property (nonatomic , strong) UIButton * endBtn;

@property (nonatomic , strong) NSMutableArray * ContentValues;
@property (nonatomic , strong) NSMutableArray * contentDates;
@property (nonatomic , strong) NSMutableArray * personNumbers;

@property (nonatomic , strong) PersonHistoryHeadView * head;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadItemData];
    [self setupCollectionView];
    [self setNavigationView];

    SBMing = @"体重";
//    [self loadPersonInfosve];
//    [self loadProPertyInfo];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (_isFamily == YES) {
        self.navigationController.navigationBarHidden = YES;
//    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    if (_isFamily == YES) {
         self.navigationController.navigationBarHidden = NO;
//    }
}
- (void)loadProPertyInfo{

    if (!_userID) {
        return;
    }
    NSDictionary * dict = @{
                            @"userId":_userID,
                            @"property":SBMing,
                            @"beginDate":[self getSevenDaysMessage],
                            @"endDate":[self getCurrentDay]
                            };

    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryBodyFatReportByPro" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;

        if ([dict1[@"status"] intValue] == 1) {

            NSDictionary * dict2 = dict1[@"data"];
            [weakSelf.contentDates removeAllObjects];
            [weakSelf.ContentValues removeAllObjects];
            NSArray * dateArr = [dict2 allKeys];
            weakSelf.contentDates = [NSMutableArray arrayWithArray:[weakSelf ComparatorArray:dateArr]];

            for (int i = 0; i< weakSelf.contentDates.count; i++) {
                for (int j = 0; j<dateArr.count; j++) {
                    NSString * content = weakSelf.contentDates[i];
                    NSString * date = dateArr[j];
                    if ([content isEqualToString:date]) {
                        


//                        if ([dict1[@"data"][content] isKindOfClass:[NSNumber class]]){


                            [weakSelf.ContentValues addObject:dict1[@"data"][content]];

//                        }else  if ([dict1[@"data"][content] isKindOfClass:[NSString class]]) {

//                            double value = [dict1[@"data"][content] doubleValue];
//
//                            [weakSelf.ContentValues addObject:@(0.0) ];
//                        }else{
//
//                        }


//                                   NSLog(@"%@---%@+++++%@",content ,dict1[@"data"][content],weakSelf.ContentValues[i]);
                    }

                }
            }

            [weakSelf.collectionView reloadData];


            
        }else{
            [SVProgressHUD showErrorWithStatus:@"信息获取失败"];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];

}
//数组排序
- (NSArray *)ComparatorArray:(NSArray *)arr{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };

    return  [arr sortedArrayUsingComparator:cmptr];

}

- (void)loadPersonInfosve{

    if (!_userID) {
        return;
    }

    NSDictionary * dict = @{
                            @"userId":_userID,
                            @"beginDate":[self getSevenDaysMessage],
                            @"endDate":[self getCurrentDay]
                            };

    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryBodyFatReport" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

            [weakSelf.personNumbers removeAllObjects];

            NSDictionary * arr = dict1[@"data"];
            NSMutableArray * keyArray = [NSMutableArray array];
            NSMutableArray * valueArray = [NSMutableArray array];
                NSArray * key = [arr allKeys];
            NSArray * value = [arr allValues];
            for (int i =0; i<key.count ; i++) {
                    NSString * key1 = key[i];
                [keyArray addObject:key1] ;
                [valueArray addObject:value[i]];
                NSLog(@"%@---%@",key1,value[i]);

            }

            [weakSelf.personNumbers addObject:keyArray];
            [weakSelf.personNumbers addObject:valueArray];

            [weakSelf.collectionView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}


- (void)bianliPropetyInfo:(UIButton *)sender{

    if (startString  == nil|| endString == nil || startString.length<=0 || endString.length<= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择时间"];
        return;
    }

    NSDictionary * dict = @{
                            @"userId":_userID,
                            @"beginDate":startString,
                            @"endDate":endString
                            };

    __weak typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doQueryBodyFatReport" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {

            [weakSelf.personNumbers removeAllObjects];

            NSDictionary * arr = dict1[@"data"];
            NSMutableArray * keyArray = [NSMutableArray array];
            NSMutableArray * valueArray = [NSMutableArray array];
            NSArray * key = [arr allKeys];
            NSArray * value = [arr allValues];
            for (int i =0; i<key.count ; i++) {
                NSString * key1 = key[i];
                [keyArray addObject:key1] ;
                [valueArray addObject:value[i]];
                NSLog(@"%@---%@",key1,value[i]);

            }

            [weakSelf.personNumbers addObject:keyArray];
            [weakSelf.personNumbers addObject:valueArray];

            [weakSelf.collectionView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];


    NSDictionary * dict3 = @{
                            @"userId":_userID,
                            @"property":SBMing,
                            @"beginDate":startString,
                            @"endDate":endString
                            };


    [[DataManager manager] postDataWithUrl:@"doQueryBodyFatReportByPro" parameters:dict3 success:^(id json) {
        NSDictionary * dict1 = json;

        if ([dict1[@"status"] intValue] == 1) {

            NSDictionary * dict2 = dict1[@"data"];
            NSArray * dateArr = [dict2 allKeys];
            [weakSelf.contentDates removeAllObjects];
            [weakSelf.ContentValues removeAllObjects];
            weakSelf.contentDates = [NSMutableArray arrayWithArray:[weakSelf ComparatorArray:dateArr]];

            for (int i = 0; i< weakSelf.contentDates.count; i++) {
                for (int j = 0; j<dateArr.count; j++) {
                    NSString * content = weakSelf.contentDates[i];
                    NSString * date = dateArr[j];
                    if ([content isEqualToString:date]) {
//                        if ([dict1[@"data"][content] isKindOfClass:[NSString class]]) {
//
//                            [weakSelf.ContentValues addObject:@([dict1[@"data"][content] doubleValue]) ];
//                        }else if ([dict1[@"data"][content] isKindOfClass:[NSNumber class]]){


                            [weakSelf.ContentValues addObject:dict1[@"data"][content]];
//
//                        }else{
//
//                        }

                        NSLog(@"%@---%@+++++%d",content ,dict1[@"data"][content],i);
                    }

                }
            }

            [weakSelf.collectionView reloadData];



        }else{
            [SVProgressHUD showErrorWithStatus:@"信息获取失败"];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];



}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)loadItemData{

    _personNumbers = [NSMutableArray array];
//    NSArray * title = ;
//    NSArray * content = @[@"14.7%",@"38.5kg",@"62.6%",@"3.1kg",@"0.0",@"1725.0kcal",@"24岁",@"170cm"];
    content_name = [NSMutableArray arrayWithArray:@[@"体脂率",@"肌肉量",@"水分含量",@"骨量",@"内脏脂肪",@"BMR(基础代谢)",@"身体年龄",@"体重"]];
    content_content = [NSMutableArray arrayWithArray:@[@"0%",@"0kg",@"0%",@"0kg",@"0.0",@"0.0kcal",@"0岁",@"0cm"]];

    _ContentValues = [NSMutableArray array];
    _contentDates = [NSMutableArray array];

}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

- (void)setupCollectionView{

    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    self.collectionView=collectionView;
    [self.view addSubview:collectionView];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.showsVerticalScrollIndicator=NO;
    collectionView.backgroundColor=[UIColor colorWithHexString:@"#eff4f4"];
    [_collectionView registerClass:[PersonHistoryViewCell class] forCellWithReuseIdentifier:kCollectionViewCell];

    [_collectionView registerClass:[PersonHistoryHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeadView];

}

-(void)dismissListView{
//    if (_isFamily == YES) {
        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }

}

- (void)loadHealthMessage:(UIButton *)sender{


    if (startString  == nil|| endString == nil || startString.length<=0 || endString.length<= 0) {
        startString = [self getSevenDaysMessage];
        endString = [self getCurrentDay];
    }

    
    PersonHistoryVC * history = [[PersonHistoryVC alloc] init];
    history.beginString = startString;
    history.endString = endString;
    history.userId = _userID;
    history.Persontitle = @"体脂明细";
//    if (_isFamily == YES) {
//        [self.navigationController pushViewController:history animated:YES];
//    }else{
    [self.navigationController pushViewController:history animated:YES];
//        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:history];
//        [self presentViewController:nav animated:YES completion:nil];
//    }



}
- (void)setNavigationView{

    UIView * navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    [navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(107);
    }];
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissListView) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets= UIEdgeInsetsMake(0, -15, 0, 0);
    [navigationView addSubview:btn];

    UILabel * tilte = [[UILabel alloc] init];
    tilte.font = [UIFont systemFontOfSize:19];
    tilte.textAlignment = NSTextAlignmentCenter;
    tilte.textColor = [UIColor colorWithHexString:@"#565c5c"];
    tilte.text = @"我的记录";
    [navigationView addSubview:tilte];

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(loadHealthMessage:) forControlEvents:UIControlEventTouchUpInside];

    NSTimeInterval oneDay = 24 * 60 * 60 * 1;
    NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.backgroundColor = RGBA(234, 235, 235, 1);
    [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _startBtn.layer.cornerRadius = 4;
    _startBtn.layer.masksToBounds = YES;
    [navigationView addSubview:_startBtn];

    UIView * centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor colorWithHexString:@"#565c5c"];
    [navigationView addSubview:centerView];






    _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _endBtn.backgroundColor = RGBA(234, 235, 235, 1);
//    [_endBtn setTitle:@"结束日期" forState:UIControlStateNormal];
    [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [_endBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    _endBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _endBtn.layer.cornerRadius = 4;
    _endBtn.layer.masksToBounds = YES;
    [navigationView addSubview:_endBtn];

    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(bianliPropetyInfo:) forControlEvents:UIControlEventTouchUpInside];

    [_startBtn addTarget:self action:@selector(showstartShadeView) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn addTarget:self action:@selector(showstartShadeView) forControlEvents:UIControlEventTouchUpInside];

    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView).offset(10);
        make.top.equalTo(navigationView).offset(30);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];

    [tilte mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navigationView);
        make.centerY.equalTo(btn);
        make.height.mas_equalTo(30);
        make.height.mas_equalTo(90);
    }];

    [rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navigationView).offset(6);
        make.centerY.height.width.equalTo(btn);
    }];

    [_startBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn);
        make.bottom.equalTo(navigationView).offset(-6);
    }];

    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_startBtn.mas_right).offset(3);
        make.right.equalTo(_endBtn.mas_left).offset(-3);
        make.centerY.equalTo(_startBtn);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];

    [_endBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(_startBtn);
        make.right.equalTo(okBtn.mas_left).offset(-12);
    }];

    [okBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_endBtn.mas_right).offset(10);
        make.centerY.equalTo(_startBtn);
        make.centerX.equalTo(rightBtn);

    }];


    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#c9cdcd"];
    [navigationView addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(navigationView);
        make.height.mas_equalTo(0.5);
    }];



}
- (void)showstartShadeView{
    XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
        NSLog(@"\n开始时间： %@，结束时间：%@",startDate,endDate);




        [_startBtn setTitle:[startDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

        [_endBtn setTitle:[endDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];


        if (!startDate) {
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            startDate = seven;
            [_startBtn setTitle:[startDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }


        if (!endDate) {
            endDate = [NSDate date];
            [_endBtn setTitle:[endDate stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }


        if ([self dateStartTime:startDate endTime:endDate] <0) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的时间区间"];
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            return ;
        }


        if ([self dateStartTime:startDate endTime:endDate] >30) {
            [SVProgressHUD showErrorWithStatus:@"请输入小于30天的日期"];
            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
            return;
        }


        if (!startDate) {
            [SVProgressHUD showInfoWithStatus:@"您可以同时选择开始时间"];

            NSTimeInterval oneDay = 24 * 60 * 60 * 1;
            NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];
            [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            return;
//             [_startBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        }

        if (!endDate) {
            [SVProgressHUD showInfoWithStatus:@"您可以同时选择结束时间"];


            [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

            return;
//            [_endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        }


        startString = [startDate stringWithFormat:@"yyyy-MM-dd"];
        endString = [endDate stringWithFormat:@"yyyy-MM-dd"];

    }];
    datepicker.datePickerStyle = DateStyleShowYearMonthDay;
    datepicker.dateType = DateTypeStartDate;
    datepicker.minLimitDate = [NSDate date:@"1990-1-1" WithFormat:@"yyyy-MM-dd"];
    datepicker.maxLimitDate = [NSDate date];
    [datepicker show];

}



#pragma mark UICollectionViewDataSource && UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_personNumbers count] > 0) {
         return [_personNumbers[0] count];
    }else{
        return [content_name count];
    }

    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonHistoryViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
//    cell.img_name = _itemArray[indexPath.item];
//    cell.fun_name = _itemArray[indexPath.item];
    if ( [_personNumbers count]>0 &&[_personNumbers[0] count] > 0) {
         cell.fun_content = _personNumbers[1][indexPath.item];
        cell.fun_name = _personNumbers[0][indexPath.item];
    }else{
        cell.fun_name = content_name[indexPath.item];
        cell.fun_content = content_content[indexPath.item];
    }

//    cell.fun_content = _itemArray[2][indexPath.item];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    [self.contentDates removeAllObjects];
    [self.ContentValues removeAllObjects];


    NSTimeInterval oneDay = 24 * 60 * 60 * 1;
    NSDate * seven = [[NSDate date] initWithTimeIntervalSinceNow:-(oneDay * 6)];

    [_startBtn setTitle:[seven stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];

    [_endBtn setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    if ( [_personNumbers count]>0 && [_personNumbers[0] count] > 0) {
        SBMing =  _personNumbers[0][indexPath.item];
        _head.name = SBMing;
    }


    [self loadProPertyInfo];


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return   CGSizeMake(168, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 12, 8, 12);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

// 定义headview的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 24, 188);
}

//// 定义section的边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//    return UIEdgeInsetsMake(8, 12, 8, 12);
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{


    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        _head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeadView forIndexPath:indexPath];

//        head.frame =    CGRectMake(12, 10, self.view.frame.size.width - 24, 162);
//        head.backGroundView.frame = CGRectMake(12, 10, self.view.frame.size.width - 24, 162);
//        head.backGroundView.frame = head.frame;
        _head.name = SBMing;


        if (_ContentValues.count >0 && _contentDates.count >0) {
            _head.values = _ContentValues;
            _head.dates = _contentDates;
            _head.content = _ContentValues[0];
            [_head refreshView];
        }

        return _head;
    }
    UICollectionReusableView * headView  = [collectionView dequeueReusableCellWithReuseIdentifier:@"kErrorCollectionReusableListView" forIndexPath:indexPath];
    return headView;
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
