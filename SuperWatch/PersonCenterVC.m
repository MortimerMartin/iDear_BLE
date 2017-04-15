//
//  PersonCenterVC.m
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "PersonCenterVC.h"
#import "UIColor+HexString.h"
#import "PersonInfoCell.h"
#import "PersonLastVC.h"
#import "UserCenter.h"
#define kPersonInfoCell @"PersonInfoCell"
#import "GTMBase64.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DataManager.h"

#import "cameraHelper.h"
@interface PersonCenterVC ()<UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate , UINavigationControllerDelegate>

@property(nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) NSArray * infoArr;
@property (nonatomic , strong) NSArray * infoR;

@end

@implementation PersonCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    [self setNavigationView];

    [self setupTableView];
    // Do any additional setup after loading the view.
}


- (void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
     [_tableView registerClass:[PersonInfoCell class] forCellReuseIdentifier:kPersonInfoCell];
    // 4.设置我们分割线颜色(clearColor相当于取消系统分割线)
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#eff4f4"];
    // 5.设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoArr = @[@"我的头像",@"我的昵称",@"我的性别",@"我的年龄",@"我的身高"];//,@"我的步幅"


}





- (void)reloadPersonData{
    int age = [[UserCenter shareUserCenter].age intValue];
    if (age == 0) {
        age = 1;
    }

    _infoR = @[[UserCenter shareUserCenter].name ? [UserCenter shareUserCenter].name : @"iDear",[UserCenter shareUserCenter].sex ? [UserCenter shareUserCenter].sex : @"无",[NSString stringWithFormat:@"%d岁",age ? age : 0],[NSString stringWithFormat:@"%@cm",[UserCenter shareUserCenter].height ? [UserCenter shareUserCenter].height : @"0"]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self reloadPersonData];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PersonInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:kPersonInfoCell];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPersonInfoCell forIndexPath:indexPath];
    }
    cell.info_name = _infoArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.info_img = [UserCenter shareUserCenter].source ? [UserCenter shareUserCenter].source : @"icon";
        ;
    }else{
        cell.info = _infoR[indexPath.row - 1];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;




}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 72.0f;
    }

    return 52.0f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {

        UIAlertController * controller =[UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];

        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //拍照
            if (![cameraHelper checkCameraAuthorizationStatus]) {
                return;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];

        }];

        UIAlertAction * library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            //相册
            if (![cameraHelper checkPhotoLibraryAuthorizationStatus]) {
                return;
            }

            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:imagePicker animated:YES completion:nil];

        }];

        [controller addAction:cancel];
        [controller addAction:camera];
        [controller addAction:library];
        [cancel setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
        [camera setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];
        [library setValue:[UIColor colorWithHexString:@"#0fc2af"] forKey:@"_titleTextColor"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:controller animated:YES completion:nil];
        });

    }else{
        PersonLastVC * lastVc = [[PersonLastVC alloc] init];
        lastVc.VCtitle = _infoArr[indexPath.row];
        lastVc.VCinfo = _infoR[indexPath.row - 1];
        [self.navigationController pushViewController:lastVc animated:YES];
    }

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{


   __block UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];

    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    NSData *imageData = UIImageJPEGRepresentation(image,0.5);

    NSData *data = [GTMBase64 encodeData:imageData];

    NSString *imgStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];




    NSDictionary * dict = @{
                            @"userId":@([[UserCenter shareUserCenter].userId integerValue]) ,
                            @"fileStr":imgStr
                            };

    __weak __typeof(self) weakSelf = self;
    [[DataManager manager] postDataWithUrl:@"doUploadImage" parameters:dict success:^(id json) {
        NSDictionary * dict1 = json;
        if ([dict1[@"status"] intValue] == 1) {
            NSString * str = dict1[@"message"];
            NSLog(@"touxiang%@",str);
            [UserCenter shareUserCenter].source = str;
            [[NSUserDefaults standardUserDefaults] setValue:[UserCenter shareUserCenter].source forKey:@"UserSource"];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
    }];


      [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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


    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPersonCenter:)];
    [view addGestureRecognizer:tap];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#565c5c"],NSFontAttributeName:[UIFont systemFontOfSize:19.0]};

    self.title = @"我的信息";

}


- (void)dismissPersonCenter:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
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
