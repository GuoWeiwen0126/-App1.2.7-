//
//  OpenCourseModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/4.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** OpenCourseModel ***///权限详情列表
@interface OpenDetailModel : NSObject
@property (nonatomic, assign) NSInteger examid;        //考试ID
@property (nonatomic, assign) NSInteger showType;      //显示类别
@property (nonatomic, copy)   NSString *appIco;        //权限图标
@property (nonatomic, assign) NSInteger appType;       //权限
@property (nonatomic, copy)   NSString *typeName;      //权限说明
@property (nonatomic, copy)   NSString *handleExplain; //操作数据说明
@end

/*** UserAppModel ***///会员所有权限
@interface UserAppModel : NSObject
@property (nonatomic, assign) NSInteger examid;    //考试ID
@property (nonatomic, assign) NSInteger aid;       //权限ID
@property (nonatomic, assign) NSInteger appType;   //权限类别
@property (nonatomic, copy)   NSString *typeName;  //权限类别说明
@property (nonatomic, assign) NSInteger courseid;  //科目ID
@property (nonatomic, copy)   NSString *endTime;   //过期时间
@end

/*** ListModel ***/
@interface OpenCourseListModel : NSObject
@property (nonatomic, assign) NSInteger courseId;    //ID
@property (nonatomic, copy)   NSString *title;       //标题
@property (nonatomic, assign) NSInteger clPublic;    //是否公共科目（0 为不区别，1为公共科目，2 为专业科目）
@property (nonatomic, assign) NSInteger order;       //排序 默认 999
@end

/*** OpenCourseModel ***///会员科目
@interface OpenCourseModel : NSObject
@property (nonatomic, assign) NSInteger eiid;          //ID       (eg：会计从业、会计初级)
@property (nonatomic, copy)   NSString *eiIco;         //考试图标
@property (nonatomic, assign) NSInteger etid;          //考试类别ID (eg：会计类、工程类)
@property (nonatomic, copy)   NSString *title;         //考试名称
@property (nonatomic, assign) NSInteger isCentCourse;  //是否分科目 (0为分，1为不分)
@property (nonatomic, assign) NSInteger order;         //排序
@property (nonatomic, copy)   NSString *isSelected;    //是否选中---1:选中  0:未选中
@property (nonatomic, strong) NSMutableArray<OpenCourseListModel *> *courseList;  //考试详情(列表)
@property (nonatomic, strong) NSMutableArray<UserAppModel *> *userAppList;      //权限详情列表
@end

/*** OpenExamModel ***///会员考试
@interface OpenExamModel : NSObject
@property (nonatomic, assign) NSInteger etId;        //类别ID (eg：会计类、工程类)
@property (nonatomic, copy)   NSString *title;       //标题
@property (nonatomic, assign) NSInteger order;       //排序
@property (nonatomic, copy)   NSString *isExpanded;  //是否展开---1:展开  0:闭合
@property (nonatomic, strong) NSMutableArray<OpenCourseModel *> *infoList;  //考试详情(列表)
@end

/*** OpenOptionModel ***/
@interface OpenOptionModel : NSObject
@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, strong) NSMutableArray<OpenExamModel *> *Data;
@end

