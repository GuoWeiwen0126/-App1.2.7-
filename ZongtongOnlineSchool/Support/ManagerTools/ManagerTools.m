//
//  ManagerTools.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/17.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "ManagerTools.h"
#import "Tools.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation ManagerTools

#pragma mark - 获取试用账号uid
+ (NSString *)getTryAccountUidWithKey:(BOOL)key
{
    /*
     * key: YES有权限，NO没权限
     * random: 偶数有权限，奇数没权限
     */
    NSInteger random = arc4random()%899 + 100;
    if (key == YES) {
        if (random%2 != 0) {
            random = random + 1;
        }
    } else {
        if (random%2 == 0) {
            random = random + 1;
        }
    }
    NSMutableArray *randomArray = [NSMutableArray arrayWithCapacity:10];
    NSString *randomStr = [NSString stringWithFormat:@"%ld",(long)random];
    for (int i = 0; i < randomStr.length; i ++) {
        [randomArray addObject:[randomStr substringWithRange:NSMakeRange(i, 1)]];
    }
    NSInteger i = arc4random()%5 + 1;
    NSString *result = @"-";
    switch (i) {
        case 1:  //1*2*31
        {
            result = [result stringByAppendingString:randomArray[0]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:randomArray[1]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:randomArray[2]];
            result = [result stringByAppendingString:@"1"];
        }
            break;
        case 2:  //1*23*2
        {
            result = [result stringByAppendingString:randomArray[0]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:randomArray[1]];
            result = [result stringByAppendingString:randomArray[2]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:@"2"];
        }
            break;
        case 3:  //*123*3
        {
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:randomArray[0]];
            result = [result stringByAppendingString:randomArray[1]];
            result = [result stringByAppendingString:randomArray[2]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:@"3"];
        }
            break;
        case 4:  //1*23*4
        {
            result = [result stringByAppendingString:randomArray[0]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:randomArray[1]];
            result = [result stringByAppendingString:randomArray[2]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:@"4"];
        }
            break;
        case 5:  //12*3*5
        {
            result = [result stringByAppendingString:randomArray[0]];
            result = [result stringByAppendingString:randomArray[1]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:randomArray[2]];
            result = [result stringByAppendingFormat:@"%d",arc4random()%10];
            result = [result stringByAppendingString:@"5"];
        }
            break;
            
        default:
            break;
    }
    NSLog(@"随机数：***%@***  测试账号Uid：***%@***",randomStr,result);
    return result;
}

#pragma mark - MD5加密
+ (NSString *)MD5WithStr:(NSString *)str
{
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *data = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(data, (CC_LONG)strlen(data), result);
    /*
     第一个参数: 要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *resultStr = [NSMutableString string];
    
    //5.从 result 数组中获取加密结果并放到 resultStr 中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++)
    {
        [resultStr appendFormat:@"%02x",result[i]];
        /*
         x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
         NSLog("%02X", 0x888);  //888
         NSLog("%02X", 0x4); //04
         */
    }
    
    return resultStr;
}

#pragma mark - 检查手机号码是否正确
+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    //是否全为数字
    NSString *temStr = [telNumber stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(temStr.length > 0) {
        return NO;
    }
    //是否以@"1"开头
    if (![telNumber hasPrefix:@"1"]) {
        return NO;
    }
    //是否为11位
    if (telNumber.length != 11) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 视频URL空格替换（%20）
+ (NSString *)videoUrlChangeBlankWtihUrl:(NSString *)url
{
    return [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

#pragma mark - label高度自适应
+ (CGFloat)adaptHeightWithString:(NSString *)str FontSize:(CGFloat)fontSize SizeWidth:(CGFloat)width
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height;
}
#pragma mark - label宽度自适应
+ (CGFloat)adaptWidthWithString:(NSString *)str FontSize:(CGFloat)fontSize SizeHeight:(CGFloat)height
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.width;
}
#pragma mark - label宽高自适应
+ (CGRect)adaptWidthAndHeightWithString:(NSString *)str Font:(UIFont *)font SizeWidth:(CGFloat)width
{
    return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
}

#pragma mark 富文本方法
+ (NSMutableAttributedString *)getMutableAttributedStringWithContent:(NSString *)content rangeStr:(NSString* )rangeStr color:(UIColor *)color font:(CGFloat)font
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont systemFontOfSize:font]} range:[content rangeOfString:rangeStr]];
    
    return attributeStr;
}

#pragma mark - 本地Json文件读取
+ (id)getLocalJsonWithResource:(NSString *)resource type:(NSString *)type
{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

#pragma mark - 存储本地Plist文件
+ (void)saveLocalPlistFileWtihFile:(id)file fileName:(NSString *)fileName
{
    NSFileManager *fileManager = FileDefaultManager;
    NSString *filePath = GetFileFullPath(fileName);
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    if ([file writeToFile:filePath atomically:YES])
    {
//        [XZCustomWaitingView showAutoHidePromptView:@"存储成功" background:nil showTime:0.8f];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"存储失败" background:nil showTime:0.8f];
    }
}

#pragma mark - 检查本地是否存在plist文件
+ (BOOL)existLocalPlistWithFileName:(NSString *)fileName
{
    NSFileManager *fileManager = FileDefaultManager;
    NSString *filePath = GetFileFullPath(fileName);
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - NSDecimal 加法计算
+ (NSString *)addNumberMutiplyWithString:(NSString *)multiplierValue secondString:(NSString *)multiplicAndValue
{
    NSLog(@"+++%@+++     +++%@+++",multiplierValue,multiplicAndValue);
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicAndNumber = [NSDecimalNumber decimalNumberWithString:multiplicAndValue];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByAdding:multiplicAndNumber];
    return [product stringValue];
}

#pragma mark - 过滤空格、换行符
+ (NSString *)deleteSpaceAndNewLineWithString:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除掉首尾的空白字符和换行字符
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return string;
}

