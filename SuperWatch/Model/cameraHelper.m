//
//  cameraHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "cameraHelper.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/Photos.h>
#import "SVProgressHUD.h"
@import AVFoundation;

@implementation cameraHelper

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    //if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (ALAuthorizationStatusDenied == authStatus ||
                ALAuthorizationStatusRestricted == authStatus) {
                [SVProgressHUD showErrorWithStatus:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
                return NO;
        //    }
            }
        return YES;
    }

    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {

        return NO;
    }

    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
         [SVProgressHUD showErrorWithStatus:@"该设备不支持拍照"];

        return NO;
    }

    
    //ios7之前系统默认拥有权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {

        if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (AVAuthorizationStatusDenied == authStatus ||
                AVAuthorizationStatusRestricted == authStatus) {
                [SVProgressHUD showErrorWithStatus:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];

                return NO;
            }
           
        }

    }

    return YES;
}

@end
