//
//  OpenAppTypeTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenAppTypeTableView.h"
#import "OpenAppTypeTableViewCell.h"
#import "OpenCourseModel.h"

@implementation OpenAppTypeTableView
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray;
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"OpenAppTypeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpenAppTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserAppModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.typeName;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAppModel *model = self.dataArray[indexPath.row];
    if ([self.appTypeDelegate respondsToSelector:@selector(openAppTypeTableViewCellClickedWithOpenAppTypeModel:)]) {
        [self.appTypeDelegate openAppTypeTableViewCellClickedWithOpenAppTypeModel:model];
    }
}

@end
