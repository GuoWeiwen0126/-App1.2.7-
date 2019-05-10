//
//  UploadPortraitManager.m
//  XiaoXiaQuestionBank
//
//  Created by GuoWeiwen on 2017/7/7.
//  Copyright © 2017年 GuoWeiwen. All rights reserved.
//

#import "UploadPortraitManager.h"
#import "Tools.h"
#import "AliyunOSSiOS.h"
#import "HttpRequest+Config.h"
#import "HttpRequest+User.h"

@implementation UploadPortraitManager

#pragma mark - 上传头像
+ (void)uploadPortraitWithImageData:(NSData *)imageData
{
    [XZCustomWaitingView showWaitingMaskView:@"上传头像" iconName:LoadingImage iconNumber:4];
    [HttpRequest MainConfigGetOssTokenWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            [self uploadALiOSSWithDataDic:dic[@"Data"] imageData:imageData];
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark ========= 上传头像到阿里 =========
+ (void)uploadALiOSSWithDataDic:(NSDictionary *)dataDic imageData:(NSData *)imageData
{
    OSSPutObjectRequest *put = [[OSSPutObjectRequest alloc] init];
    put.bucketName = dataDic[@"BucketName"];//BucketName
    put.objectKey = [NSString stringWithFormat:@"user_img/%@/ios/%@/%@.%@",[self GetTimestamp],[USER_DEFAULTS objectForKey:User_uid],[self get6BitString],[self imageTypeWithData:imageData]];//拼接规则：/user_img/yyyyMMdd/(android/ios/weixin)/{uid}
    put.uploadingData = imageData;
    
    //拼接组成新的 serverHost
    NSString *serverHost = dataDic[@"ServerHost"];
    NSString *serverHeader = [dataDic[@"ServerHost"] componentsSeparatedByString:@"."][0];
    NSString *newServerHeader = [serverHeader stringByAppendingFormat:@"-%@",dataDic[@"RegionId"]];
    NSString *newServerHost = @"";
    if ([serverHost containsString:serverHeader]) {
        newServerHost = [serverHost stringByReplacingOccurrencesOfString:serverHeader withString:newServerHeader];
    }
    
    NSString *endPoint = newServerHost;//RegionId+ServerHost
    OSSClientConfiguration *config = [[OSSClientConfiguration alloc] init];
    config.maxRetryCount = 2;
    config.timeoutIntervalForRequest = 15;
    config.timeoutIntervalForResource = 24 * 60 * 60;
    
    //签名(先向服务器获取签名，时限：3600s)
    id <OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:dataDic[@"AccessKeyId"]
                                                                                           secretKeyId:dataDic[@"AccessKeySecret"]
                                                                                         securityToken:dataDic[@"SecurityToken"]];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:config];
    OSSTask *putTask = [client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
         if (!task.error)
         {
             NSLog(@"---上传阿里成功---");
             NSString *portraitURL = [NSString stringWithFormat:@"%@/%@",dataDic[@"ImgHost"],put.objectKey];//ImgHost
             [self changePortraitWithUid:[USER_DEFAULTS objectForKey:User_uid] newPortrait:portraitURL];
         }
         else
         {
             NSLog(@"---上传阿里失败---%@",task.error);
             [XZCustomWaitingView hideWaitingMaskView];
             [XZCustomWaitingView showAutoHidePromptView:@"上传失败" background:nil showTime:1.0];
         }
         return nil;
     }];
}

#pragma mark ========= 修改头像 =========
+ (void)changePortraitWithUid:(NSString *)uid newPortrait:(NSString *)newPortrait
{
    [HttpRequest UserPostUpdatePortraitUid:uid portrait:newPortrait completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView showAutoHidePromptView:@"修改头像成功" background:nil showTime:1.0];
            USER_DEFAULTS_SETOBJECT_FORKEY(newPortrait, User_portrait)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserPortrait" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHeaderCellUpdate" object:nil];
        }
        else
        {
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
/** put.objectKey参数重命名 **/
+ (NSString *)GetTimestamp
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
    
    return dateStr;
}
/** 生成6位随机数 **/
+ (NSString *)get6BitString
{
    char data[6];
    for (int x = 0; x < 6; x ++)
    {
        int randomNum = arc4random_uniform(2);
        if (randomNum == 0)
        {
            data[x] = (char)('a'+(arc4random_uniform(26)));
        }
        else
        {
            data[x] = (char)('0'+(arc4random_uniform(10)));
        }
    }
    
    return [[NSString alloc] initWithBytes:data length:6 encoding:NSUTF8StringEncoding];
}
/** 根据图片二进制流获取图片格式 **/
+ (NSString *)imageTypeWithData:(NSData *)data
{
    uint8_t type;
    [data getBytes:&type length:1];
    switch (type) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}


@end
