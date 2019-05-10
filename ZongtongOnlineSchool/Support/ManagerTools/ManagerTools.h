//
//  ManagerTools.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/17.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ManagerTools : NSObject

#pragma mark - 获取试用账号uid
+ (NSString *)getTryAccountUidWithKey:(BOOL)key;

#pragma mark - MD5加密
+ (NSString *)MD5WithStr:(NSString *)str;

#pragma mark - 检查手机号码是否正确
+ (BOOL)checkTelNumber:(NSString *)telNumber;

#pragma mark - 视频URL空格替换（%20）
+ (NSString *)videoUrlChangeBlankWtihUrl:(NSString *)url;


#pragma mark - label高度自适应
+ (CGFloat)adaptHeightWithString:(NSString *)str FontSize:(CGFloat)fontSize SizeWidth:(CGFloat)width;
#pragma mark - label宽度自适应
+ (CGFloat)adaptWidthWithString:(NSString *)str FontSize:(CGFloat)fontSize SizeHeight:(CGFloat)height;
#pragma mark - label宽高自适应
+ (CGRect)adaptWidthAndHeightWithString:(NSString *)str Font:(UIFont *)font SizeWidth:(CGFloat)width;

#pragma mark 富文本方法
+ (NSMutableAttributedString *)getMutableAttributedStringWithContent:(NSString *)content rangeStr:(NSString* )rangeStr color:(UIColor *)color font:(CGFloat)font;

#pragma mark - 获取本地Json文件
+ (id)getLocalJsonWithResource:(NSString *)resource type:(NSString *)type;

#pragma mark - 存储本地Plist文件
+ (void)saveLocalPlistFileWtihFile:(id)file fileName:(NSString *)fileName;

#pragma mark - 检查本地是否存在plist文件
+ (BOOL)existLocalPlistWithFileName:(NSString *)fileName;

#pragma mark - NSDecimal 加法计算
+ (NSString *)addNumberMutiplyWithString:(NSString *)multiplierValue secondString:(NSString *)multiplicAndValue;

#pragma mark - 过滤空格、换行符
+ (NSString *)deleteSpaceAndNewLineWithString:(NSString *)string;

#pragma mark - 数组、字典转Json
+ (NSString *)dictionaryToJsonWithDic:(NSDictionary *)dic;

#pragma mark - Json转字典
+ (NSDictionary *)jsonToDictionaryWithJsonStr:(NSString *)jsonStr;

#pragma mark - 获取文件路径
+ (NSString *)getFilePathWithFileName:(NSString *)fileName;

#pragma mark - 存储高频数据、教材强化、冲刺密卷本地权限判断
+ (BOOL)sectionIsVerificationWithEiid:(NSString *)eiid courseid:(NSString *)courseid type:(NSString *)type;

#pragma mark - 直播时间戳判断
+ (NSInteger)timestampJudgeWithStarttime:(NSString *)startTime endTime:(NSString *)endtime;

#pragma mark - 视频清晰度组合
+ (NSDictionary *)videoSourceDicWithSourceList:(NSArray *)sourceList;

#pragma mark - 广告视图Place参数
+ (NSString *)getAdverViewPlaceWithType:(NSInteger)type;


@end
