 //
//  DeviceListView.m
//  SuperWatch
//
//  Created by pro on 17/2/13.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "DeviceListView.h"
#import "UIColor+HexString.h"
#import "UIView+CLExtension.h"
#import "deviceCell.h"

#define kdeviceCell @"deviceCellIdentifier"
@interface DeviceListView ()<UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray * list_status;
}

@property (nonatomic , strong) UIView * navigationView;

@property (nonatomic , strong) UILabel * navigationTitle;

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * deviceArray;

@end
@implementation DeviceListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {


        [self setupNavigation];

        [self setupTableView];
    }
    return self;
}

- (void)reloadDeviceListView:(NSMutableArray *)list WithPeripheral:(NSMutableArray *)status{
    _deviceArray = list;
    list_status = status;
    [_tableView reloadData];
}
- (void)setupNavigation{

    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cl_width, 64)];
    _navigationView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationView];

    _navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.navigationView.cl_width/2-40, self.navigationView.cl_height/2 - 10, 80, 30)];
    _navigationTitle.textColor = [UIColor colorWithHexString:@"#565c5c"];
    _navigationTitle.text = @"选择设备";
    [_navigationView addSubview:_navigationTitle];

    UIView * navigationL = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.cl_width, 0.5)];
    navigationL.backgroundColor =[UIColor colorWithHexString:@"#737f7f"];
    [_navigationView addSubview:navigationL];


}

- (void)setupTableView{

    _deviceArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc ] initWithFrame:CGRectMake(0, 64, self.cl_width, self.cl_height - 64)];
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
//    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.dataSource = self;
    [_tableView registerClass:[deviceCell class] forCellReuseIdentifier:kdeviceCell];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];

}


#pragma mark UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _deviceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    deviceCell * cell = [tableView dequeueReusableCellWithIdentifier:kdeviceCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kdeviceCell forIndexPath:indexPath];
    }
    //3.18
    NSString * str = ((CBPeripheral *)[_deviceArray objectAtIndex:indexPath.section]).name;
    if (str.length == 0 || str == nil) {
        str = @"LOVE LIFE - style";
    }
    NSDictionary * dict = [list_status objectAtIndex:indexPath.section];
    if ([dict[@"IsConnect"] boolValue] == NO) {
        cell.device_name = [str stringByAppendingString:[dict[@"RSSI"] stringValue]];
    }else{
        cell.device_name = [str stringByAppendingString:[dict[@"ConnectBySystem"] stringValue]];
    }

 NSString * lastConnectTime =  [[NSUserDefaults standardUserDefaults] valueForKey:@"LastConnect"];
    if (lastConnectTime && lastConnectTime.length >0) {
        
    }else{

    }
//    cell.device_time = @"20133333333";
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRow:)]) {
        [self.delegate didSelectRow:indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cl_width, 12)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
