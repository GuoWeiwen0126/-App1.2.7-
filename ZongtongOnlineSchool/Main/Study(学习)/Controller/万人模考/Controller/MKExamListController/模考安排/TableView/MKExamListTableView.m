//
//  MKExamListTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKExamListTableView.h"
#import "MKExamListHeaderView.h"
#import "MKExamListTableViewCell.h"
#import "MKModel.h"

@interface MKExamListTableView () <UITableViewDelegate, UITableViewDataSource>
@end
@implementation MKExamListTableView

static NSString *cellID = @"cellID";
static NSString *cellID_Header = @"cellID_Header";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(nonnull NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MKExamListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:cellID_Header];
        [self registerNib:[UINib nibWithNibName:@"MKExamListTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MKExamListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID_Header];
    headerView.emkListModel = self.dataArray[section];
    
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    EmkListModel *listModel = self.dataArray[section];
    if (listModel.isOpen) {
        return listModel.basicList.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKExamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EmkListModel *listModel = self.dataArray[indexPath.section];
    cell.basicListModel = listModel.basicList[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
