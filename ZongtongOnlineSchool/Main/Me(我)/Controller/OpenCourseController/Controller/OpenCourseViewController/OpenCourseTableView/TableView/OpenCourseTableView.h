//
//  OpenCourseTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OpenCourseModel;
@class OpenCourseListModel;

@protocol OpenCourseTableViewDelegate <NSObject>
- (void)openCourseTableViewCellClickedWithCourseModel:(OpenCourseModel *)courseModel listModel:(OpenCourseListModel *)listModel index:(NSInteger)index;
- (void)openCourseHeaderViewTappedWithCourseModel:(OpenCourseModel *)courseModel section:(NSInteger)section;
@end

@interface OpenCourseTableView : UITableView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id <OpenCourseTableViewDelegate> courseDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray;

@end
