//
//  UINavigationController+ShowNotification.m
//  WeiBoTest
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 H-Y-L. All rights reserved.
//

#import "UINavigationController+ShowNotification.h"
#import "UIColor+HexString.h"

@implementation UINavigationController (ShowNotification)

-(void)showNotificationWithString:(NSString *)string {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,20, [[UIScreen mainScreen]bounds].size.width, 35)];
    label.text = string;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithHexString:@"#0fc2af"];
    [self.view insertSubview:label belowSubview:self.navigationBar];
    
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = CGRectOffset(label.frame, 0, 44);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.f options:0 animations:^{
            label.frame = CGRectOffset(label.frame, 0, -35);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}



@end
