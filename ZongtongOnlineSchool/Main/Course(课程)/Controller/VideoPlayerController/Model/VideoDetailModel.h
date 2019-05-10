//
//  VideoDetailModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  视频详情 Model
 */
@interface VideoDetailModel : NSObject
@property (nonatomic, assign) NSInteger vid;       //视频ID
@property (nonatomic, assign) NSInteger courseid;  //科目ID
@property (nonatomic, assign) NSInteger vtid;      //分类ID
@property (nonatomic, copy)   NSString *vTitle;    //标题
@property (nonatomic, copy)   NSString *vImg;      //视频首图
@property (nonatomic, copy)   NSString *ccVid;     //CC视频ID
@property (nonatomic, copy)   NSString *vUrl;      //视频地址
@property (nonatomic, copy)   NSString *alyVid;    //阿里云的视频ID
@property (nonatomic, copy)   NSString *sourceJson;//清晰的JSON
@property (nonatomic, strong) NSArray  *sourceList;//清晰度
@property (nonatomic, copy)   NSString *vSynopsis; //视频说明
@property (nonatomic, copy)   NSString *teacher;   //老师信息
@property (nonatomic, assign) NSInteger vtime;     //视频时长
@property (nonatomic, assign) NSInteger order;     //排序（默认是 99）
@property (nonatomic, assign) NSInteger vhid;      //讲义ID
@property (nonatomic, assign) NSInteger grade;     //评分
@property (nonatomic, copy)   NSString *gradeItem; //评分分组（字符串）
@property (nonatomic, strong) NSDictionary *item;  //评分分组（已经格式化）
//
@property (nonatomic, assign) NSInteger srid;    //观看记录ID
@property (nonatomic, assign) NSInteger srTime;  //学习时长（分钟）
@end

/*
 *  视频评价 Model
 */
@interface VideoEvaluateModel : NSObject
@property (nonatomic, assign) NSInteger vaid;       //评价ID
@property (nonatomic, assign) NSInteger courseid;   //科目ID
@property (nonatomic, assign) NSInteger vtid;       //章节ID
@property (nonatomic, assign) NSInteger vid;        //视频ID
@property (nonatomic, copy)   NSString *content;    //评价内容
@property (nonatomic, copy)   NSString *insertTime; //录入时间
@property (nonatomic, assign) NSInteger uid;        //用户ID
@property (nonatomic, copy)   NSString *nickName;   //用户昵称
@property (nonatomic, copy)   NSString *portrait;   //头像
@end




