//
//  DataManager.h
//  SuperWatch
//
//  Created by pro on 17/2/22.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

//block回调传值
/**
 *   请求成功回调json数据
 *
 *  @param json json串
 */
typedef void(^Success)(id json);
/**
 *  请求失败回调错误信息
 *
 *  @param error error错误信息
 */
typedef void(^Failure)(NSError *error);

@interface DataManager : NSObject

//单例模式
+ (DataManager *)manager;

/**
 *  GET请求
 *
 *  @param url       NSString 请求url
 *  @param paramters NSDictionary 参数
 *  @param success   void(^Success)(id json)回调
 *  @param failure   void(^Failure)(NSError *error)回调
 */
- (void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters success:(Success)success failure:(Failure)failure;

/**
 *  POST请求
 *
 *  @param url       NSString 请求url
 *  @param paramters NSDictionary 参数
 *  @param success   void(^Success)(id json)回调
 *  @param failure   void(^Failure)(NSError *error)回调
 */
- (void)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters success:(Success)success failure:(Failure)failure;

/**
 单张或多张图片上传

 @param urlString  URL
 @param parameters 参数
 @param imageArray 图片数组（这里是UIImage  可以根据项目自行修改）
 @param successs   成功回调
 @param failure    失败回调
 */
+ (void)uploadPost:(NSString *)urlString parameters:(id)parameters UploadImage:(NSMutableArray *)imageArray success:(void (^)(id))successs failure:(void (^)(NSError *))failure;

/**
 实时监测网络变化

 @param netStatus 当前网络状态
 */
+ (void)ReachabilityStatus:(void (^)(id))netStatus;
@end
