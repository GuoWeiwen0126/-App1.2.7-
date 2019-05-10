
//
//  MKHistoryListTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/18.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKHistoryListTableView.h"
#import "MKModel.h"
#import "MKHistoryListCell.h"

@interface MKHistoryListTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
@end

@implementation MKHistoryListTableView

static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(nonnull NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MKHistoryListCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *temArray = _dataArray[section];
    EmkListModel *listModel = temArray.firstObject;
    return [NSString stringWithFormat:@"%ld 万人模考大赛",(long)listModel.year];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.emkListModel = _dataArray[indexPath.section][indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKExamHistoryListTableViewClicked" object:_dataArray[indexPath.section][indexPath.row]];
}

@end
