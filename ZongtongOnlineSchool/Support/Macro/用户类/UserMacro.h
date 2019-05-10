//
//  UserMacro.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#ifndef UserMacro_h
#define UserMacro_h

#define NSLocalizedString_ZT(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

/*
 * 试用账号
 */
#define IsLocalAccount ([[USER_DEFAULTS objectForKey:User_uid] integerValue] == 1124 ? YES:NO)
#define User_sum_LocalAccount @"User_sum_LocalAccount"  //试用账号金币数 (本地)
#define AfterReview [USER_DEFAULTS boolForKey:@"AfterReview"]  //审核通过

/*
 * 会员信息
 */
#define User_uid         @"uid"          //用户ID
#define User_phone       @"phone"        //手机号
#define User_nickName    @"nickName"     //会员昵称
#define User_portrait    @"portrait"     //头像
#define User_agentId     @"agentId"      //代理商ID
#define User_status      @"status"       //状态
#define User_sum         @"sum"          //金币金额
#define User_grade       @"grade"        //会员等级
#define User_gradeNumber @"gradeNumber"  //等级值
#define User_vip         @"vip"          //VIP等级
#define User_vipNumber   @"vipNumber"    //VIP等级值
#define User_token       @"token"        //Token (重复登录验证)
/*
 * 会员扩展信息
 */
#define User_ueid        @"ueid"         //ID
#define User_sexType     @"sexType"      //性别（男 0，女 1）
#define User_name        @"name"         //用户名称
#define User_province    @"province"     //省
#define User_city        @"city"         //市
#define User_address     @"address"      //地址
#define User_insertTime  @"insertTime"   //录入时间
/*
 * 会员邮寄信息
 */
#define User_Address_Name     @"User_Address_Name"     //收件人
#define User_Address_Phone    @"User_Address_Phone"    //手机号码
#define User_Address_Province @"User_Address_Province" //所在省
#define User_Address_City     @"User_Address_City"     //所在市
#define User_Address_Address  @"User_Address_Address"  //详细地址
/*
 * 会员其他信息
 */
#define User_RememberPassword @"User_RememberPassword" //记住密码 (YES:记住密码  NO:不记住密码)
#define User_Password         @"User_Password"         //用户密码

/*
 * 考试信息
 */
#define EIID           @"eiid"           //当前ID (eg：会计从业、会计初级)
#define EIIDNAME       @"eiidName"       //当前ID名称 (eg：会计从业、会计初级)
#define COURSEID       @"COURSEID"       //当前科目ID
#define COURSEIDNAME   @"COURSEIDNAME"   //当前科目名称
#define User_ExamType  @"User_ExamType"  //用户考试类型
#define MKNowExamSTime @"MKNowExamSTime" //当前模考开考时间

/*
 * 做题相关
 */
#define Question_Mode      @"Question_Mode"       //做题模式 (0--练习模式， 1--模考模式， 2--浏览模式)
#define Question_IsAnalyse @"Question_IsAnalyse"  //解析模式 (NO， YES)
#define Question_DayNight  @"Question_DayNight"   //日间、夜间模式 (NO：日间  YES：夜间)
#define IsMKQuestionMode   @"IsMKQuestionMode"        //是否是万人模考
#define MKQuestion_IsAnalyse @"MKQuestion_IsAnalyse"  //模考解析模式

/*
 * 视频相关
 */
#define VideoSource @"VideoSource"  //切换线路（切换线路：默认，电信，联通，教育网，移动）
#define VideoSource_moren @"video.zongtongedu.com"
#define VideoSource_dx @"dxvideo.zongtongedu.com"
#define VideoSource_lt @"ltvideo.zongtongedu.com"
#define VideoSource_jy @"jyvideo.zongtongedu.com"
#define VideoSource_yd @"ydvideo.zongtongedu.com"
#define VideoSourceArray @[VideoSource_moren, VideoSource_dx, VideoSource_lt, VideoSource_jy, VideoSource_yd]


#endif /* UserMacro_h */
