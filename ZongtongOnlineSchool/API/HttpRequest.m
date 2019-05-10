//
//  HttpRequest.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/15.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

#pragma mark - 发送网络请求
+ (void)requestWithURLString:(NSString *)URLString
                  Parameters:(id)parameters
                 RequestType:(HttpRequestType)requestType
                   Completed:(ZTFinishBlockRequest)complete
{
    //---appkey
    NSString *appKeyStr    = @"IOS_wluS1Nv4GWR36mVh6";
    //---timestamp
    NSString *timestampStr = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] componentsSeparatedByString:@"."].firstObject;
    //---nonce
    NSString *nonceStr     = [NSString stringWithFormat:@"%u",1000 + arc4random()%9000];
    //---examid
    NSString *examidStr    = [USER_DEFAULTS objectForKey:EIID];
    //---AppValue
    NSString *appValueStr  = @"8qm5qz0T53EbYprwUAi1f";
    
    //将请求头参数拼接后进行MD5加密（appkey + timestamp + nonce + examid + appvalue）
    NSString *temStr = [NSString stringWithFormat:@"%@%@%@%@%@",appKeyStr,timestampStr,nonceStr,examidStr,appValueStr];
    NSString *signature = [ManagerTools MD5WithStr:temStr];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0;  //设置网络请求超时时间
    //设置请求头Header
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:appKeyStr    forHTTPHeaderField:@"appkey"];
    [manager.requestSerializer setValue:timestampStr forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:nonceStr     forHTTPHeaderField:@"nonce"];
    [manager.requestSerializer setValue:examidStr    forHTTPHeaderField:@"examid"];
    [manager.requestSerializer setValue:appValueStr  forHTTPHeaderField:@"appvalue"];
    [manager.requestSerializer setValue:signature    forHTTPHeaderField:@"signature"];
    
    switch (requestType)
    {
            /****** Get请求 ******/
        case HttpRequestTypeGet:
        {
            if (parameters)
            {
                NSDictionary *dic = (NSDictionary *)parameters;
                if (dic.count > 0)
                {
                    //拼接URL
                    URLString = [URLString stringByAppendingString:@"?"];
                    for (int i = 0; i < dic.count; i ++)
                    {
                        URLString = [URLString stringByAppendingFormat:@"%@=%@&",[dic allKeys][i],[dic allValues][i]];
                    }
                    URLString = [URLString substringToIndex:URLString.length - 1];
                }
            }
            
            [manager GET:URLString parameters:nil progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 if (complete)
                 {
                     complete(responseObject);
                 }
             }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 if (complete)
                 {
                     if (error.code == -1009)  //无网络连接
                     {
                         [XZCustomWaitingView hideWaitingMaskView];
                         [XZCustomWaitingView showAutoHidePromptView:@"当前无网络连接" background:nil showTime:1.0f];
                     }
                     else if (error.code == -1001)  //请求超时
                     {
                         [XZCustomWaitingView hideWaitingMaskView];
                         [XZCustomWaitingView showAutoHidePromptView:@"请求超时\n请检查网络状态" background:nil showTime:1.0f];
                     }
                     else
                     {
                         complete(error);
                     }
                 }
             }];
        }
            break;
            /****** Post请求 ******/
        case HttpRequestTypePost:
        {
            [manager POST:URLString parameters:parameters progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 if (complete)
                 {
                     complete(responseObject);
                 }
             }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 if (complete)
                 {
                     if (error.code == -1009)  //无网络连接
                     {
                         [XZCustomWaitingView hideWaitingMaskView];
                         [XZCustomWaitingView showAutoHidePromptView:@"当前无网络连接" background:nil showTime:1.0f];
                     }
                     else if (error.code == -1001)  //请求超时
                     {
                         [XZCustomWaitingView hideWaitingMaskView];
                         [XZCustomWaitingView showAutoHidePromptView:@"请求超时\n请检查网络状态" background:nil showTime:1.0f];
                     }
                     else
                     {
                         complete(error);
                     }
                 }
             }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 解析Json数据
+ (id)jsonDataToDicOrArrayWithData:(id)data
{
    NSError *error;
    if ([data isKindOfClass:[NSError class]] || error != nil)
    {
        [XZCustomWaitingView hideWaitingMaskView];
        [XZCustomWaitingView showAutoHidePromptView:@"服务器请求失败" background:nil showTime:1.0];
        return nil;
    }
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    return result;
}

@end
