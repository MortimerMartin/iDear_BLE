//
//  getSeven.m
//  SuperWatch
//
//  Created by pro on 17/2/14.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "getSeven.h"
#import "UserCenter.h"
@implementation getSeven

//+(NSString *)getSeven:(NSString *)seven{
//
//
//    return seven;
//}


+ (NSString * )getSeven{
    NSString * sex = [UserCenter shareUserCenter].sex;
    NSLog
    (@"%@",sex);

    int sexNum = 0;
    
    if ([sex isEqualToString:@"男"]) {
        sexNum = 1;
    }else{
        sexNum = 0;
    }

    int height = [[UserCenter shareUserCenter].height intValue];
    int age = [[UserCenter shareUserCenter].age intValue];
    NSLog(@"%d",age);
    NSArray * arr = @[@254,@0,@(sexNum),@0,@(height),@(age),@1];
    int16_t c = [arr[1] intValue];
    for (int i = 2; i < 7; i++) {
        c^=[arr[i] intValue];
    }
    NSLog(@"%x",c);


//    int  a[7] = {0xFE,0x03,0x01,0x00,0xAA,0x18,0x01};
//
////    int a[8] = {0xFE,0x03,0x01,0x00,0xAA,0x19,0x01,0x00};
//    int b = a[1];
//    for (int i =2; i < 7; i++) {
//        b ^=a[i];
//    }
//
//    NSLog(@"%x",b);
    NSString * str1 = [NSString stringWithFormat:@"%x",c];
    NSString * left = [str1 substringToIndex:1];
    NSLog(@"top___%@",left);
    NSString * right = [str1 substringFromIndex:1];
    NSLog(@"right___%@",right);

    if ([left isEqualToString:@"a"]) {
            left = @"A";
    }
    if ( [right isEqualToString:@"a"]){
        right = @"A";
    }
    if ( [right isEqualToString:@"b"]){
        right = @"B";
    }
    if ([left isEqualToString:@"b"]){
        left = @"B";
    }
    if ([left isEqualToString:@"c"]){
        left = @"C";
    }
    if ([right isEqualToString:@"c"]){
        right = @"C";
    }
    if ([left isEqualToString:@"d"]){
        left = @"D";
    }
    if ([right isEqualToString:@"d"]){
        right = @"D";
    }
    if ([left isEqualToString:@"e"]){
        left = @"E";
    }
    if ([right isEqualToString:@"e"]){
        right = @"E";
    }
    if ([left isEqualToString:@"f"]){
        left = @"F";
    }
    if ([right isEqualToString:@"f"]){
        right = @"F";
    }

    NSString * str = [NSString stringWithFormat:@"%@%@",left,right];
    NSString * height1 = [getSeven ToHex:height];
    NSString * age1 = [getSeven ToHex:age];
    NSString * sex1 = [NSString stringWithFormat:@"0%d",sexNum];
    NSString *  personInfo = [NSString stringWithFormat:@"FE00%@00%@%@01%@",sex1,height1,age1,str];
    NSLog(@"%@",personInfo);
    return personInfo;
}


//十进制转十六进制
+ (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}
@end
