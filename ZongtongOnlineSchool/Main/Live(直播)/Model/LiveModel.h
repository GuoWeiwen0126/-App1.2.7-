//
//  LiveModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveModel : NSObject
@end

/*** ALiLiveModel ***/
@interface ALiLiveModel : NSObject
@property (nonatomic, copy)   NSString *appName;        //产品名称
@property (nonatomic, copy)   NSString *streamName;     //流地址
@property (nonatomic, copy)   NSString *rtmp;           //原始播放地址（WEB，APP默认使用这个）
@property (nonatomic, copy)   NSString *flv;            //FLV播放地址
@property (nonatomic, copy)   NSString *m3ub;           //移动端H5播放地址（移动端浏览器只能使用这个）
@property (nonatomic, copy)   NSString *lcAppId;        //聊天室APPID
@property (nonatomic, copy)   NSString *lcAppKey;       //聊天室的APPKey
@property (nonatomic, copy)   NSString *lcRommid;       //聊天室ID
@property (nonatomic, assign) NSInteger liveLookLogId;  //观看记录ID
@property (nonatomic, copy)   NSString *startTime;      //开始时间
@end

/*** ALiVideoModel ***/
@interface ALiVideoModel : NSObject
@property (nonatomic, copy)   NSString *access_token;    //
@property (nonatomic, copy)   NSString *miniprogramUrl;  //
@property (nonatomic, copy)   NSString *playbackUrl;     //
@property (nonatomic, copy)   NSString *sourceJson;      //清晰的JSON
@property (nonatomic, strong) NSArray  *sourceList;      //清晰度
@end

/*** LiveBasicListModel ***/
@interface LiveBasicListModel : NSObject
@property (nonatomic, assign) NSInteger lid;        //直播ID
@property (nonatomic, assign) NSInteger courseid;   //科目ID
@property (nonatomic, copy)   NSString *lvTitle;    //直播标题
@property (nonatomic, copy)   NSString *lvTeacher;  //教师名称
@property (nonatomic, copy)   NSString *lvStart;    //开始时间
@property (nonatomic, copy)   NSString *lvEnd;      //结束时间
@property (nonatomic, assign) NSInteger isBuy;      //是否需要购买(0为免费)
@property (nonatomic, assign) NSInteger pid;        //产品ID
@property (nonatomic, assign) NSInteger appType;    //权限类别
@property (nonatomic, copy)   NSString *lvTips;     //直播说明
@property (nonatomic, assign) NSInteger lv_LiveNum; //直播人数
@property (nonatomic, assign) NSInteger lvLookNum;  //查看人数
@property (nonatomic, assign) NSInteger lvState;    //状态(0:正常, 1:已结束,2: 已关闭,3: 已删除)
@property (nonatomic, assign) NSInteger lvOrder;    //排序
@property (nonatomic, assign) NSInteger lvPlayType;      //直播方式（1：阿里云  2：欢拓）
@property (nonatomic, copy)   NSString *lvPlayTypeTitle; //直播方式名称
@end

/*** LiveClassListModel ***/
@interface LiveClassListModel : NSObject
@property (nonatomic, assign) NSInteger ltid;        //数据ID
@property (nonatomic, assign) NSInteger ltType;      //类别
@property (nonatomic, copy)   NSString *ltTypeTitle; //类别说明
@property (nonatomic, assign) NSInteger courseid;    //科目ID
@property (nonatomic, copy)   NSString *ltTitle;     //类别标题
@property (nonatomic, copy)   NSString *ltStartTime; //下次直播时间
@property (nonatomic, copy)   NSString *ltTeacher;   //教师名称
@property (nonatomic, copy)   NSString *ltTUrl;      //教师头像地址
@property (nonatomic, assign) NSInteger ltTType;     //教师类别(1:金牌讲师，2:资深教授，3:资深讲师，4:后起之秀)
@property (nonatomic, assign) NSInteger ltfid;       //父ID
@property (nonatomic, assign) NSInteger ltNode;      //是否有子节点(0为无)
@property (nonatomic, assign) NSInteger ltOrder;     //排序值
@property (nonatomic, assign) NSInteger isDefault;   //是否默认
@property (nonatomic, copy)   NSString *insertName;  //录入人
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@property (nonatomic, strong) NSMutableArray<LiveClassListModel *> *typeList; //子节点
@property (nonatomic, strong) NSMutableArray<LiveBasicListModel *> *basicList; //班级节点
@end

///*** LiveBasicListModel ***/
//@interface LiveBasicListModel : NSObject
//
//@end


NS_ASSUME_NONNULL_END
