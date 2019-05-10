//
//  MKModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKModel : NSObject
@end

/*** EmkBasicListModel ***/
@interface EmkInfoListModel : NSObject
@property (nonatomic, assign) NSInteger emkiId;       //模考绑定id
@property (nonatomic, assign) NSInteger emkid;        //模考id
@property (nonatomic, copy)   NSString *courserId;    //科目id
@property (nonatomic, copy)   NSString *sfid;         //类别id
@property (nonatomic, assign) NSInteger sid;          //试题id
@property (nonatomic, copy)   NSString *courserTitle; //科目名称
@property (nonatomic, assign) NSInteger examTime;     //考试时长(分钟)
@property (nonatomic, assign) NSInteger pepeopleNum;  //参加考试人数

@property (nonatomic, assign) BOOL isJoinedExam;  //是否参加过考试
@end
/*** ExamMockInfoModel ***/
@interface ExamMockInfoModel : NSObject
@property (nonatomic, assign) NSInteger emkid;   //编号
@property (nonatomic, copy)   NSString *title;   //模考标题
@property (nonatomic, copy)   NSString *stime;   //开考时间
@property (nonatomic, copy)   NSString *etime;   //闭考时间
@property (nonatomic, assign) NSInteger year;    //年份
@property (nonatomic, copy)   NSString *imgurl;  //图片
@property (nonatomic, copy)   NSString *intro;   //说明
@property (nonatomic, assign) NSInteger isnext;  //下一轮考试0否1是(当前考试时间结束,显示下一场考试信息)
@property (nonatomic, strong) NSMutableArray<EmkInfoListModel *> *basicList;  //科目列表

@property (nonatomic, assign) BOOL isSignUp;  //是否报名
@end


/*** MKRankCourseModel ***/
@interface MKRankCourseModel : NSObject
@property (nonatomic, copy)   NSString *courserTitle;  //
@property (nonatomic, copy)   NSString *score;         //
@end
/*** MKRankModel ***/
@interface MKRankModel : NSObject
@property (nonatomic, assign) NSInteger emkrid;      //id
@property (nonatomic, assign) NSInteger emkid;       //模考id
@property (nonatomic, assign) NSInteger uid;         //用户id
@property (nonatomic, copy)   NSString *nickname;    //昵称
@property (nonatomic, copy)   NSString *scoreCount;  //总成绩
@property (nonatomic, assign) NSInteger timeCount;   //总用时
@property (nonatomic, strong) NSMutableArray<MKRankCourseModel *> *SingleList;  //单科成绩列表
@end


/*** EmkBasicListModel ***/
@interface EmkBasicListModel : NSObject
@property (nonatomic, assign) NSInteger emkiId;       //
@property (nonatomic, assign) NSInteger emkid;        //
@property (nonatomic, copy)   NSString *courserId;    //科目id
@property (nonatomic, copy)   NSString *sfid;         //类别id
@property (nonatomic, copy)   NSString *courserTitle; //科目名称
@property (nonatomic, assign) NSInteger examTime;     //考试时长(分钟)
@property (nonatomic, assign) NSInteger pepeopleNum;  //参加考试人数
@end
/*** EmkListModel ***/
@interface EmkListModel : NSObject
@property (nonatomic, assign) NSInteger emkid;         //编号
@property (nonatomic, copy)   NSString *title;         //模考标题
@property (nonatomic, assign) NSInteger year;          //年份
@property (nonatomic, assign) NSInteger isdefault;     //默认展开
@property (nonatomic, assign) NSInteger emkiId;        //试题id
@property (nonatomic, assign) NSInteger pepeopleNum;   //参加考试人数
@property (nonatomic, copy)   NSString *courserId;     //科目id
@property (nonatomic, copy)   NSString *sfid;          //类别id
@property (nonatomic, copy)   NSString *courserTitle;  //科目名称
@property (nonatomic, copy)   NSString *stime;         //开始时间
@property (nonatomic, copy)   NSString *etime;         //结束时间
@property (nonatomic, strong) NSMutableArray<EmkBasicListModel *> *basicList;  //考试信息列表

@property (nonatomic, assign) BOOL isSignUp;  //是否报名
@property (nonatomic, assign) BOOL isOpen;    //是否展开
@end


/*** EmkUserGradeModel ***/
@interface EmkUserGradeModel : NSObject
@property (nonatomic, assign) NSInteger emkid;         //
@property (nonatomic, assign) NSInteger emkiid;        //
@property (nonatomic, assign) NSInteger ecount;        //
@property (nonatomic, assign) NSInteger uid;           //
@property (nonatomic, assign) NSInteger mistakeNum;    //
@property (nonatomic, assign) NSInteger emksid;        //
@property (nonatomic, copy)   NSString *scoreMax;      //
@property (nonatomic, assign) NSInteger estate;        //
@property (nonatomic, assign) NSInteger courserId;     //
@property (nonatomic, assign) NSInteger useTime;       //
@property (nonatomic, assign) NSInteger cheat;         //
@property (nonatomic, assign) NSInteger sid;           //
@property (nonatomic, assign) NSInteger rightNum;      //
@property (nonatomic, copy)   NSString *nickname;      //
@property (nonatomic, copy)   NSString *courserTitle;  //
@property (nonatomic, copy)   NSString *score;         //
@property (nonatomic, assign) NSInteger eid;           //
@property (nonatomic, copy)   NSString *endtime;       //结束考试时间
@end


/*** MKQuestionModel ***/
@interface MKQuestionModel : NSObject
@property (nonatomic, assign) NSInteger emkiid;          //
@property (nonatomic, assign) NSInteger examTime;        //
@property (nonatomic, copy)   NSString *mockTitle;       //
@property (nonatomic, assign) NSInteger courseid;        //
@property (nonatomic, copy)   NSString *mockStart;       //
@property (nonatomic, copy)   NSString *mockEnd;         //
@property (nonatomic, assign) NSInteger sid;             //
@property (nonatomic, assign) NSInteger emkid;           //
@property (nonatomic, copy)   NSString *courseTitle;     //
@property (nonatomic, strong) NSMutableArray *quesList;  //
@end


NS_ASSUME_NONNULL_END
