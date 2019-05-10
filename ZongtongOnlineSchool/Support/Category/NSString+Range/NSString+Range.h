//
//  NSString+Range.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Range)

- (NSArray *)queryNameWithQIssueStr:(NSString *)qIssueStr fromStr:(NSString *)fromStr toStr:(NSString *)toStr;

@end
