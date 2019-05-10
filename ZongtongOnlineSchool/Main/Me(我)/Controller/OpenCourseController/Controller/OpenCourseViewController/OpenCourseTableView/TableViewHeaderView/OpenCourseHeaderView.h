//
//  OpenCourseHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/27.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OpenCourseModel;

typedef void(^HeaderViewExpandCallBack)(BOOL isExpand);

@interface OpenCourseHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) OpenCourseModel *courseModel;
@property (nonatomic, copy) HeaderViewExpandCallBack expandCallBack;

@end
