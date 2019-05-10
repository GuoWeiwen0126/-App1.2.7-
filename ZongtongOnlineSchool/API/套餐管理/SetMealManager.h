//
//  SetMealManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SetMealManagerBlock)(id obj);

@interface SetMealManager : NSObject

#pragma mark - 套餐详情
+ (void)setMealManagerInfoWithSmid:(NSString *)smid completed:(SetMealManagerBlock)completed;

@end
