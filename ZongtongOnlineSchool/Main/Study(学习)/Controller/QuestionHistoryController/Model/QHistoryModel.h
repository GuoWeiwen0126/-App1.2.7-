//
//  QHistoryModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHistoryModel : NSObject

@property (nonatomic, assign) NSInteger eid;        //考试ID
@property (nonatomic, assign) NSInteger courseid;   //科目ID
@property (nonatomic, assign) NSInteger sid;        //章节ID
@property (nonatomic, copy)   NSString *title;      //标题
@property (nonatomic, assign) NSInteger qCount;     //试题总数
@property (nonatomic, assign) NSInteger useTime;    //总用时
@property (nonatomic, assign) NSInteger rightNum;   //对的数量
@property (nonatomic, assign) NSInteger mistakeNum; //错题数量
@property (nonatomic, copy)   NSString *userScore;  //用户分数
@property (nonatomic, copy)   NSString *insertTime; //录入时间
@property (nonatomic, assign) NSInteger doCount;    //做题数量
@property (nonatomic, copy)   NSString *upTime;     //最后更新时间
@property (nonatomic, assign) NSInteger hcType;     //类别标识
@property (nonatomic, assign) NSInteger isRepeat;   //是否重做（0：重复考试，1：禁止重复考试，2：一月内重复考试）
@property (nonatomic, copy)   NSString *qidJson;    //题编号集合

@end
