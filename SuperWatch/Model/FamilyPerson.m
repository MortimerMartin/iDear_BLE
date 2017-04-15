//
//  FamilyPerson.m
//  SuperWatch
//
//  Created by pro on 17/2/23.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "FamilyPerson.h"

@implementation FamilyPerson

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        NSLog(@"%@",key);
        self.userId = value;
    }
}
@end
