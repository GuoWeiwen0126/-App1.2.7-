//
//  CourseOptionModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/9.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>


/*** CellModel ***/
@interface CourseCellModel : NSObject

@property (nonatomic, assign) NSInteger eiid;          //ID       (eg：会计从业、会计初级)
@property (nonatomic, copy)   NSString *eiIco;         //考试图标
@property (nonatomic, assign) NSInteger etid;          //考试类别ID (eg：会计类、工程类)
@property (nonatomic, copy)   NSString *title;         //考试名称
@property (nonatomic, assign) NSInteger isCentCourse;  //是否分科目 (0为分，1为不分)
@property (nonatomic, assign) NSInteger order;         //排序
@property (nonatomic, copy)   NSString *isSelected;    //是否选中---1:选中  0:未选中

@end


/*** SectionModel ***/
@interface CourseSectionModel : NSObject

@property (nonatomic, assign) NSInteger etId;        //类别ID (eg：会计类、工程类)
@property (nonatomic, copy)   NSString *title;       //标题
@property (nonatomic, assign) NSInteger order;       //排序
@property (nonatomic, copy)   NSString *isExpanded;  //是否展开---1:展开  0:闭合
@property (nonatomic, strong) NSMutableArray<CourseCellModel *> *infoList;  //考试详情(列表)

@end


/*** OptionModel ***/
@interface CourseOptionModel : NSObject

@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, strong) NSMutableArray<CourseSectionModel *> *Data;

@end


/*** ListModel ***/
@interface CourseListModel : NSObject

@property (nonatomic, assign) NSInteger courseId;    //ID
@property (nonatomic, copy)   NSString *title;       //标题
@property (nonatomic, assign) NSInteger clPublic;    //是否公共科目（0 为不区别，1为公共科目，2 为专业科目）
@property (nonatomic, assign) NSInteger order;       //排序 默认 999
@property (nonatomic, assign) BOOL      isSelected;  //是否勾选---YES:勾选  NO:未勾选
+ (instancetype)modelWithDic:(NSDictionary *)dic courseIdArray:(NSArray *)courseIdArray;

@end

