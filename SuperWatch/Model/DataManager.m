//
//  DataManager.m
//  SuperWatch
//
//  Created by pro on 17/2/22.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
//#define kURL_head @"http://192.168.0.111:8088/EHome/services/api/mobileManager/"
#define kURL_head @"http://image.degjsm.cn/EHome/services/api/mobileManager/"
static DataManager *manager = nil;
static AFHTTPSessionManager *AFNManager = nil;

@implementation DataManager

/**
 *  创建单例
 *
 *  @return <#return value description#>
 */
+ (DataManager *)manager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
        AFNManager = [AFHTTPSessionManager manager];
//        afnManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFNManager.requestSerializer = [AFJSONRequestSerializer serializer];
        AFNManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });

    return manager;
}

//GET请求
- (void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters success:(Success)success failure:(Failure)failure {

//    AFNManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [AFNManager GET:url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(responseObject);
        }else {
            [SVProgressHUD showWithStatus:@"暂无数据"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {

            failure(error);
        }
    }];

}

//POST请求
- (void)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters success:(Success)success failure:(Failure)failure {

    NSString * URL = [NSString stringWithFormat:@"%@%@",kURL_head,url];
    [AFNManager POST:URL parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
//             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(responseObject);
        }else {
               [SVProgressHUD showErrorWithStatus:@"暂无更多数据"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {

            failure(error);
        }
    }];
}

// 上传
+ (void)uploadPost:(NSString *)urlString parameters:(id)parameters UploadImage:(NSMutableArray *)imageArray success:(void (^)(id))successs failure:(void (^)(NSError *))failure{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 60.f;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [AFNManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in imageArray) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:data name:@"uploadimage" fileName:fileName mimeType:@"image/png"];
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (responseObject) {
            successs(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (error) {
            failure(error);
        }
    }];
  
}

// 网络监测
+ (void)ReachabilityStatus:(void (^)(id))netStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {

            case AFNetworkReachabilityStatusUnknown:

                if (netStatus) {
                    netStatus(@"未知网络类型");
                }
                break;

            case AFNetworkReachabilityStatusNotReachable:

                if (netStatus) {
                    netStatus(@"无可用网络");
                }
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:

                if (netStatus) {
                    netStatus(@"当前WIFE下");
                }
                break;

            case AFNetworkReachabilityStatusReachableViaWWAN:

                if (netStatus) {
                    netStatus(@"使用蜂窝流量");
                }
                break;

            default:

                break;

        }

    }];
    [manager startMonitoring];
}


@end
