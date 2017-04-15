//
//  LaunchView.h
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const adImageName = @"adImageName";

@interface LaunchView : UIView


/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@end