#pragma mark - 数组、字典转Json
+ (NSString *)dictionaryToJsonWithDic:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - Json转数组、字典
+ (NSDictionary *)jsonToDictionaryWithJsonStr:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

#pragma mark - 获取文件路径
+ (NSString *)getFilePathWithFileName:(NSString *)fileName
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

#pragma mark - 存储高频数据、教材强化、冲刺密卷本地权限判断
+ (BOOL)sectionIsVerificationWithEiid:(NSString *)eiid courseid:(NSString *)courseid type:(NSString *)type
{
    if (![self existLocalPlistWithFileName:LocalDataPlist]) {
        return NO;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getFilePathWithFileName:LocalDataPlist]];
    NSArray *keyArray = [dic allKeys];
    for (NSString *key in keyArray)
    {
        if ([[NSString stringWithFormat:@"%@-%@-%@",eiid,courseid,type] isEqualToString:key])
        {
            NSMutableDictionary *temDic = dic[key];
            //对比时间戳
            NSString *currentTimeString = [[[NSDateFormatter alloc] init] stringFromDate:[NSDate date]];
            if (([currentTimeString longLongValue] - [temDic[@"time"] longLongValue]) > 864000) {
                return NO;
            } else {
                if ([temDic[@"Group"] boolValue] && [temDic[@"Zone"] boolValue]) {
                    return YES;
                } else {
                    return NO;
                }
            }
            break;
        }
    }
    return NO;
}

#pragma mark - 直播时间戳判断
+ (NSInteger)timestampJudgeWithStarttime:(NSString *)startTime endTime:(NSString *)endtime
{
    NSDate *nowDate = [NSDate date];
    NSDate *startDate = [self getDateWithString:startTime];
    NSDate *endDate = [self getDateWithString:endtime];
    NSTimeInterval start = [startDate timeIntervalSince1970] * 1;
    NSTimeInterval now = [nowDate timeIntervalSince1970] * 1;
    NSTimeInterval cha = start - now;
    if ([nowDate compare:startDate] == NSOrderedAscending) {  //未开始 (用户可以提前5分钟进入)
        if (cha/60 < 5.0) {
            return -1;
        }
        return 0;
    }
    else if ([nowDate compare:startDate] == NSOrderedDescending && [nowDate compare:endDate] == NSOrderedAscending) {  //直播中
        return 1;
    } else {  //直播结束
        return 2;
    }
}
+ (NSDate *)getDateWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:string];
}

#pragma mark - 视频清晰度组合
+ (NSDictionary *)videoSourceDicWithSourceList:(NSArray *)sourceList
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in sourceList) {
        [resultDic setObject:[self videoUrlChangeBlankWtihUrl:dic[@"vUrl"]] forKey:[self getVideoDefinitionWithSourceType:dic[@"sourceType"]]];
    }
    return resultDic;
}
+ (NSString *)getVideoDefinitionWithSourceType:(NSString *)sourceType
{
    /*
     * "OD":"原画", "FD":"流畅", "LD":"标清", "SD":"高清", "HD":"超清", "2K":"2K", "4K":"4K"
     */
    if ([sourceType isEqualToString:@"OD"]) {
        return @"原画";
    } else if ([sourceType isEqualToString:@"FD"]) {
        return @"流畅";
    } else if ([sourceType isEqualToString:@"LD"]) {
        return @"标清";
    } else if ([sourceType isEqualToString:@"SD"]) {
        return @"高清";
    } else if ([sourceType isEqualToString:@"HD"]) {
        return @"超清";
    } else if ([sourceType isEqualToString:@"2K"]) {
        return @"2K";
    } else {
        return @"4K";
    }
}

#pragma mark - 广告视图Place参数
+ (NSString *)getAdverViewPlaceWithType:(NSInteger)type
{
    if (type == 0) {  //敬请期待
        return @"0";
    } else if (type == 1) {  //智能练习
        return @"0";
    } else if (type == 2) {  //章节练习
        return @"0";
    } else if (type == 3) {  //真题模考
        return @"0";
    } else if (type == 4) {  //巩固模考
        return @"0";
    } else if (type == 5) {  //高频数据
        return @"0";
    } else if (type == 6) {  //教材强化
        return @"8";
    } else if (type == 7) {  //模考大赛
        return @"0";
    } else if (type == 8) {  //错题
        return @"0";
    } else if (type == 9) {  //收藏
        return @"0";
    } else if (type == 10) {  //练习历史
        return @"0";
    } else if (type == 11) {  //资料下载
        return @"0";
    } else if (type == 12) {  //视频解析
        return @"0";
    } else if (type == 13) {  //历年真题
        return @"9";
    } else if (type == 14) {  //冲刺密卷
        return @"7";
    } else if (type == 15) {  //直播
        return @"0";
    } else if (type == 16) {  //旧题库
        return @"0";
    } else {
        return @"0";
    }
}


@end
