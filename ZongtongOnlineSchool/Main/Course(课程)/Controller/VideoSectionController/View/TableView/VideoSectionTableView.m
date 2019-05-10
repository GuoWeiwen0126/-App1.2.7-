//
//  VideoSectionTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoSectionTableView.h"
#import "VideoSectionCell.h"
#import "VideoSectionModel.h"

@interface VideoSectionTableView () <UITableViewDelegate, UITableViewDataSource>
@end
static NSString *cellID = @"cellID";
@implementation VideoSectionTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"VideoSectionCell" bundle:nil] forCellReuseIdentifier:cellID];
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
    return 70.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.vSecStatus = self.vSecStatus;
    cell.vSectionModel = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSectionModel *vSectionModel = self.dataArray[indexPath.row];
    [tableView beginUpdates];
    if (vSectionModel.belowCount == 0)
    {
        //Data
        NSArray *infoList = [vSectionModel open];
        if (infoList.count == 0) {
            if (self.vSecStatus == 0) {  //课程
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoTableViewCellPlayVideo" object:vSectionModel];
            } else {  //讲义
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoTableViewCellOpenHandout" object:vSectionModel];
            }
        } else {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, infoList.count)];
            [self.dataArray insertObjects:infoList atIndexes:indexSet];
            //Rows
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < infoList.count; i ++)
            {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
                [indexArray addObject:insertIndexPath];
            }
            [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        //Data
        NSArray *infoList = [self.dataArray subarrayWithRange:NSMakeRange(indexPath.row + 1, vSectionModel.belowCount)];
        [vSectionModel closeWithInfoList:infoList];
        [self.dataArray removeObjectsInArray:infoList];
        //Rows
        NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < infoList.count; i ++)
        {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexArray addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
