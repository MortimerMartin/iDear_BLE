//
//  ZYScalesViewController.h
//  SuperWatch
//
//  Created by pro on 17/3/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^reloadPersonInfo)(NSString * name,NSString * headimg);

typedef void(^reloadTableView)(void);
@interface ZYScalesViewController : BaseViewController

@property (nonatomic , copy) reloadPersonInfo reloadInfo;

/**
 *  reloadTableView
 */
//-(void)reloadTableView:(reloadTableView)reload;

@property (nonatomic , copy) reloadTableView  reloadTableview;

@end
