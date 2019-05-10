//
//  HttpRequest.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/15.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tools.h"

@interface HttpRequest : NSObject

typedef NS_ENUM(NSUInteger, HttpRequestType)
{
    HttpRequestTypeGet  = 0,
    HttpRequestTypePost = 1,
};

typedef void (^ZTFinishBlockRequest)(id data);

/*
 * * * 发送网络请求
 @param URLString    请求的网址字符串
 @param parameters   请求的参数
 @param requestType  请求的类型
 @param resultBlock  请求的网址字符串
 */
+ (void)requestWithURLString:(NSString *)URLString
                  Parameters:(id)parameters
                 RequestType:(HttpRequestType)requestType
                   Completed:(ZTFinishBlockRequest)complete;

/*
 * * * 解析Json数据
 */
+ (id)jsonDataToDicOrArrayWithData:(id)data;

@end
