//
//  HomeModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** HomeModuleModel ***/
@interface HomeModel : NSObject
@end


/*** HomeModuleModel ***/
@interface HomeModuleModel : NSObject
@property (nonatomic, copy)   NSString *imgUrl;   //图片地址（https)
@property (nonatomic, copy)   NSString *title;    //标题
@property (nonatomic, assign) NSInteger type;     //视图类别
@property (nonatomic, assign) NSInteger mark;     //标示
@property (nonatomic, strong) NSDictionary *para; //参数
@end


/*** AdInfoModel ***/
@interface AdInfoModel : NSObject
//@property (nonatomic, assign) NSInteger id;           //ID
@property (nonatomic, assign) NSInteger place;        //位置
@property (nonatomic, copy)   NSString *placeTitle;   //位置说明
@property (nonatomic, copy)   NSString *title;        //广告标题
@property (nonatomic, copy)   NSString *imgUrl;       //图片地址
@property (nonatomic, copy)   NSString *explain;      //图片说明
@property (nonatomic, assign) NSInteger system;       //系统标示 0 通用， 1 IOS， 2 安卓， 3 微信
@property (nonatomic, copy)   NSString *operateType;  //操作类别 link 网页跳转， keywords 关键字， event 事件
@property (nonatomic, copy)   NSString *operateValue; //操作值
@property (nonatomic, assign) NSInteger compelShow;   //强制显示
@end


/*** AppUpdateModel ***/
@interface AppUpdateModel : NSObject
//@property (nonatomic, assign) NSInteger id;         //ID
@property (nonatomic, copy)   NSString *appName;     //APP名称
@property (nonatomic, copy)   NSString *appVer;      //系统版本号
@property (nonatomic, copy)   NSString *appVerName;  //显示版本号
@property (nonatomic, assign) NSInteger isCoerce;    //是否强制更新
@property (nonatomic, assign) NSInteger sysType;     //系统类别
@property (nonatomic, copy)   NSString *downUrl;     //下载URL
@property (nonatomic, assign) NSInteger appStatus;   //APP状态（0 等待审核，1 审核通过）
@property (nonatomic, copy)   NSString *updateLog;   //更新日志
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@end




