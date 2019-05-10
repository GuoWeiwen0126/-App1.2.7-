//
//  CourseOptionFirstTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionFirstTableView.h"
#import "Tools.h"
#import "CourseOptionFirstCell.h"
#import "CourseOptionModel.h"

@implementation CourseOptionFirstTableView
{
    NSArray *_dataArray;
    NSArray *_lineColorArray;
}
static NSString *cellID   = @"cellID";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _dataArray = dataArray;
        _lineColorArray = @[RGBA(60, 145, 249, 1.0), RGBA(255, 102, 102, 1.0), RGBA(0, 204, 153, 1.0), RGBA(249, 148, 61, 1.0), RGBA(108, 209, 35, 1.0), [UIColor blackColor], [UIColor redColor], MAIN_RGB];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CourseOptionFirstCell" bundle:nil] forCellReuseIdentifier:cellID];
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
    CourseSectionModel *courseSecModel = _dataArray[indexPath.row];
    NSInteger courseNumber = courseSecModel.infoList.count;
    NSInteger rowNumber = SCREEN_FIT_WITH_DEVICE(4, 6);
    if (courseNumber == 0) {
        return 50;
    } else {
        if (courseNumber < rowNumber) {
            return 40 + (UI_SCREEN_WIDTH - 20*2)/rowNumber * 0.8;
        } else if (courseNumber%rowNumber == 0) {
            return 40 + courseNumber/rowNumber * ((UI_SCREEN_WIDTH - 20*2)/rowNumber * 0.8);
        } else {
            return 40 + (courseNumber/rowNumber + 1) * (UI_SCREEN_WIDTH - 20*2)/rowNumber * 0.8;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseOptionFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CourseSectionModel *courseSecModel = _dataArray[indexPath.row];
    cell.courseNumber = courseSecModel.infoList.count;
    cell.TitleLabel.text = courseSecModel.title;
    cell.lineLabel.backgroundColor = _lineColorArray[indexPath.row];
    cell.collectionView.courseArray = courseSecModel.infoList;
    [cell.collectionView reloadData];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"______%ld--------",(long)indexPath.row);
}

@end
