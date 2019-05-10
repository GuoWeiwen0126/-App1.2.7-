//
//  LiveCourseTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveCourseTableView.h"
#import "LiveModel.h"
#import "LiveCourseTableViewHeaderView.h"
#import "LiveCourseTableViewCell.h"

@implementation LiveCourseTableView

static NSString *cellID = @"cellID";
static NSString *cellID_Header = @"cellID_Header";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"LiveCourseTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        [self registerClass:[LiveCourseTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:cellID_Header];
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
    LiveCourseTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID_Header];
    headerView.listModel = self.dataArray[section];
    headerView.tag = section;
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LiveClassListModel *temListModel = self.dataArray[section];
    return temListModel.isDefault == YES ? temListModel.basicList.count:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LiveClassListModel *listModel = self.dataArray[indexPath.section];
    cell.basicModel = listModel.basicList[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveClassListModel *temListModel = self.dataArray[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveCourseClicked" object:temListModel.basicList[indexPath.row]];
}
@end
