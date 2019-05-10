//
//  UserGradeModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/3.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserGradeModel : NSObject
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, assign) BOOL isCompleted;
@end

NS_ASSUME_NONNULL_END
