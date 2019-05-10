//
//  ShareInfoModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/11.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareInfoModel : NSObject

@property (nonatomic, assign) NSInteger shareNum;       //分享码
@property (nonatomic, assign) NSInteger examid;         //考试ID（留后用）
@property (nonatomic, assign) NSInteger courseid;       //科目ID（留后用）
@property (nonatomic, assign) NSInteger uid;            //用户ID
@property (nonatomic, assign) NSInteger shareType;      //分享类别
@property (nonatomic, copy)   NSString *shareTypeTitle; //分享类别
@property (nonatomic, assign) NSInteger showNumber;     //查看次数
@property (nonatomic, assign) NSInteger praiseNumber;   //打Call次数
@property (nonatomic, copy)   NSString *shareTime;      //第一次分享时间
@property (nonatomic, copy)   NSString *endTime;        //过期时间（留后用）

@end
