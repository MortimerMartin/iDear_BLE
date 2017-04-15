//
//  UIImage+ZYImage.m
//  SuperWatch
//
//  Created by pro on 17/2/17.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "UIImage+ZYImage.h"

@implementation UIImage (ZYImage)

+ (UIImage *)imageWithZYIColor:(UIColor *)color
{
    NSParameterAssert(color != nil);

    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
