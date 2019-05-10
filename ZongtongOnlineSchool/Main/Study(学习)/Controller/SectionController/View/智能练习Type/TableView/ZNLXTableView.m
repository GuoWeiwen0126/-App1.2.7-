//
//  ZNLXTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "ZNLXTableView.h"
#import "Tools.h"
#import "ZNLXCellModel.h"
#import "ZNLXTableViewCell.h"

@interface ZNLXTableView () <UITableViewDelegate, UITableViewDataSource>
@end

static NSString *cellID = @"cellID";

@implementation ZNLXTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"ZNLXTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return 80.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNLXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellModel = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNLXCellModel *cellModel = self.dataArray[indexPath.row];
    NSLog(@"Pid:***%ld***",(long)cellModel.pid);
    [tableView beginUpdates];
    if (cellModel.belowCount == 0)
    {
        //Data
        NSArray *basicList = [cellModel open];
        if (basicList.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZNLXTableViewCellWriteBtnClicked" object:cellModel];
        } else {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, basicList.count)];
            [self.dataArray insertObjects:basicList atIndexes:indexSet];
            //Rows
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < basicList.count; i ++)
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
        NSArray *basicList = [self.dataArray subarrayWithRange:NSMakeRange(indexPath.row + 1, cellModel.belowCount)];
        [cellModel closeWithBasicList:basicList];
        [self.dataArray removeObjectsInArray:basicList];
        //Rows
        NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < basicList.count; i ++)
        {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexArray addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
}


@end
