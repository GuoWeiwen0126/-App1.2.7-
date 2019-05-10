//
//  TalkfunLoginRequest.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/22.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunLoginRequest : NSObject

+ (void)requestForNewLogin:(NSDictionary *)params callback:(void (^)(id result))callback;
+ (void)requestForScanIn:(NSDictionary *)params callback:(void (^)(id result))callback;

//免密登陆的请求
+ (void)tempLoginRequestForScanIn:(NSDictionary *)params callback:(void (^)(id result))callback;
@end
