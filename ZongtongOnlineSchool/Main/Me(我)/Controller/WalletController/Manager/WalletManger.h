//
//  WalletManger.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WalletManagerBlock)(id obj);

@interface WalletManger : NSObject

#pragma mark - 某类产品
+ (void)walletGetBasicListWithType:(NSString *)type completed:(WalletManagerBlock)completed;

#pragma mark - 产品详情
+ (void)walletGetBasicWithPid:(NSString *)pid completed:(WalletManagerBlock)completed;

@end
