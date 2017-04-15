//
//  ZYScalesDropCell.h
//  SuperWatch
//
//  Created by Mortimer on 17/3/16.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "FFDropDownMenuBasedCell.h"

@interface ZYScalesDropCell : FFDropDownMenuBasedCell
@property (nonatomic , copy) NSString * drop_title;
@property (nonatomic , copy) NSString * drop_source;
@property (nonatomic , assign) BOOL onlyYOU;
@property (nonatomic , assign) BOOL applyF;

@end
