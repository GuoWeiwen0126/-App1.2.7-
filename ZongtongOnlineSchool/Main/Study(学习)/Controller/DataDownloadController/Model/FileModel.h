//
//  FileModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/30.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject
@property (nonatomic, assign) NSInteger did;                //ID
@property (nonatomic, assign) NSInteger examid;             //考试ID
@property (nonatomic, assign) NSInteger courseid;           //科目ID
@property (nonatomic, assign) NSInteger materialType;       //资料类别
@property (nonatomic, copy)   NSString *materialTypeTitle;  //资料类别
@property (nonatomic, copy)   NSString *fileTitle;          //文件标题
@property (nonatomic, copy)   NSString *fileType;           //文件类别
@property (nonatomic, copy)   NSString *fileSize;           //文件大小
@property (nonatomic, assign) NSInteger fileOrder;          //排序
@property (nonatomic, assign) NSInteger goldNumber;         //需要积分个数
@property (nonatomic, copy)   NSString *insertTime;         //录入时间

@property (nonatomic, copy)   NSString *isBuy;         //是否有下载权限
@property (nonatomic, copy)   NSString *isDownloaded;  //是否已经缓存
@end

@interface FileCoinLogModel : NSObject
@property (nonatomic, assign) NSInteger ugid;        //记录ID
@property (nonatomic, assign) NSInteger eiid;        //
@property (nonatomic, assign) NSInteger uid;         //会员ID
@property (nonatomic, assign) NSInteger type;        //日志类别
@property (nonatomic, assign) NSInteger nowNum;      //
@property (nonatomic, assign) NSInteger changeNum;   //变化值
@property (nonatomic, assign) NSInteger surplusNum;  //剩余值
@property (nonatomic, copy)   NSString *explain;     //说明
@property (nonatomic, copy)   NSString *insertName;  //录入人
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@property (nonatomic, copy)   NSString *remark;      //
@property (nonatomic, assign) NSInteger source;      //
@property (nonatomic, assign) NSInteger courseid;    //
@end

@interface FileCoinHistoryModel : NSObject
@property (nonatomic, assign) NSInteger did;                //ID
@property (nonatomic, assign) NSInteger examid;             //考试ID
@property (nonatomic, assign) NSInteger courseid;           //科目ID
@property (nonatomic, assign) NSInteger materialType;       //资料类别
@property (nonatomic, copy)   NSString *materialTypeTitle;  //资料类别
@property (nonatomic, copy)   NSString *fileTitle;          //文件标题
@property (nonatomic, copy)   NSString *fileType;           //文件类别
@property (nonatomic, copy)   NSString *fileSize;           //文件大小
@property (nonatomic, assign) NSInteger fileOrder;          //排序
@property (nonatomic, assign) NSInteger goldNumber;         //需要积分个数
@property (nonatomic, copy)   NSString *insertTime;         //录入时间
@end
