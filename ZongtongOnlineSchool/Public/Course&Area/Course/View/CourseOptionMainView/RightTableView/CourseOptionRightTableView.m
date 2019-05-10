//
//  CourseOptionRightTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionRightTableView.h"
#import "Tools.h"
#import "CourseOptionRightTableViewCell.h"
#import "CourseOptionModel.h"

@interface CourseOptionRightTableView ()
{
    
}
@end

@implementation CourseOptionRightTableView

static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CourseOptionRightTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseOptionRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CourseCellModel *courseCellModel = _dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:courseCellModel.eiIco]];
    cell.titleLabel.text = courseCellModel.title;
    cell.arrowImgView.hidden = courseCellModel.isCentCourse ? YES:NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.rightDelegate respondsToSelector:@selector(courseRightTableViewClickedWithIndex:cellModel:)]) {
        [self.rightDelegate courseRightTableViewClickedWithIndex:indexPath.row cellModel:_dataArray[indexPath.row]];
    }
}

@end
