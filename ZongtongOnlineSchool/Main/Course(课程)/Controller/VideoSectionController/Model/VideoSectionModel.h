//
//  VideoSectionModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoSectionModel : NSObject

@property (nonatomic, assign) NSInteger vtid;      //类别ID
@property (nonatomic, assign) NSInteger vtfid;     //  视频第一节点类别ID
@property (nonatomic, assign) NSInteger vtYear;    //  年份
@property (nonatomic, assign) NSInteger courseid;  //科目ID
@property (nonatomic, copy)   NSString *title;     //标题
@property (nonatomic, assign) NSInteger pvtid;     //父ID
@property (nonatomic, assign) NSInteger order;     //排序
@property (nonatomic, assign) NSInteger studyNum;  //学习人数
@property (nonatomic, assign) NSInteger vid;       //视频ID
@property (nonatomic, assign) NSInteger vtime;     //视频时长（分钟）
@property (nonatomic, assign) NSInteger vhid;      //  讲义ID
@property (nonatomic, assign) NSInteger vtNode;    //  是否有子节点
@property (nonatomic, copy)   NSString *vtErrMsg;  //  说明信息
@property (nonatomic, assign) NSInteger isUsing;   //  否限制显示 0 为正常 1为限制
@property (nonatomic, copy)   NSString *vtStartTime;//  限制时间
@property (nonatomic, copy)   NSString *vtSynopsis; //  章节说明（预计与视频相同）
@property (nonatomic, assign) BOOL isBuy;          //是否需要购买 1需要购买
@property (nonatomic, assign) NSInteger pid;       //产品ID
@property (nonatomic, assign) NSInteger appType;   //权限类别
@property (nonatomic, strong) NSMutableArray<VideoSectionModel *> *infoList;  //子节点列表
@property (nonatomic, strong) VideoSectionModel *supermodel;
@property (nonatomic, assign) NSInteger belowCount;  //下级列表数据的count

+ (instancetype)modelWithDic:(NSDictionary *)dic;
- (NSArray *)open;
- (void)closeWithInfoList:(NSArray *)infoList;

//
@property (nonatomic, assign) NSInteger srid;    //观看记录ID
@property (nonatomic, assign) NSInteger srTime;  //学习时长（分钟）

@end
