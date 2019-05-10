//
//  CourseOptionNextTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/10.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionNextTableView.h"
#import "CourseOptionModel.h"
#import "CourseOptionNextTableViewCell.h"

@implementation CourseOptionNextTableView

static NSString *cellID = @"cellID";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CourseOptionNextTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.dataArray[section] count] > 0 ? 10.0f:0;
    }
    else
    {
        return [self.dataArray[section] count] > 0 ? 40.0f:0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"", @"公共科目",@"专业科目"][section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseOptionNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.listModel = self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseListModel *listModel = self.dataArray[indexPath.section][indexPath.row];
    if (listModel.clPublic != 1) {  //不是公共科目
        listModel.isSelected = listModel.isSelected == NO ? YES:NO;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
