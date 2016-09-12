//
//  IDCardValid.m
//  IDCardValid
//
//  Created by HYG_IOS on 16/9/9.
//  Copyright © 2016年 magic. All rights reserved.
//
/*
>验证身份证
>必须满足以下规则
>1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
>2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
>3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
>4. 第17位表示性别，双数表示女，单数表示男
>5. 第18位为前17位的校验位
>算法如下：
  （1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
  （2）余数 ＝ 校验和 % 11
  （3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“10X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
>6. 出生年份的前两位必须是19或20

 */

#import "IDCardValid.h"

@implementation IDCardValid
// 62122719820726493X
// 012345678901234567

// MARK: 实际开发如果有身份证图片上传后台审核则二次验证,如只提供身份证ID则可三次验证
+ (BOOL)validIDCardWithString:(NSString *)idStr
{
    // 1.一次校验
    BOOL firstValid;
    if (idStr.length <= 0) {
        firstValid = NO;
        return firstValid;
    }
    
    // 2.二次校验
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    BOOL secondValid = [predicate evaluateWithObject:idStr];
    if (!secondValid) {
        return NO;
    }
    
    // 3.三次校验
    // 3.1 前两位
    NSArray *firstTwoArr = @[@"11",@"12",@"13",@"14",@"15",@"21",@"22",@"23",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"41",@"42",@"43",@"44",@"45",@"46",@"50",@"51",@"52",@"53",@"54",@"61",@"62",@"63",@"64",@"65",@"71",@"81",@"82",@"91"];
    NSString * f_TwoStr = [idStr substringWithRange:NSMakeRange(0, 2)];
    BOOL thirdValid = [firstTwoArr containsObject: f_TwoStr];
    if (!thirdValid) {
        return NO;
    }
    
    // MARK: 日期验证还可以进一步优化
    // 3.2 (19901011)第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
    NSString * yearPrefix = [idStr substringWithRange:NSMakeRange(6, 2)];
    if ([yearPrefix isEqualToString:@"19"]|[yearPrefix isEqualToString:@"20"]) {
        
    }else
    {
        return NO;
    }
    NSString * month = [idStr substringWithRange:NSMakeRange(10, 2)];
    NSInteger monthNum = month.integerValue;
    if (monthNum<1 | monthNum > 12) {
        return NO;
    }
    
    NSString * day = [idStr substringWithRange:NSMakeRange(12, 2)];
    NSInteger dayNum = day.integerValue;
    if (dayNum<1 | dayNum > 31) {
        return NO;
    }
    
    // 3.3 校验位
    // > "10X98765432"
    NSString * checkStr = @"10X98765432";
    NSString * checkNum = [self getCheckNumWithIDStr:idStr andCheckStr:checkStr];
    NSString * checkNum_ID = [idStr substringWithRange:NSMakeRange(idStr.length - 1, 1)];
    if (![checkNum isEqualToString:checkNum_ID]) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)getCheckNumWithIDStr:(NSString *)idStr andCheckStr:(NSString *)checkStr
{
    NSInteger n1 = [idStr substringWithRange:NSMakeRange(0, 1)].integerValue;
    NSInteger n2 = [idStr substringWithRange:NSMakeRange(1, 1)].integerValue;
    NSInteger n3 = [idStr substringWithRange:NSMakeRange(2, 1)].integerValue;
    NSInteger n4 = [idStr substringWithRange:NSMakeRange(3, 1)].integerValue;
    NSInteger n5 = [idStr substringWithRange:NSMakeRange(4, 1)].integerValue;
    NSInteger n6 = [idStr substringWithRange:NSMakeRange(5, 1)].integerValue;
    NSInteger n7 = [idStr substringWithRange:NSMakeRange(6, 1)].integerValue;
    NSInteger n8 = [idStr substringWithRange:NSMakeRange(7, 1)].integerValue;
    NSInteger n9 = [idStr substringWithRange:NSMakeRange(8, 1)].integerValue;
    NSInteger n10 = [idStr substringWithRange:NSMakeRange(9, 1)].integerValue;
    NSInteger n11 = [idStr substringWithRange:NSMakeRange(10, 1)].integerValue;
    NSInteger n12 = [idStr substringWithRange:NSMakeRange(11, 1)].integerValue;
    NSInteger n13 = [idStr substringWithRange:NSMakeRange(12, 1)].integerValue;
    NSInteger n14 = [idStr substringWithRange:NSMakeRange(13, 1)].integerValue;
    NSInteger n15 = [idStr substringWithRange:NSMakeRange(14, 1)].integerValue;
    NSInteger n16 = [idStr substringWithRange:NSMakeRange(15, 1)].integerValue;
    NSInteger n17 = [idStr substringWithRange:NSMakeRange(16, 1)].integerValue;
    
    //  62122719820726493X
    NSInteger sum = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3;
    NSInteger yu = sum % 11;
    
    NSString * checkNum = [checkStr substringWithRange:NSMakeRange(yu, 1)];
    
    return checkNum;
}



@end
