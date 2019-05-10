//
//  LiveTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveTableView.h"
#import "LiveModel.h"
#import "LiveTableViewCell.h"
#import "LiveTableViewHeaderView.h"

@implementation LiveTableView

static NSString *cellID = @"cellID";
static NSString *cellID_Header = @"cellID_Header";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"LiveTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        [self registerClass:[LiveTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:cellID_Header];
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
    LiveTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID_Header];
    headerView.listModel = self.dataArray[section];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.001;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LiveClassListModel *temListModel = self.dataArray[section];
    return temListModel.typeList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LiveClassListModel *listModel = self.dataArray[indexPath.section];
    cell.listModel = listModel.typeList[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveClassListModel *temListModel = self.dataArray[indexPath.section];
    if (self.liveType == Live_OnLine) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveClassAllListOnLineClicked" object:temListModel.typeList[indexPath.row]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveClassAllListOffLineClicked" object:temListModel.typeList[indexPath.row]];
    }
}

@end
