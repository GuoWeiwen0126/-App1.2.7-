//
//  QuestionModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>


/*** UserQModel ***/
@interface UserQModel : NSObject
@property (nonatomic, assign) NSInteger courserid; //科目ID
@property (nonatomic, assign) NSInteger sid;       //章节ID
@property (nonatomic, assign) NSInteger qid;       //问题ID
@property (nonatomic, assign) NSInteger eNum;      //做题次数
@property (nonatomic, assign) NSInteger mNum;      //错误数次
@property (nonatomic, copy)   NSString *mAnswer;   //错误答案
@property (nonatomic, copy)   NSString *uAnswer;   //用户答案
@property (nonatomic, copy)   NSString *upTime;    //最后一次时间
@end


/*** QNoteModel ***/
@interface QNoteModel : NSObject
@property (nonatomic, assign) NSInteger qid;          //问题ID
@property (nonatomic, assign) NSInteger nid;          //笔记ID
@property (nonatomic, copy)   NSString *nickName;     //用户昵称
@property (nonatomic, copy)   NSString *portrait;     //头像
@property (nonatomic, copy)   NSString *content;      //笔记内容
@property (nonatomic, copy)   NSString *insertTime;   //录入时间
@property (nonatomic, assign) NSInteger praise;       //点赞数量
@property (nonatomic, copy)   NSString *isNoteLook;   //是否查看过（0：未查看  1：查看过）
@property (nonatomic, copy)   NSString *isNotePraise; //是否点赞（0：未点赞  1：点赞）
@end


/*** QVideoModel ***/
@interface QVideoModel : NSObject
@property (nonatomic, assign) NSInteger qid;      //题ID
@property (nonatomic, assign) NSInteger qvid;     //视频ID
@property (nonatomic, copy)   NSString *videoImg; //视频图片
@property (nonatomic, copy)   NSString *video;    //视频地址
@property (nonatomic, assign) NSInteger charge;   //是否购买（0 为免费 1为收费）
@property (nonatomic, assign) NSInteger pid;      //产品ID
@property (nonatomic, assign) NSInteger appType;  //权限类别
@end


/*** QExerinfoBasicModel ***/
@interface QExerinfoBasicModel : NSObject
@property (nonatomic, assign) NSInteger eiid;        //记录详情ID
@property (nonatomic, assign) NSInteger eid;         //考试试卷ID
@property (nonatomic, assign) NSInteger uid;         //用户ID
@property (nonatomic, assign) NSInteger qid;         //题ID
@property (nonatomic, copy)   NSString *uAnswer;     //用户答案
@property (nonatomic, copy)   NSString *answer;      //正确答案
@property (nonatomic, assign) NSInteger isRight;     //是否正确 0--为不记算，1--为正确，2---为错
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@end


/*** QExerinfoModel ***/
@interface QExerinfoModel : NSObject
@property (nonatomic, assign) NSInteger eid;         //试卷ID
@property (nonatomic, assign) NSInteger uid;         //用户ID
@property (nonatomic, copy)   NSString *title;       //标题
@property (nonatomic, assign) NSInteger qCount;      //总题数
@property (nonatomic, assign) NSInteger useTime;     //用时（秒）
@property (nonatomic, assign) NSInteger rightNum;    //正确数
@property (nonatomic, assign) NSInteger mistakeNum;  //错误数
@property (nonatomic, copy)   NSString *userScore;   //用户答分
@property (nonatomic, copy)   NSString *qidJson;     //qidJson
@property (nonatomic, assign) NSInteger status;      //状态
@property (nonatomic, assign) NSInteger nowQid;      //当前题ID
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@property (nonatomic, strong) NSMutableArray<QExerinfoBasicModel *> *userExerList;  //做题详情
@end


/*** QtypeListModel ***/
@interface QtypeListModel : NSObject
@property (nonatomic, assign) NSInteger qtId;      //ID
@property (nonatomic, copy)   NSString *title;     //问题类别
@property (nonatomic, assign) NSInteger showKey;   //答题模式：1--单选，2--多选，3--判断 ，0--不做答
@property (nonatomic, copy)   NSString *showName;  //答题模式说明
@property (nonatomic, assign) NSInteger gradeType; //评分类别 （0：相等，  1：包含，  2：消防规则）
@property (nonatomic, assign) NSInteger order;     //显示顺序 默认 99
@end


/*** QuestionOptionModel ***/
@interface QuestionOptionModel : NSObject
@property (nonatomic, copy)   NSString *AZ;     //选项 前面 字母
@property (nonatomic, copy)   NSString *option; //选项
@property (nonatomic, assign) NSInteger value;  //选项值
@end


/*** QuestionModel ***/
@interface QuestionModel : NSObject
@property (nonatomic, assign) NSInteger qid;           //ID
@property (nonatomic, assign) NSInteger courseId;      //科目ID
@property (nonatomic, assign) NSInteger sid;           //章节ID
@property (nonatomic, assign) NSInteger qtid;          //题类别ID
@property (nonatomic, copy)   NSString *stem;          //题干
@property (nonatomic, copy)   NSString *stemTail;      //题干尾巴
@property (nonatomic, copy)   NSString *issue;         //问题
@property (nonatomic, copy)   NSString *option;        //选项
@property (nonatomic, strong) NSMutableArray<QuestionOptionModel *> *optionList; //选项列表
@property (nonatomic, copy)   NSString *answer;        //问题答案
@property (nonatomic, copy)   NSString *analysis;      //解析
@property (nonatomic, copy)   NSString *score;         //分值
@property (nonatomic, assign) NSInteger vid;           //视频ID（0 为没有视频）
@property (nonatomic, assign) NSInteger order;         //排序
@property (nonatomic, assign) NSInteger answerNum;     //总做题次数
@property (nonatomic, assign) NSInteger mistakeNum;    //总错次数
@property (nonatomic, copy)   NSString *mistakeAnswer; //易错项
//题分类（自定义）
@property (nonatomic, strong) QtypeListModel *qTypeListModel;  //题分类model
//题序号（自定义，用于答题卡界面）
@property (nonatomic, assign) NSInteger qIndex;  //题序号
//试卷信息
@property (nonatomic, strong) QExerinfoBasicModel *qExerinfoBasicModel;  //试卷信息model
//试题视频
@property (nonatomic, strong) QVideoModel *qVideModel;  //试题视频model
//云笔记
@property (nonatomic, strong) QNoteModel *qNoteModel;  //云笔记model
//用户统计
@property (nonatomic, strong) UserQModel *userQModel;  //用户统计model
//是否收藏
@property (nonatomic, assign) BOOL isCollect;  //是否收藏：YES:已收藏，NO:未收藏
//是否做过
@property (nonatomic, assign) BOOL isWrite;  //是否做过：YES:已做过，NO:未做过
//是否查看答案
@property (nonatomic, assign) BOOL isLookAnswer;  //是否查看答案
@end


