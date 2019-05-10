//
//  ZNLXCellModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNLXCellModel : NSObject

@property (nonatomic, assign) NSInteger sid;           //ID
@property (nonatomic, assign) NSInteger courseId;      //科目ID
@property (nonatomic, assign) NSInteger sType;         //题型类别 0 为散体，1为套题
@property (nonatomic, copy)   NSString *title;         //名称
@property (nonatomic, assign) NSInteger suId;          //父ID
@property (nonatomic, assign) NSInteger isQues;        //是否有子级别  1：有子集  0：没有子集
@property (nonatomic, assign) NSInteger order;         //排序
@property (nonatomic, assign) NSInteger qCount;        //题总量
@property (nonatomic, assign) BOOL isBuy;              //是否需要购买
@property (nonatomic, assign) NSInteger pid;           //产品ID
@property (nonatomic, assign) NSInteger appType;       //权限验证ID
@property (nonatomic, assign) float     difficulty;    //题库难度
@property (nonatomic, assign) NSInteger writeNum;      //做题人数
@property (nonatomic, assign) float     averageScore;  //平均分
@property (nonatomic, strong) NSMutableArray<ZNLXCellModel *> *basicList;  //子节点列表
@property (nonatomic, strong) ZNLXCellModel *supermodel;
@property (nonatomic, assign) NSInteger belowCount;  //下级列表数据的count
/*** 临时添加 ***/
@property (nonatomic, assign) NSInteger isUsing;     //
@property (nonatomic, copy)   NSString *sStartTime;  //
@property (nonatomic, copy)   NSString *sErrMsg;     //

+ (instancetype)modelWithDic:(NSDictionary *)dic;
- (NSArray *)open;
- (void)closeWithBasicList:(NSArray *)basicList;

//
@property (nonatomic, assign) NSInteger exQNum;  //做题数量

@end
