//
//  TalkfunLoginRequest.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/22.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunLoginRequest.h"

@implementation TalkfunLoginRequest

+ (void)requestForNewLogin:(NSDictionary *)params callback:(void (^)(id result))callback{
    [TalkfunHttpTools post:@"https://open.talk-fun.com/live/mobile/login_v2.php" params:params callback:^(id result) {
        PERFORM_IN_MAIN_QUEUE(
                              if (callback) {
                                  callback(result);
                              }
                              )
    }];
}

+ (void)requestForScanIn:(NSDictionary *)params callback:(void (^)(id result))callback{
    [TalkfunHttpTools post:@"https://open.talk-fun.com/live/mobile/scanQrcodeV2.php" params:params callback:^(id result) {
        PERFORM_IN_MAIN_QUEUE(
                              if (callback) {
                                  callback(result);
                              }
                              )
    }];
}



+ (void)tempLoginRequestForScanIn:(NSDictionary *)params callback:(void (^)(id result))callback{
    [TalkfunHttpTools post:@"https://open.talk-fun.com/live/mobile/tempLogin.php" params:params callback:^(id result) {
        PERFORM_IN_MAIN_QUEUE(
                              if (callback) {
                                  callback(result);
                              }
                              )
    }];
}

@end
