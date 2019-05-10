//
//  NSString+Range.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "NSString+Range.h"

@implementation NSString (Range)

- (NSArray *)queryNameWithQIssueStr:(NSString *)qIssueStr fromStr:(NSString *)fromStr toStr:(NSString *)toStr
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *resultArray = [NSMutableArray array];
    return [self queryStringQIssueStr:qIssueStr from:fromStr to:toStr array:array resultArray:resultArray];
}

- (NSArray *)queryStringQIssueStr:(NSString *)qIssueStr from:(NSString *)from to:(NSString *)to array:(NSMutableArray *)array resultArray:(NSMutableArray *)resultArray
{
    // 获取开始#所在的位置
    NSRange fromRange = [self rangeOfString:from];
    
    if (fromRange.location != NSNotFound) {
        // 获取开始索引
        NSUInteger fromIndex = fromRange.location + fromRange.length;
        // 从索引开始截取字符串
        NSString *fromStr = [self substringFromIndex:fromIndex];
        
        
        // 获取与#所对应的#的位置
        NSRange toRange = [fromStr rangeOfString:to];
        
        // 判断所对应的#是否存在
        if (toRange.location != NSNotFound) {
            // 得到##之间的标题
            NSString *str = [fromStr substringToIndex:toRange.location];
            // 得到完整的标题字符串，如#大学是所整容院#
            NSString *string = [NSString stringWithFormat:@"%@%@%@", from, str, to];
//            NSLog(@"string:%@", string);
            
            // 得到完成的标题字符串在字符串中的位置
            NSRange range = [self rangeOfString:string];
            
            // 先判断上一个是否存在
            NSValue *value = [array lastObject];
            if (value.rangeValue.length) {
                // 当前话题的range中的位置添加上上一个话题的range的位置和长度
                NSUInteger location = value.rangeValue.length + value.rangeValue.location;
                range = NSMakeRange(range.location + location, range.length);
            }
            
            // 把range转化为NSValue存放在数组中
            [array addObject:[NSValue valueWithRange:range]];
            [resultArray addObject:[qIssueStr substringWithRange:range]];
            
            // 获取标题##后面的内容
            NSString *nextStr = [fromStr substringFromIndex:toRange.location + toRange.length];
            
            // 递归继续查询
            [nextStr queryStringQIssueStr:qIssueStr from:from to:to array:array resultArray:resultArray];
        }
    }
    
    return resultArray;
}

@end
