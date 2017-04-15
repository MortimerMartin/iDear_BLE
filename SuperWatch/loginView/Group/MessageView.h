//
//  MessageView.h
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isLoginBlock)(NSInteger indexNUM);

@interface MessageView : UIView



@property (nonatomic , copy) isLoginBlock isLogin;

@end
