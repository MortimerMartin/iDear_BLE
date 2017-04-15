//
//  LaunchViewCenter.m
//  SuperWatch
//
//  Created by pro on 17/2/21.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "LaunchViewCenter.h"
#import "LaunchView.h"
#import "UserCenter.h"
@implementation LaunchViewCenter


+(instancetype)shareInstance{
    static LaunchViewCenter * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LaunchViewCenter alloc] init];
    });

    return instance;


}


+(void)showLunchView:(NSArray *)imgArray{
// 1.判断沙盒中是否存在广告图片，如果存在，直接显示
NSString *filePath = [[LaunchViewCenter shareInstance] getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];

    BOOL isExist = [[LaunchViewCenter shareInstance] isFileExistWithFilePath:filePath];
    if (isExist && [UserCenter shareUserCenter].isLogin == YES) {// 图片存在

        LaunchView *advertiseView = [[LaunchView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        filePath = @"01_启动页.jpg";
        advertiseView.filePath = filePath;
        [advertiseView show];

    }

    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [[LaunchViewCenter shareInstance] getAdvertisingImage:imgArray];

}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage:(NSArray *)imageArray
{
    //随机取一张
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];

    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;

    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
    }
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}


/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];

        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称

        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }

    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];

        return filePath;
    }

    return nil;
}


@end
