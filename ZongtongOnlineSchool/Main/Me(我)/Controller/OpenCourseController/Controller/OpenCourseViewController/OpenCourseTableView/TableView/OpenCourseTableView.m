//
//  OpenCourseTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenCourseTableView.h"
#import "Tools.h"
#import "OpenCourseHeaderView.h"
#import "OpenCourseTableViewCell.h"
#import "OpenCourseHeaderView.h"
#import "OpenCourseModel.h"

@interface OpenCourseTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OpenCourseTableView
static NSString *headerID = @"headerID";
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[OpenCourseHeaderView class] forHeaderFooterViewReuseIdentifier:headerID];
        [self registerNib:[UINib nibWithNibName:@"OpenCourseTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OpenCourseHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    OpenCourseModel *courseModel = self.dataArray[section];
    headerView.courseModel = courseModel;
    headerView.expandCallBack = ^(BOOL isExpand) {
//        courseModel.isSelected = [courseModel.isSelected boolValue] == 0 ? @"1":@"0";
//        [tableView reloadData];
        if ([courseModel.isSelected boolValue] == NO) {
            if ([self.courseDelegate respondsToSelector:@selector(openCourseHeaderViewTappedWithCourseModel:section:)]) {
                [self.courseDelegate openCourseHeaderViewTappedWithCourseModel:courseModel section:section];
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenCourseHeaderViewTapped" object:courseModel];
        }
    };
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OpenCourseModel *courseModel = self.dataArray[section];
    return [courseModel.isSelected boolValue] == YES ? courseModel.courseList.count:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpenCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OpenCourseModel *courseModel = self.dataArray[indexPath.section];
    OpenCourseListModel *listModel = courseModel.courseList[indexPath.row];
    cell.titleLabel.text = listModel.title;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpenCourseModel *courseModel = self.dataArray[indexPath.section];
    OpenCourseListModel *listModel = courseModel.courseList[indexPath.row];
    if ([self.courseDelegate respondsToSelector:@selector(openCourseTableViewCellClickedWithCourseModel:listModel:index:)]) {
        [self.courseDelegate openCourseTableViewCellClickedWithCourseModel:courseModel listModel:listModel index:indexPath.row];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenCourseListCellClicked" object:listModel];
}

@end
