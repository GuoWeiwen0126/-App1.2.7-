//
//  CourseOptionLeftTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionLeftTableView.h"
#import "Tools.h"
#import "CourseOptionLeftTableViewCell.h"
#import "CourseOptionModel.h"

@interface CourseOptionLeftTableView ()
{
    NSArray *_dataArray;
    NSArray *_lineColorArray;
}
@end

@implementation CourseOptionLeftTableView
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.backgroundColor = RGBA(244, 244, 244, 1.0);
        _dataArray = dataArray;
//        _lineColorArray = @[RGBA(60, 145, 249, 1.0),
//                            RGBA(255, 102, 102, 1.0),
//                            RGBA(0, 204, 153, 1.0),
//                            RGBA(249, 148, 61, 1.0),
//                            RGBA(209, 47, 249, 1.0),
//                            RGBA(13, 221, 240, 1.0),
//                            RGBA(108, 209, 35, 1.0),
//                            MAIN_RGB,
//                            MAIN_RGB,
//                            MAIN_RGB,
//                            MAIN_RGB,
//                            MAIN_RGB];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CourseOptionLeftTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
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
    CourseOptionLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CourseSectionModel *courseSecModel = _dataArray[indexPath.row];
    cell.lineView.backgroundColor = MAIN_RGB;
    cell.titleLabel.text = courseSecModel.title;
    if (indexPath.row == self.leftIndex) {
        cell.titleLabel.textColor = MAIN_RGB;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.titleLabel.textColor = MAIN_RGB_MainTEXT;
        cell.contentView.backgroundColor = RGBA(244, 244, 244, 1.0);
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.leftIndex = indexPath.row;
    [self reloadData];
    if ([self.leftDelegate respondsToSelector:@selector(courseLeftTableViewClickedWithIndex:)]) {
        [self.leftDelegate courseLeftTableViewClickedWithIndex:indexPath.row];
    }
}

@end
