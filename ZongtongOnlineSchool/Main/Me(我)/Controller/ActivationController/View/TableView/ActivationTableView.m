//
//  ActivationTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ActivationTableView.h"
#import "Tools.h"
#import "ActivationHeaderView.h"
#import "ActivationCell.h"
#import "ActivationModel.h"

@interface ActivationTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ActivationHeaderView *headerView;
@end

@implementation ActivationTableView
static NSString *cellID = @"cellID";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"ActivationCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cdKeyArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerView.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.listModel = self.cdKeyArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
- (ActivationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ActivationHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 70)];
    }
    return _headerView;
}

@end
