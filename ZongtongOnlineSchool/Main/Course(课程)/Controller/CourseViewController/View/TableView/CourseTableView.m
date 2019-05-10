//
//  CourseTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseTableView.h"
#import "CourseTableViewCell.h"
#import "VideoTypeModel.h"

@interface CourseTableView () <UITableViewDelegate, UITableViewDataSource>

@end
static NSString *cellID = @"cellID";
@implementation CourseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    VideoTypeModel *temModel = _dataArray[section][0];
    return [NSString stringWithFormat:@"%ld年视频课程",(long)temModel.vtYear];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VideoTypeModel *model = self.dataArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = model.vtTitle;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(courseTableViewCellClickedWithVTypeModel:)])
    {
        VideoTypeModel *vTypeModel = self.dataArray[indexPath.section][indexPath.row];
        [self.tableViewDelegate courseTableViewCellClickedWithVTypeModel:vTypeModel];
    }
}

@end
