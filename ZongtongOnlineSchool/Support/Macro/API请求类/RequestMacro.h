//
//  RequestMacro.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/17.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#ifndef RequestMacro_h
#define RequestMacro_h


#define AFNReachabilityManager [AFNetworkReachabilityManager sharedManager]
/*
 * HOST地址
 */
//#define HOST   @"http://192.168.3.199:5000"  //测试库
//#define HOST   @"http://192.168.3.120:8088"  //吴阳阳测试库
#define HOST   @"https://wx.zongtongedu.com"   //正式库
#define APIURL HOST@"/api/"

/*
 * 图片地址
 */
#define QuestionImgHOSTURL @"https://videoimg.zongtongedu.com/questionIMG" //题目图片地址

/*
 * 分享地址
 */
//分享App
#define ShareAppURL @"https://www.zongtongedu.com/download/appdown"
//点赞URL
#define ShareInfoNumberURL(shareNum,eiid) [NSString stringWithFormat:@"https://www.zongtongedu.com/share/newPraise?sn=%@&examid=%@",shareNum,eiid]
//考朋友URL
#define ShareQInfoURL(eiid,qid) [NSString stringWithFormat:@"https://www.zongtongedu.com/share/qinfo?examid=%@&qid=%ld",eiid,qid]

/*
 * AppStatus
 */
#define AppStatus @"AppStatus"  //APP状态（0 等待审核，1 审核通过）
#define AppVer    @"AppVer"     //APP版本号

/*
 * 全局信息
 */
#define LoadingImage @"LoadingImage"
#define PortraitPlaceholder [UIImage imageNamed:@"zhanweitu.png"]
#define Payment   @"Payment"  //支付方式
#define QQGroup   @"QQGroup"  //QQ交流群
#define ServiceQQ @"ServiceQQ"  //客服QQ
#define BufferIcover @"BufferIcover"  //首页做题配置缓存icon （0：不更新  1：更新）

/*
 * 配置信息
 */
#define URL_MainConfig  APIURL@"MainConfig/"
#define URL_HomeConfig  APIURL@"HomeConfig/"
#define URL_AdInfoServe APIURL@"AdInfoServe/"
#define URL_AppUpdate   APIURL@"AppUpdate/"
#define URL_BufferVer   APIURL@"BufferVer/"
#define URL_AppFeedback APIURL@"AppFeedback/"
#define URL_MainConfig  APIURL@"MainConfig/"
#define URL_PushInfo    APIURL@"PushInfo/"

/*
 * 会员信息
 */
#define URL_User APIURL@"User/"

/*
 * 考试信息
 */
#define URL_ExamInfo APIURL@"ExamInfo/"

/*
 * 权限
 */
#define URL_UserApp   APIURL@"userApp/"
#define URL_AppConfig APIURL@"appConfig/"

/*
 * 章节信息
 */
#define URL_Section APIURL@"qSection/"

/*
 * 章节信息
 */
#define URL_QSectionFirst APIURL@"qSectionFirst/"

/*
 * 题库信息
 */
#define URL_Question APIURL@"question/"

/*
 * 问题类别
 */
#define URL_QType    APIURL@"qType/"

/*
 * 做题信息
 */
#define URL_Exercise APIURL@"Exercise/"

/*
 * 随机抽题
 */
#define URL_QuestionRules APIURL@"questionRules/"

/*
 * 收藏信息
 */
#define URL_QCollect APIURL@"qCollect/"

/*
 * 试题视频
 */
#define URL_QVideo    APIURL@"qVideo/"
#define URL_QVComment APIURL@"qVComment/"

/*
 * 问题反馈
 */
#define URL_Feedback APIURL@"feedback/"
#define URL_QFeedbackR APIURL@"qFeedbackR/"

/*
 * 云笔记
 */
#define URL_QNote APIURL@"qNote/"

/*
 * 错题信息
 */
#define URL_QMistake APIURL@"qMistake/"

/*
 * 视频信息
 */
#define URL_VideoTypeFirst APIURL@"videoTypeFirst/"
#define URL_VideoType APIURL@"VideoType/"
#define URL_Video     APIURL@"Video/"
#define URL_VideoStudy    APIURL@"VideoStudy/"
#define URL_VideoAppraise APIURL@"VideoAppraise/"

/*
 * 直播功能
 */
#define URL_LiveType    APIURL@"LiveType/"
#define URL_LiveVideo   APIURL@"LiveVideo/"
#define URL_LiveLookLog APIURL@"LiveLookLog/"

/*
 * 万人模考
 */
#define URL_ExamMock         APIURL@"examMock/"
#define URL_ExamMockScore    APIURL@"examMockScore/"
#define URL_ExamMockRanking  APIURL@"examMockRanking/"

/*
 * 积分功能
 */
#define URL_UserGrade APIURL@"UserGrade/"
#define URL_IntegralShareInfo APIURL@"IntegralShareInfo/"

/*
 * 资料下载
 */
#define URL_FileDown APIURL@"fileDown/"
#define URL_DownGold APIURL@"downGold/"

/*
 * 分享功能
 */
#define URL_ShareInfo APIURL@"shareInfo/"

/*
 * 用户统计
 */
#define URL_UserQuestion APIURL@"UserQuestion/"
#define URL_UserSection  APIURL@"UserSection/"

/*
 * 优惠券
 */
#define URL_Coupon APIURL@"Coupon/"

/*
 * 激活码
 */
#define URL_Activation APIURL@"Activation/"

/*
 * 套餐管理
 */
#define URL_SetMeal APIURL@"SetMeal/"

/*
 * 产品信息
 */
#define URL_Product APIURL@"Product/"

/*
 * 订单管理
 */
#define URL_Order APIURL@"Order/"


/*
 * 请求工具
 */
#define DicSetObjForKey(dic,obj,key) if (obj == nil || obj == NULL || [obj isKindOfClass:[NSNull class]]) {\
                                        [dic setObject:@"" forKey:key];\
                                     }else {\
                                        [dic setObject:obj forKey:key];\
                                     }\

#define StatusIsEqualToZero(dic) [[dic objectForKey:@"Status"] integerValue] == 0 && dic != nil

#define ShowErrMsgWithDic(dic) if (dic != nil) {\
                                    [XZCustomWaitingView showAutoHidePromptView:dic[@"ErrMsg"] background:nil showTime:1.0];\
                                }


#endif /* RequestMacro_h */
