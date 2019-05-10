//
//  FeedbackModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackModel : NSObject
/*  fType
 未选择 = 0,
 答案错误 = 1,
 解析错误 = 2,
 题目不严谨 = 3,
 选项错误 = 4,
 错别字或乱码 = 5,
 其他 = 99
 *
 * * * * * *
 *  Status
 用户提交 = 0,
 老师已回复 = 1,
 学生已回复 = 2,
 反馈已关闭 = 3,
 学生已评分 = 4
*/
@property (nonatomic, assign) NSInteger fid;         //反馈ID
@property (nonatomic, assign) NSInteger courseid;    //科目ID
@property (nonatomic, assign) NSInteger sid;         //章节ID
@property (nonatomic, assign) NSInteger qid;         //问题ID
@property (nonatomic, assign) NSInteger uid;         //用户ID
@property (nonatomic, assign) NSInteger fType;       //反馈类别
@property (nonatomic, copy)   NSString *fTypeTitle;  //反馈类别说明
@property (nonatomic, copy)   NSString *content;     //反馈内容
@property (nonatomic, assign) NSInteger grade;       //反馈评分
@property (nonatomic, copy)   NSString *frComment;   //反馈评论
@property (nonatomic, assign) NSInteger status;      //状态
@property (nonatomic, copy)   NSString *statusTitle; //状态说明
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@end

@interface FeedbackReplyModel : NSObject
@property (nonatomic, assign) NSInteger frid;       //回复内容ID
@property (nonatomic, assign) NSInteger fid;        //反馈ID
@property (nonatomic, assign) NSInteger userType;   //用户类别 （0 为后台老师，1 用户）
@property (nonatomic, assign) NSInteger frUid;      //用户ID
@property (nonatomic, copy)   NSString *userName;   //用户名称
@property (nonatomic, copy)   NSString *content;    //内容
@property (nonatomic, copy)   NSString *insertTime; //录入时间
@end


